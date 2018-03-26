/*
 * mpu6050.cpp
 *
 *  Created on: 25 Mar 2018
 *      Author: Yigit
 */

#include "mpu6050.hpp"
const float resolution = 32.8; //  from datasheet, LSB/(º/s)

bool isGyroCalibrated = false;
float g_fgyroBias = 0.0f;
int32_t gyroReading;
uint8_t i2cBuffer[8]; // Buffer for I2C data
void initMPU6050(void)
{

    delay(100);
    do
    {
        i2cBuffer[0] = i2cRead(MPU6050_ADDRESS, MPU6050_WHO_AM_I_M);
    }
    while (i2cBuffer[0] != MPU6050_WHO_AM_I_MPU6050);

    /*i2cWrite(MPU6050_ADDRESS, MPU6050_O_PWR_MGMT_1,
     MPU6050_PWR_MGMT_1_DEVICE_RESET);
     delay(10);
     do
     {
     i2cInBuffer[0] = i2cRead(MPU6050_ADDRESS, MPU6050_O_PWR_MGMT_1);
     }
     while (i2cInBuffer[0]);

     delay(10);
     do
     {
     i2cWrite(MPU6050_ADDRESS, MPU6050_O_PWR_MGMT_1, 0x08); //MPU6050_PWR_MGMT_1_CLKSEL_ZG);
     delay(1);
     i2cInBuffer[0] = i2cRead(MPU6050_ADDRESS, MPU6050_O_PWR_MGMT_1);
     }
     while (i2cInBuffer[0] != 0x08);

     delay(10);
     do
     {
     i2cWrite(MPU6050_ADDRESS, MPU6050_O_SMPLRT_DIV, 7);
     delay(1);
     i2cInBuffer[0] = i2cRead(MPU6050_ADDRESS, MPU6050_O_SMPLRT_DIV);
     }
     while (i2cInBuffer[0] != 7);

     delay(10);
     do
     {
     i2cWrite(MPU6050_ADDRESS, MPU6050_O_CONFIG,
     MPU6050_CONFIG_DLPF_CFG_260_256);
     delay(1);
     i2cInBuffer[0] = i2cRead(MPU6050_ADDRESS, MPU6050_O_CONFIG);
     }
     while (i2cInBuffer[0] != MPU6050_CONFIG_DLPF_CFG_260_256);

     delay(10);
     do
     {
     i2cWrite(MPU6050_ADDRESS, MPU6050_O_GYRO_CONFIG,
     MPU6050_GYRO_CONFIG_FS_SEL_1000);
     delay(1);
     i2cInBuffer[0] = i2cRead(MPU6050_ADDRESS, MPU6050_O_GYRO_CONFIG);
     }
     while (i2cInBuffer[0] != MPU6050_GYRO_CONFIG_FS_SEL_1000);

     delay(10);
     i2cInBuffer[0] = i2cRead(MPU6050_ADDRESS, MPU6050_O_SMPLRT_DIV); // Read to all three registers at once, debug
     delay(10);
     i2cInBuffer[0] = i2cRead(MPU6050_ADDRESS, MPU6050_O_CONFIG); // Read to all three registers at once, debug
     delay(10);
     i2cInBuffer[0] = i2cRead(MPU6050_ADDRESS, MPU6050_O_GYRO_CONFIG); // Read to all three registers at once, debug
     */

    i2cWrite(MPU6050_ADDRESS, MPU6050_O_PWR_MGMT_1, (1 << 7)); // Reset device, this resets all internal registers to their default values
    delay(100);
    while (i2cRead(MPU6050_ADDRESS, MPU6050_O_PWR_MGMT_1) & (1 << 7))
    {
        // Wait for the bit to clear
    };
    delay(100);
    i2cWrite(MPU6050_ADDRESS, MPU6050_O_PWR_MGMT_1, (1 << 3) | (1 << 0)); // Disable sleep mode, disable temperature sensor and use PLL as clock reference
    delay(1000);
    i2cBuffer[0] = 0x07; // Set the sample rate to 1kHz - 1kHz/(1+0) = 1kHz
    i2cBuffer[1] = 0; // Disable FSYNC and set 41 Hz Gyro filtering, 1 KHz sampling
    i2cBuffer[2] = 1 << 4; // Set Gyro Full Scale Range to +-1000deg/s

    i2cWriteData(MPU6050_ADDRESS, MPU6050_O_SMPLRT_DIV, i2cBuffer, 3); // Write to all three registers at once
    i2cReadData(MPU6050_ADDRESS, MPU6050_O_SMPLRT_DIV, i2cBuffer, 3); // Write to all three registers at once
    /* Enable Raw Data Ready Interrupt on INT pin and enable bypass/passthrough mode */
    i2cBuffer[0] = (1 << 5) | (1 << 4) | (1 << 1); // Enable LATCH_INT_EN, INT_ANYRD_2CLEAR and BYPASS_EN
                                                   // When this bit is equal to 1, the INT pin is held high until the interrupt is cleared
                                                   // When this bit is equal to 1, interrupt status is cleared if any read operation is performed
                                                   // When asserted, the I2C_MASTER interface pins (ES_CL and ES_DA) will go into 'bypass mode' when the I2C master interface is disabled
    i2cBuffer[1] = (1 << 0); // Enable RAW_RDY_EN - When set to 1, Enable Raw Sensor Data Ready interrupt to propagate to interrupt pin
    i2cWriteData(MPU6050_ADDRESS, MPU6050_O_INT_PIN_CFG, i2cBuffer, 2); // Write to both registers at once
    i2cReadData(MPU6050_ADDRESS, MPU6050_O_INT_PIN_CFG, i2cBuffer, 2); // Write to both registers at once
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOP); //enable portE

    GPIOPinTypeGPIOInput(GPIO_PORTP_BASE, GPIO_PIN_4);
    GPIOPadConfigSet(GPIO_PORTP_BASE, GPIO_PIN_4, GPIO_STRENGTH_2MA,
                     GPIO_PIN_TYPE_STD);

    /*GPIOIntDisable(GPIO_PORTP_BASE, GPIO_PIN_4); // Disable interrupt for PP4 (in case it was enabled)
    GPIOIntClear(GPIO_PORTP_BASE, GPIO_PIN_4);

    GPIOIntRegister(GPIO_PORTP_BASE, GPIOEHandler6050);

    GPIOIntTypeSet(GPIO_PORTP_BASE, GPIO_PIN_4, GPIO_FALLING_EDGE); // Pin PP4 has falling edge interrupt

    IntPrioritySet(INT_GPIOP0_TM4C129, PRIORITY_5);  // Highest-1 priority

    GPIOIntEnable(GPIO_PORTP_BASE, GPIO_PIN_4); //enable PP4 interrupts*/

    /*i2cOutBuffer[0] = 0b10000000; //MPU6050_INT_PIN_CFG_INT_LEVEL |MPU6050_INT_PIN_CFG_INT_RD_CLEAR |MPU6050_INT_PIN_CFG_LATCH_INT_EN;
    i2cWrite(MPU6050_ADDRESS, MPU6050_O_INT_PIN_CFG, i2cOutBuffer[0]);
    delay(10);

    i2cOutBuffer[1] = 0b00000001; // data ready interrupt
    i2cWrite(MPU6050_ADDRESS, MPU6050_O_INT_ENABLE, i2cOutBuffer[1]);
    delay(10);

    i2cReadData(MPU6050_ADDRESS, MPU6050_O_INT_PIN_CFG, i2cInBuffer, 2);*/

    tm4c1294xl_leds.openLed(0);
    tm4c1294xl_leds.openLed(1);
    tm4c1294xl_leds.openLed(2);
    tm4c1294xl_leds.openLed(3);
    delay(200);

    tm4c1294xl_leds.closeLed(0);
    tm4c1294xl_leds.closeLed(1);
    tm4c1294xl_leds.closeLed(2);
    tm4c1294xl_leds.closeLed(3);

    i2cReadData(MPU6050_ADDRESS, MPU6050_O_SMPLRT_DIV, i2cBuffer, 3); // Write to all three registers at once
    delay(10);
    i2cReadData(MPU6050_ADDRESS, MPU6050_O_INT_PIN_CFG, i2cBuffer, 2); // Write to both registers at once
}

void GPIOEHandler6050(void)
{
    /*
    float error;
    float K;

    uint8_t buf[2];
    GPIOIntClear(GPIO_PORTP_BASE, GPIO_PIN_4); //clear corresponding interrupts
    tm4c1294xl_leds.openLed(1);
    ////////////////////////////////////////////////////////////
    // Measurement Readings
    ////////////////////////////////////////////////////////////
    i2cReadData(MPU6050_ADDRESS, MPU6050_O_GYRO_ZOUT_H, buf, 2);
    gyroReading = (int16_t) ((buf[0] << 8) | buf[1]);

    g_ui32measurementTime = micros();
    g_fgyroVelocity = (float) gyroReading / resolution;

    i2cRead(MPU6050_ADDRESS, MPU6050_O_INT_STATUS); // Clear MPU6050 interrupt

    g_fposition_prev = g_fposition;
    g_fposition = encoder.get_pos_minus180_plus180();

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

        if (g_ftotalForce < 0)
            g_ftotalForce = -1.0 * g_ftotalForce;

        /////////////////////////////////////////////////////////////////
        // Transmission with the computer
        /////////////////////////////////////////////////////////////////
        UARTwrite(delimStr, 2); // Begin delimiter
         UARTwrite(timePointer, 4); //Transmit time instance

         UARTwrite(linearPedalPositionPointer, 4);  // Transmit pedal position
         UARTwrite(massPositionPointer, 4);  // Transmit mass position

         UARTwrite((char*)&g_fgyroVelocity, 4);

         UARTwrite((char*)&g_fposition, 4);
         UARTwrite(massVelocityPointer, 4);  // Transmit mass velocity

         UARTwrite(springForcePointer, 4);
         UARTwrite(damperForcePointer, 4);

         UARTwrite(delimStr + 2, 3); // End delimiter and newline
        //////////////////////////////////////////////////////////////////
        // End Transmission
        //////////////////////////////////////////////////////////////////
    }
    else if (numberOfBiasSamples < HOW_MANY_SAMPLES_FOR_BIAS)
    {
        g_fgyroBias += g_fgyroVelocity;
        if (numberOfBiasSamples == HOW_MANY_SAMPLES_FOR_BIAS - 1) // Gyro calibration is done
        {
            g_fgyroBias = g_fgyroBias / HOW_MANY_SAMPLES_FOR_BIAS;
            isGyroCalibrated = true;
            tm4c1294xl_leds.openLed(0);
        }
        numberOfBiasSamples++;
    }
    tm4c1294xl_leds.closeLed(1);*/
}
