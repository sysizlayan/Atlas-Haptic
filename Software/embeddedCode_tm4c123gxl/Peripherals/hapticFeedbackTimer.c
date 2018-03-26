#include "./Peripherals/hapticFeedbackTimer.h"

void hapticFeedbackTimerHandler(void)
{
    TimerIntClear(TIMER0_BASE, TIMER_TIMA_TIMEOUT);

    GPIOPinWrite(GPIO_PORTF_BASE,GPIO_PIN_2,~GPIO_PIN_2); // make PF2 LOW to close transistor
}

void hapticFeedbackTimerInit(int period)
{

    // TIMER0_A will be used for pulse
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_TIMER0);

    ROM_TimerConfigure(TIMER0_BASE, TIMER_CFG_ONE_SHOT);
    ROM_TimerLoadSet(TIMER0_BASE, TIMER_A, period);
    TimerIntRegister(TIMER0_BASE,TIMER_A,hapticFeedbackTimerHandler);

    ROM_IntEnable(INT_TIMER0A_TM4C123);
    IntPrioritySet(INT_TIMER0A_TM4C123, HIGHEST_PRIORITY);
    ROM_TimerIntEnable(TIMER0_BASE, TIMER_TIMA_TIMEOUT);
}
