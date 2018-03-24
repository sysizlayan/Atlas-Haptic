/*
 * main.cpp
 *
 *  Created on: 24 Mar 2018
 *      Author: Yigit
 */
#include "main.h"
#include "time.h"

int main(void)
{
    // CLOCK SET and FPU enabling
    SysCtlClockSet(SYSCTL_USE_PLL | SYSCTL_OSC_MAIN | SYSCTL_XTAL_16MHZ|SYSCTL_SYSDIV_2_5);//80Mhz Clock
    FPUEnable();//Enable FPU
    FPULazyStackingEnable();//Enable FPU stacking while interrupt

    initTime();
    while(true)
    {

    }
    return 0;
}

