/*
 * mpu6050.cpp
 *
 *  Created on: 25 Mar 2018
 *      Author: Yigit
 */

#include "mpu6050.hpp"
const float resolution = 32.8; //  from datasheet, LSB/(º/s)


static uint32_t numberOfBiasSamples = 0;
bool isGyroCalibrated = false;
float g_fgyroBias = 0.0f;

void initMPU6050(void)
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
    {
    }
    delay(100);
    i2cWrite(MPU6050_ADDRESS, MPU6050_O_PWR_MGMT_1, 0x00); //MPU6050_PWR_MGMT_1_CLKSEL_ZG);

    i2cBuffer[0] = 0x07; //SMPRT_DIV = 7 , ODR =1Khz
    i2cBuffer[1] = MPU6050_CONFIG_DLPF_CFG_260_256; // //MPU6050_CONFIG_DLPF_CFG_184_188; // 184 Hz filter
    i2cBuffer[2] = MPU6050_GYRO_CONFIG_FS_SEL_1000; // +-1000deg/s
    i2cWriteData(MPU6050_ADDRESS, MPU6050_O_SMPLRT_DIV, i2cBuffer, 3); // Write to all three registers at once

    /* Enable Raw Data Ready Interrupt on INT pin and enable bypass/passthrough mode */
    i2cBuffer[0] = MPU6050_INT_PIN_CFG_INT_LEVEL |
    MPU6050_INT_PIN_CFG_INT_RD_CLEAR |
    MPU6050_INT_PIN_CFG_LATCH_INT_EN;

    i2cBuffer[1] = MPU6050_INT_ENABLE_DATA_RDY_EN; // data ready interrupt

    i2cWriteData(MPU6050_ADDRESS, MPU6050_O_INT_PIN_CFG, i2cBuffer, 2); // Write to both registers at once

    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOP); //enable portE

    GPIOPinTypeGPIOInput(GPIO_PORTP_BASE, GPIO_PIN_4);
    GPIOPadConfigSet(GPIO_PORTP_BASE, GPIO_PIN_4,
    GPIO_STRENGTH_8MA,
                     GPIO_PIN_TYPE_STD);

    GPIOIntTypeSet(GPIO_PORTP_BASE, GPIO_PIN_4, GPIO_FALLING_EDGE); // Pin PP4 has falling edge interrupt

    GPIOIntRegister(GPIO_PORTP_BASE, GPIOEHandler6050); //portf_int_handler is the interrupt handler
    IntPrioritySet(INT_GPIOP0_TM4C129, PRIORITY_5);  // Highest-1 priority

    delay(100); // Wait for sensor to stabilize
    GPIOIntEnable(GPIO_PORTP_BASE, GPIO_PIN_4); //enable PP4 interrupts

    tm4c1294xl_leds.closeLed(0);
    tm4c1294xl_leds.closeLed(1);
    tm4c1294xl_leds.closeLed(2);
    tm4c1294xl_leds.closeLed(3);
}

void GPIOEHandler6050(void)
{
    float error;
    float K;
    int_fast16_t gyroReading;

    uint8_t buf[2];
    GPIOIntClear(GPIO_PORTP_BASE, GPIO_PIN_4); //clear corresponding interrupts

    ////////////////////////////////////////////////////////////
    // Measurement Readings
    ////////////////////////////////////////////////////////////
    i2cReadData(MPU6050_ADDRESS, MPU6050_O_GYRO_ZOUT_H, buf, 2);
    gyroReading = (int_fast16_t) ((buf[0] << 8) | buf[1]);

    g_ui32measurementTime = micros();
    g_fgyroVelocity = (float)gyroReading / resolution;

    i2cRead(MPU6050_ADDRESS, 0x3A); // Clear MPU6050 interrupt

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
        g_fposition_filtered_minus = g_fposition_filtered_plus + g_fdelta_t * g_fgyroVelocity;

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

        g_fpedalLinearPosition = R_pedal * sinf(g_fposition_filtered_plus * DEGREE_TO_RADIAN);
        g_fpedalLinearVelocity = R_pedal * cosf(g_fposition_filtered_plus * DEGREE_TO_RADIAN) * g_fgyroVelocity * DEGREE_TO_RADIAN;

        /////////////////////////////////////////////////////////////////
        // SPRING MASS SIMULATION
        /////////////////////////////////////////////////////////////////
        g_fMassPosition = A_0_0 * g_fMassPosition_prev
                        + A_0_1 * g_fMassVelocity_prev;

        g_fMassPosition = g_fMassPosition
                        + B_0_0 * g_fpedalLinearPosition
                        + B_0_1 * g_fpedalLinearVelocity;

        g_fMassVelocity = A_1_0 * g_fMassPosition_prev
                        + A_1_1 * g_fMassVelocity_prev;

        g_fMassVelocity = g_fMassVelocity
                        + B_1_0 * g_fpedalLinearPosition
                        + B_1_1 * g_fpedalLinearVelocity;

        g_fMassPosition_prev = g_fMassPosition;
        g_fMassVelocity_prev = g_fMassVelocity;

        g_fspringForce = (g_fpedalLinearPosition - g_fMassPosition) * k_spring;     //* k_spring;

        g_fdamperForce = (g_fpedalLinearVelocity - g_fMassVelocity) * b_damper;     //* b_damper;

        g_ftotalForce = g_fspringForce + g_fdamperForce;

        if (g_ftotalForce < 0)
            g_ftotalForce = -1.0 * g_ftotalForce;

        /*uint32_t ui16Total = ((uint32_t) totalForce) & 0x0000FFFF;
        writeVoltage(ui16Total);*/

        /////////////////////////////////////////////////////////////////
        // Transmission with the computer
        /////////////////////////////////////////////////////////////////
        UARTwrite(delimStr, 2); // Begin delimiter
        UARTwrite(timePointer, 4); //Transmit time instance


        UARTwrite(linearPedalPositionPointer, 4);  // Transmit pedal position
        UARTwrite(massPositionPointer, 4);  // Transmit mass position

        UARTwrite(totalForcePointer, 4);  // Transmit total force

        UARTwrite(linearPedalVelocityPointer, 4);  // Transmit pedal velocity
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
}
