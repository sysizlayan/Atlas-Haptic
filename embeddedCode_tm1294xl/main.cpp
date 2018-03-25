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


uint32_t systemClock;
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
    uart_stdio_init(921600);

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
    }
}

