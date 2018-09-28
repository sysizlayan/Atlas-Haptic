#include "MPU6050.h"
#include "hw_MPU6050.h"
#include "stm32f7xx_hal.h"
#include <stdint.h>
#include "math.h"
#include "flagSet.h"
#include "main.h"
#include "usart.h"
#include "i2c.h"
#include "tim.h"
#include "simulation/pedalVariables.h"
#include "simulation/massStatesCalculation.h"

#define NUMBER_OF_BIAS_SAMPLES 	1000
#define MCP4725_ADDR 			0x62
#define WRITE_VOLTAGE_DAC 		0x40

const float gyroResolution 		= 32.8f;
const float encoderResolution 	= 0.18f;

uint16_t forceToBeWritten;
uint8_t dac1, dac2;
void writeDAC(uint8_t dac1, uint8_t dac2);

enum hapticDeviceStates
{
	BEGIN,
	CALIBRATION,
	RUNNING,
	STOPPED
};

uint8_t beginDelimiter[] = {'$','$'};
uint8_t endDelimiter[]   = {'*','*'};

uint8_t hapticDeviceState;
uint32_t loopCount;
uint8_t initMPU6050()
{
	uint8_t statusCounter = 0;

	uint8_t who_am_i;
	if(HAL_I2C_Mem_Read(&hi2c1, MPU6050_ADDRESS, MPU6050_O_WHO_AM_I, I2C_MEMADD_SIZE_8BIT, &who_am_i, sizeof(who_am_i), 100) == HAL_OK)
	{
		if(who_am_i == MPU6050_WHO_AM_I_MPU6050)
		{
			HAL_GPIO_WritePin(LD2_GPIO_Port,LD2_Pin,GPIO_PIN_SET);
			HAL_Delay(1000);
			HAL_GPIO_WritePin(LD2_GPIO_Port,LD2_Pin,GPIO_PIN_RESET);
			hapticFlagSet.isIMUDiscovered= true;
		}
	}
	HAL_Delay(1000);
	uint8_t i2cBuffer[5];
	if(hapticFlagSet.isIMUDiscovered)
	{
		i2cBuffer[0] = MPU6050_PWR_MGMT_1_DEVICE_RESET;
		if(HAL_I2C_Mem_Write(&hi2c1,MPU6050_ADDRESS, MPU6050_O_PWR_MGMT_1, I2C_MEMADD_SIZE_8BIT, i2cBuffer, 1, 100) == HAL_OK)
		{
			HAL_Delay(100);
			i2cBuffer[0] = 0x00;
			if(HAL_I2C_Mem_Write(&hi2c1,MPU6050_ADDRESS, MPU6050_O_PWR_MGMT_1, I2C_MEMADD_SIZE_8BIT, i2cBuffer, 1, 100) == HAL_OK)
				statusCounter++;
			i2cBuffer[0] = 0x07; //SMPRT_DIV = 7 , ODR =1Khz
			i2cBuffer[1] = MPU6050_CONFIG_DLPF_CFG_260_256; // //MPU6050_CONFIG_DLPF_CFG_184_188; // 184 Hz filter
			i2cBuffer[2] = MPU6050_GYRO_CONFIG_FS_SEL_1000; // +-1000deg/s
			if(HAL_I2C_Mem_Write(&hi2c1, MPU6050_ADDRESS, MPU6050_O_SMPLRT_DIV, I2C_MEMADD_SIZE_8BIT, i2cBuffer, 3, 200) == HAL_OK)
			{
				HAL_GPIO_WritePin(LD2_GPIO_Port,LD2_Pin,GPIO_PIN_SET);
				HAL_Delay(1000);
				HAL_GPIO_WritePin(LD2_GPIO_Port,LD2_Pin,GPIO_PIN_RESET);
				HAL_Delay(1000);
				statusCounter++;
			}
			i2cBuffer[0] = MPU6050_INT_PIN_CFG_INT_LEVEL
					//| MPU6050_INT_PIN_CFG_INT_RD_CLEAR
					| MPU6050_INT_PIN_CFG_LATCH_INT_EN;
			i2cBuffer[1] = MPU6050_INT_ENABLE_DATA_RDY_EN; // data ready interrupt
			if(HAL_I2C_Mem_Write(&hi2c1, MPU6050_ADDRESS, MPU6050_O_INT_PIN_CFG, I2C_MEMADD_SIZE_8BIT, i2cBuffer, 2, 200) == HAL_OK)
			{
				HAL_GPIO_WritePin(LD2_GPIO_Port,LD2_Pin,GPIO_PIN_SET);
				HAL_Delay(1000);
				HAL_GPIO_WritePin(LD2_GPIO_Port,LD2_Pin,GPIO_PIN_RESET);
				HAL_Delay(1000);

				if(HAL_I2C_Mem_Read(&hi2c1, MPU6050_ADDRESS, MPU6050_O_INT_PIN_CFG, I2C_MEMADD_SIZE_8BIT, i2cBuffer+2, 2, 200) == HAL_OK)
				{
					__NOP();
				}
				statusCounter++;
			}
		}
	}
	return statusCounter;
}

void hapticLoop(void)
{
	static float 	gyroBias 		= 0;
	static uint32_t gyroBiasSamples = 0;

	float error, kalmanGain;
	int32_t gyroReadingRaw;
	float gyroReading = 0;
	float encoderReading = 0;

	uint8_t outBuffer[32];

	// Gyro Reading
	if(HAL_I2C_Mem_Read(&hi2c1, MPU6050_ADDRESS, MPU6050_O_GYRO_ZOUT_H, I2C_MEMADD_SIZE_8BIT, outBuffer, 2, 10) == HAL_OK)
	{
		// Read 2 byte value
		gyroReadingRaw = (int16_t) (((uint16_t)outBuffer[0] << 8) | outBuffer[1]);
		// Float conversion
		gyroReading = (float)gyroReadingRaw / gyroResolution;
	}

	// Encoder Reading
	encoderReading = htim1.Instance->CNT;
	encoderReading *= encoderResolution;

	if(encoderReading > 180 && encoderReading <= 360)
		encoderReading =  encoderReading - 360.0f;
	pedalVariables.measuredVariables.positionPrevious = pedalVariables.measuredVariables.position;
	switch(hapticDeviceState)
	{
	case BEGIN:
		hapticDeviceState = CALIBRATION;
		break;
	case CALIBRATION:
		if(gyroBiasSamples < NUMBER_OF_BIAS_SAMPLES)
		{
			gyroBias += gyroReading;
			gyroBiasSamples++;
		}
		else if(gyroBiasSamples == NUMBER_OF_BIAS_SAMPLES)
		{
			gyroBias /= NUMBER_OF_BIAS_SAMPLES;
			HAL_GPIO_WritePin(LD2_GPIO_Port,LD2_Pin,GPIO_PIN_SET);
			hapticDeviceState = RUNNING;
		}
		break;
	case RUNNING:
		loopCount++;
		// Subtract the bias
		gyroReading -= gyroBias;
		pedalVariables.measuredVariables.gyroVelocity = gyroReading;
		pedalVariables.measuredVariables.position	  = encoderReading;

		pedalVariables.estimatedVariables.positionFilterMinus = pedalVariables.estimatedVariables.positionFilterPlus
																+ pedalVariables.kalmanConstants.delta_t
																* pedalVariables.measuredVariables.gyroVelocity ;

		pedalVariables.estimatedVariables.P_Minus = pedalVariables.estimatedVariables.P_Plus
													+ pedalVariables.kalmanConstants.Q_model;

		// Kalman Filter
		// Same measurement has come, only do time update
		if(pedalVariables.measuredVariables.positionPrevious == pedalVariables.measuredVariables.position)
		{
			pedalVariables.estimatedVariables.positionFilterPlus = pedalVariables.estimatedVariables.positionFilterMinus;
			pedalVariables.estimatedVariables.P_Plus 			 = pedalVariables.estimatedVariables.P_Minus;
		}
		// New measurement has come
		else
		{
			error = pedalVariables.measuredVariables.position - pedalVariables.estimatedVariables.positionFilterMinus;
			kalmanGain = pedalVariables.estimatedVariables.P_Minus
						 / (pedalVariables.estimatedVariables.P_Minus + pedalVariables.kalmanConstants.R_encoder);
			pedalVariables.estimatedVariables.positionFilterPlus = pedalVariables.estimatedVariables.positionFilterMinus
																   + kalmanGain * error;
			pedalVariables.estimatedVariables.P_Plus = (1.0f - kalmanGain) * pedalVariables.estimatedVariables.P_Minus;
		}

		calculateMassStatesAndForces(loopCount);

		HAL_UART_Transmit(&huart3, beginDelimiter, 2, 10);
		HAL_UART_Transmit(&huart3, &loopCount, 4, 10);
		HAL_UART_Transmit(&huart3, &(pedalVariables.measuredVariables.position), 4, 10);
		HAL_UART_Transmit(&huart3, &(pedalVariables.measuredVariables.gyroVelocity), 4, 10);
		HAL_UART_Transmit(&huart3, &(pedalVariables.estimatedVariables.positionFilterPlus), 4, 10);

		/*HAL_UART_Transmit(&huart3, &(pedalVariables.estimatedVariables.positionFilterPlus), 4, 10);

		HAL_UART_Transmit(&huart3, &(pedalVariables.estimatedVariables.positionFilterPlus), 4, 10);

		HAL_UART_Transmit(&huart3, &(pedalVariables.estimatedVariables.positionFilterPlus), 4, 10);

		HAL_UART_Transmit(&huart3, &(pedalVariables.estimatedVariables.positionFilterPlus), 4, 10);*/

		//HAL_UART_Transmit(&huart3, &(pedalVariables.estimatedVariables.positionFilterPlus), 4, 10);

		//HAL_UART_Transmit(&huart3, &(pedalVariables.estimatedVariables.positionFilterPlus), 4, 10);

		HAL_UART_Transmit(&huart3, endDelimiter, 2, 10);
		break;
	case STOPPED:
		break;
	}
	HAL_I2C_Mem_Read(&hi2c1, MPU6050_ADDRESS, MPU6050_O_INT_STATUS, I2C_MEMADD_SIZE_8BIT, outBuffer, 1, 10);
}
void writeToDAC(uint8_t dac1, uint8_t dac2)
{

}
