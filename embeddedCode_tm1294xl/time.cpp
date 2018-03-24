#include "time.h"

static void SycTickHandler(void)
{
    counter++;
}

void initTime(void) {
    SysTickPeriodSet(SysCtlClockGet() / 1000000UL); // 1000 for milliseconds & 1000000 for microseconds
    SysTickIntRegister(SycTickHandler);
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
