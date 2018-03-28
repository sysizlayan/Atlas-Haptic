#include <stdint.h>
#include <stdbool.h>

#include "Time.h"

#include "driverlib/sysctl.h"
#include "driverlib/systick.h"

uint32_t counter;

static void syscTickHandler(void)
{
    counter++;
}

void initTime(void)
{
    SysTickPeriodSet(80); // 1000 for milliseconds & 1000000 for microseconds
    SysTickIntRegister(syscTickHandler);
    SysTickIntEnable();
    SysTickEnable();
}

void delay(uint32_t ms)
{
    delayMicroseconds(ms * 1000UL);
}

void delayMicroseconds(uint32_t us)
{
    uint32_t start = micros();
    while ((int32_t)(micros() - start) < us);
}

uint32_t millis(void)
{
    return counter / 1000UL;
}

uint32_t micros(void)
{
    return counter;
}
