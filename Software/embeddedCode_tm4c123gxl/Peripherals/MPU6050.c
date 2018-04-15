#ifdef MPU6050
#include "MPU6050.h"
#include "utils/uartstdio.h"
#include "math.h"

#define  NUMBER_OF_BIAS_SAMPLES 10
#define MCP4725_ADDR 0x62
#define WRITE_VOLTAGE_DAC 0x40
bool isGyroCalibrated = false;

int32_t g_i32gyro_readingZ_raw;

const float resolution = 32.8f;

float g_fgyroBias = 0;

uint32_t biasSampleCount = 0;

extern encoderReader g_sQEI1;

uint8_t buf[2];

uint16_t forceToBeWritten;
uint8_t dac1, dac2;
void writeDAC(uint8_t dac1, uint8_t dac2);

void initMPU6050()
{
    uint8_t i2cBuffer[5]; // Buffer for I2C data

    do
    {
        i2cBuffer[0] = i2cRead(MPU6050_ADDRESS, MPU6050_WHO_AM_I_M);
    }
    while (i2cBuffer[0] != MPU6050_WHO_AM_I_MPU6050);

    i2cWrite(MPU6050_ADDRESS, MPU6050_O_PWR_MGMT_1,
    MPU6050_PWR_MGMT_1_DEVICE_RESET);
    delay(100);
    while (i2cRead(MPU6050_ADDRESS, MPU6050_O_PWR_MGMT_1)
            & MPU6050_PWR_MGMT_1_DEVICE_RESET)
        ;
    delay(100);
    i2cWrite(MPU6050_ADDRESS, MPU6050_O_PWR_MGMT_1, 0x00); //MPU6050_PWR_MGMT_1_CLKSEL_ZG);

    i2cBuffer[0] = 0x07; //SMPRT_DIV = 7 , ODR =1Khz
    i2cBuffer[1] = MPU6050_CONFIG_DLPF_CFG_260_256; // //MPU6050_CONFIG_DLPF_CFG_184_188; // 184 Hz filter
    i2cBuffer[2] = MPU6050_GYRO_CONFIG_FS_SEL_1000; // +-1000deg/s
    i2cWriteData(MPU6050_ADDRESS, MPU6050_O_SMPLRT_DIV, i2cBuffer, 3); // Write to all three registers at once

    /* Enable Raw Data Ready Interrupt on INT pin and enable bypass/passthrough mode */
    i2cBuffer[0] = MPU6050_INT_PIN_CFG_INT_LEVEL
            | MPU6050_INT_PIN_CFG_INT_RD_CLEAR
            | MPU6050_INT_PIN_CFG_LATCH_INT_EN;
    i2cBuffer[1] = MPU6050_INT_ENABLE_DATA_RDY_EN; // data ready interrupt
    i2cWriteData(MPU6050_ADDRESS, MPU6050_O_INT_PIN_CFG, i2cBuffer, 2); // Write to both registers at once

    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOE); //enable portE
    HWREG(GPIO_PORTE_BASE + GPIO_O_LOCK) = GPIO_LOCK_KEY; //PF0 needs to be unlocked
    HWREG(GPIO_PORTE_BASE + GPIO_O_CR) = 0x1F;
    ROM_GPIOPinTypeGPIOInput(GPIO_PORTE_BASE, GPIO_PIN_3);
    ROM_GPIOPadConfigSet(GPIO_PORTE_BASE, GPIO_PIN_3, GPIO_STRENGTH_8MA,
    GPIO_PIN_TYPE_STD);

    ROM_GPIOIntTypeSet(GPIO_PORTE_BASE, GPIO_PIN_3, GPIO_FALLING_EDGE); //for pin 0,4 enable falling edge interrupt
    GPIOIntRegister(GPIO_PORTE_BASE, GPIOEHandler6050); //portf_int_handler is the interrupt handler
    IntPrioritySet(INT_GPIOF_TM4C123, PRIORITY_5);  // Highest-1 priority

    delay(100); // Wait for sensor to stabilize
    GPIOIntEnable(GPIO_PORTE_BASE, GPIO_PIN_3); //enable pf0, pf4 interrupts
}

void GPIOEHandler6050(void)
{
    float error;
    float K;

    GPIOIntClear(GPIO_PORTE_BASE, GPIO_PIN_3); //clear corresponding interrupts

    ////////////////////////////////////////////////////////////
    // Measurement Readings
    ////////////////////////////////////////////////////////////
    i2cReadData(MPU6050_ADDRESS, MPU6050_O_GYRO_ZOUT_H, buf, 2);
    g_i32gyro_readingZ_raw = (int16_t) ((buf[0] << 8) | buf[1]);

    g_fgyroVelocity = (float) g_i32gyro_readingZ_raw / resolution;

    i2cRead(MPU6050_ADDRESS, 0x3A); // Clear MPU6050 interrupt
    g_fposition_prev = g_fposition;
    g_fposition = get_pos_minus180_plus180(&g_sQEI1);

    ///////////////////////////////////////////////
    // End Measurement Reading
    //////////////////////////////////////////////
    // If gyro calibration is done, subtract the bias

    if (isGyroCalibrated)
    {
        g_fgyroVelocity -= g_fgyroBias;
        //////////////////////////////////////////////////////////////
        // Kalman Filter
        /////////////////////////////////////////////////////////////

        ///////////////////////////////////
        // Time Update
        ///////////////////////////////////
        g_fposition_filtered_minus = g_fposition_filtered_plus
                + g_fdelta_t * g_fgyroVelocity;
        g_fP_minus = g_fP_plus + g_fQ_model;
        ///////////////////////////////////
        // Measurement Update
        ///////////////////////////////////
        if (g_fposition_prev == g_fposition)
        {
            g_fposition_filtered_plus = g_fposition_filtered_minus;
            g_fP_plus = g_fP_minus;
        }
        else
        {
            error = g_fposition - g_fposition_filtered_minus; // Measurement error
            K = g_fP_minus / (g_fP_minus + g_fR_encoder);

            g_fposition_filtered_plus = g_fposition_filtered_minus + K * error;
            g_fP_plus = (1.0f - K) * g_fP_minus;
        }
        /////////////////////////////////////////////////////////////////
        // End Kalman Filter
        /////////////////////////////////////////////////////////////////

        g_fpedalLinearPosition = R_pedal
                * sinf(g_fposition_filtered_plus * DEGREE_TO_RADIAN);
        g_fpedalLinearVelocity =
                R_pedal
                        * cosf(g_fposition_filtered_plus * DEGREE_TO_RADIAN) * g_fgyroVelocity * DEGREE_TO_RADIAN;

        /////////////////////////////////////////////////////////////////
        // SPRING MASS SIMULATION
        /////////////////////////////////////////////////////////////////
        g_fMassPosition = A_0_0 * g_fMassPosition_prev
                + A_0_1 * g_fMassVelocity_prev;
        g_fMassPosition = g_fMassPosition + B_0_0 * g_fpedalLinearPosition
                + B_0_1 * g_fpedalLinearVelocity;

        g_fMassVelocity = A_1_0 * g_fMassPosition_prev
                + A_1_1 * g_fMassVelocity_prev;
        g_fMassVelocity = g_fMassVelocity + B_1_0 * g_fpedalLinearPosition
                + B_1_1 * g_fpedalLinearVelocity;

        g_fMassPosition_prev = g_fMassPosition;
        g_fMassVelocity_prev = g_fMassVelocity;

        g_fspringForce = (g_fpedalLinearPosition - g_fMassPosition) * k_spring;
        g_fdamperForce = (g_fpedalLinearVelocity - g_fMassVelocity) * b_damper;
        g_ftotalForce = g_fspringForce + g_fdamperForce;
        g_ftotalForce = g_ftotalForce * 10;

        if (g_ftotalForce < 0)
            g_ftotalForce = -1 * g_ftotalForce;

        forceToBeWritten = (uint16_t) (g_ftotalForce * 1);
        forceToBeWritten = forceToBeWritten << 4;

        dac1 = forceToBeWritten >> 8;

        dac2 = (forceToBeWritten & 0x00FF);

        writeDAC(dac1, dac2);

        g_ui32measurementTime = micros();
        /////////////////////////////////////////////////////////////////
        // Transmission with the computer
        /////////////////////////////////////////////////////////////////
        UARTwrite(delimStr, 2); // Begin delimiter

        UARTwrite(timePointer, 4); //Transmit time instance

        UARTwrite(linearPedalPositionPointer, 4);
        UARTwrite(massPositionPointer, 4);

        UARTwrite(linearPedalVelocityPointer, 4);
        UARTwrite(massVelocityPointer, 4);

        //UARTwrite(totalForcePointer, 4);

        UARTwrite(delimStr + 2, 3); // End delimiter and newline
        //////////////////////////////////////////////////////////////////
        // End Transmission
        //////////////////////////////////////////////////////////////////
    }
    else if (biasSampleCount < NUMBER_OF_BIAS_SAMPLES)
    {
        GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_3, ~GPIO_PIN_3);
        g_fgyroBias += g_fgyroVelocity;
        if (biasSampleCount == NUMBER_OF_BIAS_SAMPLES - 1) // Gyro calibration is done
        {
            g_fgyroBias = g_fgyroBias / NUMBER_OF_BIAS_SAMPLES;
            isGyroCalibrated = true;
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_3, GPIO_PIN_3);
        }
        biasSampleCount++;
    }
}
void writeDAC(uint8_t dac1, uint8_t dac2)
{
    I2CMasterSlaveAddrSet(I2C0_BASE, MCP4725_ADDR, false); // Set to write mode

    I2CMasterDataPut(I2C0_BASE, WRITE_VOLTAGE_DAC); // Place address into data register
    I2CMasterControl(I2C0_BASE, I2C_MASTER_CMD_BURST_SEND_START); // Send start condition
    while (I2CMasterBusy(I2C0_BASE))
    {
    }

    I2CMasterDataPut(I2C0_BASE, dac1); // Place data into data register
    I2CMasterControl(I2C0_BASE, I2C_MASTER_CMD_BURST_SEND_CONT); // Send continues condition
    while (I2CMasterBusy(I2C0_BASE))
    {
    }

    I2CMasterDataPut(I2C0_BASE, dac2); // Place data into data register
    I2CMasterControl(I2C0_BASE, I2C_MASTER_CMD_BURST_SEND_FINISH); // Send finish condition
    while (I2CMasterBusy(I2C0_BASE))
    {
    }

}
#endif
