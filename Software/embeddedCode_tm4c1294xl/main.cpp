/*
 * main.cpp
 *
 *  Created on: 24 Mar 2018
 *      Author: Yigit
 */
#include "main.h"
#include "time.hpp"
#include "mpu6050.hpp"

#include "Peripherals/uarts.h"
#include "Peripherals/buttons.hpp"
#include "Peripherals/leds.hpp"
#include "Peripherals/QEI.hpp"
#include "Peripherals/I2C.h"

#include "pointersForPrint.h"
#include "pedalVariables.h"
#include "simulationVariables.h"

uint32_t systemClock;
static uint32_t numberOfBiasSamples;

int main(void)
{
    // CLOCK SET and FPU enabling
    systemClock = SysCtlClockFreqSet((SYSCTL_XTAL_25MHZ |
    SYSCTL_OSC_MAIN |
    SYSCTL_USE_PLL |
    SYSCTL_CFG_VCO_480),
                                     120000000);
    FPUEnable();                //Enable FPU
    FPULazyStackingEnable();    //Enable FPU stacking while interrupt

    //Using Systick
    //micros, millis functions
    initTime();

    //Stellaris ICDI virtual COM port
    uart_stdio_init(230400);

    //To make printing faster, use global pointers for variables
    initializePrintPointers();

    //PN4 SDA
    //PN5 SCL
    //I2C2
    initI2C();

    //PP4 Interrupt
    initMPU6050();

    while (true)
    {
        if (GPIOPinRead(GPIO_PORTP_BASE, GPIO_PIN_4))
        {
            float error;
            float K;

            uint8_t buf[2];
            tm4c1294xl_leds.openLed(1);
            ////////////////////////////////////////////////////////////
            // Measurement Readings
            ////////////////////////////////////////////////////////////
            i2cReadData(MPU6050_ADDRESS, MPU6050_O_GYRO_ZOUT_H, buf, 2);
            gyroReading = (int16_t)((buf[0] << 8) | buf[1]);

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
                    K     = g_fP_minus / (g_fP_minus + g_fR_encoder);

                    g_fposition_filtered_plus = g_fposition_filtered_minus + K * error;
                    g_fP_plus = (1.0f - K) * g_fP_minus;
                }
                /////////////////////////////////////////////////////////////////
                // End Kalman Filter
                /////////////////////////////////////////////////////////////////

                g_fpedalLinearPosition = R_pedal * sinf(g_fposition_filtered_plus * DEGREE_TO_RADIAN);
                g_fpedalLinearVelocity = R_pedal * cosf(g_fposition_filtered_plus * DEGREE_TO_RADIAN)
                                                 * g_fgyroVelocity * DEGREE_TO_RADIAN;

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

                g_fspringForce = (g_fpedalLinearPosition - g_fMassPosition) * k_spring; //* k_spring;

                g_fdamperForce = (g_fpedalLinearVelocity - g_fMassVelocity) * b_damper; //* b_damper;

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
            tm4c1294xl_leds.closeLed(1);
        }
    }
}

