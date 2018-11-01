#include <haptic.h>
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
#include "experimentConfig.h"

#define NUMBER_OF_BIAS_SAMPLES 	3000
#define MCP4725_ADDR 			0x62 << 1
#define WRITE_VOLTAGE_DAC 		0x40

const float gyroResolution 		= 32.8f;
const float encoderResolution 	= 0.18f;

uint8_t beginDelimiter[] = {'$','$'};
uint8_t endDelimiter[]   = {'*','*'};
#define DUMMY_LOAD_SIZE 20
float dummyLoad[DUMMY_LOAD_SIZE];

#define ITM_Port32(n) (*((volatile unsigned long *)(0xE0000000+4*n)))

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
			HAL_Delay(250);
			HAL_GPIO_WritePin(LD2_GPIO_Port,LD2_Pin,GPIO_PIN_RESET);
			HAL_Delay(250);
			hapticFlagSet.isIMUDiscovered= true;
		}
	}
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
				HAL_Delay(250);
				HAL_GPIO_WritePin(LD2_GPIO_Port,LD2_Pin,GPIO_PIN_RESET);
				HAL_Delay(250);
				statusCounter++;
			}
			i2cBuffer[0] = MPU6050_INT_PIN_CFG_INT_LEVEL
					//| MPU6050_INT_PIN_CFG_INT_RD_CLEAR
					| MPU6050_INT_PIN_CFG_LATCH_INT_EN;
			i2cBuffer[1] = MPU6050_INT_ENABLE_DATA_RDY_EN; // data ready interrupt
			if(HAL_I2C_Mem_Write(&hi2c1, MPU6050_ADDRESS, MPU6050_O_INT_PIN_CFG, I2C_MEMADD_SIZE_8BIT, i2cBuffer, 2, 200) == HAL_OK)
			{
				HAL_GPIO_WritePin(LD2_GPIO_Port,LD2_Pin,GPIO_PIN_SET);
				HAL_Delay(250);
				HAL_GPIO_WritePin(LD2_GPIO_Port,LD2_Pin,GPIO_PIN_RESET);
				HAL_Delay(250);

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
	static float 	gyroBias 			= 0;
	static uint32_t gyroBiasSamples 	= 0;


	float error, kalmanGain;
	int32_t gyroReadingRaw;
	float gyroReading = 0;
	float encoderReading = 0;

	uint8_t outBuffer[8];

	// If gyrometer can be read
	if(HAL_I2C_Mem_Read(&hi2c1, MPU6050_ADDRESS, MPU6050_O_GYRO_ZOUT_H, I2C_MEMADD_SIZE_8BIT, outBuffer, 2, 10) == HAL_OK)
	{
		// Read 2 byte value
		gyroReadingRaw = (int16_t) (((uint16_t)outBuffer[0] << 8) | outBuffer[1]);
		// Float conversion
		gyroReading = (float)gyroReadingRaw / gyroResolution;

		switch(experimentConfig.hapticDeviceState)
		{
		case BEGIN:
			experimentConfig.hapticDeviceState = CALIBRATION;
			for(int i = 0; i< DUMMY_LOAD_SIZE; i++)
				dummyLoad[i] = -1000000.0f;
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
				experimentConfig.hapticDeviceState = WAITING_JSON;
				//HAL_NVIC_DisableIRQ(EXTI15_10_IRQn);
			}
			break;
		case RUNNING:
			loopCount++;
			if(loopCount%100 == 0)
				HAL_GPIO_TogglePin(LD2_GPIO_Port,LD2_Pin);

			// Subtract the bias
			pedalVariables.measuredVariables.gyroVelocity = gyroReading - gyroBias;

			// Encoder reading
			pedalVariables.measuredVariables.positionPrevious 	= pedalVariables.measuredVariables.position;
			pedalVariables.measuredVariables.position	  		= htim1.Instance->CNT;
			pedalVariables.measuredVariables.position    	   *= encoderResolution;

			if(pedalVariables.measuredVariables.position >180 && encoderReading <= 360)
			   pedalVariables.measuredVariables.position -= 360.0f;

			// Time innovation
			pedalVariables.estimatedVariables.positionFilterMinus = pedalVariables.estimatedVariables.positionFilterPlus
																	+ pedalVariables.kalmanConstants.delta_t
																	* pedalVariables.measuredVariables.gyroVelocity ;

			pedalVariables.estimatedVariables.P_Minus = pedalVariables.estimatedVariables.P_Plus
														+ pedalVariables.kalmanConstants.Q_model;

			// Kalman Filter
			// Same measurement has come, only do time updates
			if(pedalVariables.measuredVariables.positionPrevious == pedalVariables.measuredVariables.position)
			{
				pedalVariables.estimatedVariables.positionFilterPlus = pedalVariables.estimatedVariables.positionFilterMinus;
				pedalVariables.estimatedVariables.P_Plus 			 = pedalVariables.estimatedVariables.P_Minus;
			}
			// New measurement has come, measurement updateaa
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

			giveHapticFeedback(g_ssimulatedForces.totalForce);

			if(loopCount == experimentConfig.period-1)
			{
				experimentConfig.hapticDeviceState = STOPPED;
			}
			break;
		case STOPPED:
			giveHapticFeedback(0);
			g_ssimulatedForces.totalForce = 0;
			g_ssimulatedMassStates.massPosition = 0;
			g_ssimulatedMassStates.massVelocity = 0;
			g_ssimulatedMassStates_prev.massPosition = 0;
			g_ssimulatedMassStates_prev.massVelocity = 0;
			loopCount = 0;
			HAL_UART_Transmit(&huart3, beginDelimiter, 2, 10);
			HAL_UART_Transmit(&huart3, (uint8_t*)&loopCount, 4, 10);
			HAL_UART_Transmit(&huart3, (uint8_t*)dummyLoad, DUMMY_LOAD_SIZE, 10);
			HAL_UART_Transmit(&huart3, endDelimiter, 2, 10);
			experimentConfig.hapticDeviceState = WAITING_JSON;
			break;
		default:
			__NOP();
		}

		// Send the variables if the state is running
		if(experimentConfig.hapticDeviceState == RUNNING)
		{
			HAL_UART_Transmit(&huart3, beginDelimiter, 2, 10);
			HAL_UART_Transmit(&huart3, (uint8_t*)&loopCount, 4, 10);
			HAL_UART_Transmit(&huart3, (uint8_t*)&(pedalVariables.measuredVariables.position), 4, 10);
			HAL_UART_Transmit(&huart3, (uint8_t*)&(pedalVariables.estimatedVariables.positionFilterPlus), 4, 10);
			HAL_UART_Transmit(&huart3, (uint8_t*)&(pedalVariables.measuredVariables.gyroVelocity), 4, 10);
			HAL_UART_Transmit(&huart3, (uint8_t*)&(g_ssimulatedMassStates.massPosition), 4, 10);
			HAL_UART_Transmit(&huart3, (uint8_t*)&(g_ssimulatedMassStates.massVelocity), 4, 10);

			/*HAL_UART_Transmit(&huart3, &(pedalVariables.estimatedVariables.positionFilterPlus), 4, 10);

			HAL_UART_Transmit(&huart3, &(pedalVariables.estimatedVariables.positionFilterPlus), 4, 10);

			HAL_UART_Transmit(&huart3, &(pedalVariables.estimatedVariables.positionFilterPlus), 4, 10);

			HAL_UART_Transmit(&huart3, &(pedalVariables.estimatedVariables.positionFilterPlus), 4, 10);*/

			//HAL_UART_Transmit(&huart3, &(pedalVariables.estimatedVariables.positionFilterPlus), 4, 10);

			//HAL_UART_Transmit(&huart3, &(pedalVariables.estimatedVariables.positionFilterPlus), 4, 10);

			HAL_UART_Transmit(&huart3, endDelimiter, 2, 10);

		}

		HAL_I2C_Mem_Read(&hi2c1, MPU6050_ADDRESS, MPU6050_O_INT_STATUS, I2C_MEMADD_SIZE_8BIT, outBuffer, 1, 10);

	}
}

void giveHapticFeedback(float force)
{
	float tmpForce;
	// If there is some errors in the force calculation or the force is too large,
	// saturate it not to harm the device or cause problem in conversion
	if(force < 0.0f)
		tmpForce = 0.0f;
	else if(force > 4095.0f)
		tmpForce = 4095.0f;
	else
		tmpForce = force;
	int16_t conversionTmp = (int16_t)tmpForce;

	uint16_t hapticForce = (uint16_t)(conversionTmp);
	uint8_t DAC_BYTE1, DAC_BYTE2;
	DAC_BYTE2 = (uint8_t)(hapticForce&0x00FF); // Only take last byte
	DAC_BYTE1 = (uint8_t)((hapticForce&0x0F00)>>8); //Take remaning 4 bits of data
	// We want to use MCP4725 in fast mode, so DAC_BYTE1 become address and DAC_BYTE2 is the value

	HAL_I2C_Mem_Write(&hi2c2,MCP4725_ADDR, DAC_BYTE1, I2C_MEMADD_SIZE_8BIT, &DAC_BYTE2, 1, 10);
}
