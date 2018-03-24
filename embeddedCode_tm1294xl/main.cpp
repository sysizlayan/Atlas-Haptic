/*
 * main.cpp
 *
 *  Created on: 24 Mar 2018
 *      Author: Yigit
 */
#include "main.h"
#include "time.hpp"
#include "Peripherals/uarts.h"
#include "Peripherals/buttons.hpp"
#include "Peripherals/leds.hpp"
#include "Peripherals/QEI.hpp"

uint32_t systemClock;
int main(void)
{
    // CLOCK SET and FPU enabling
    systemClock = SysCtlClockFreqSet((SYSCTL_XTAL_25MHZ |
                                SYSCTL_OSC_MAIN |
                                SYSCTL_USE_PLL |
                                SYSCTL_CFG_VCO_480),
                                120000000);
    FPUEnable();    //Enable FPU
    FPULazyStackingEnable();    //Enable FPU stacking while interrupt
    initTime();
    uart_stdio_init(115200);

    while (true)
    {
    }
}

