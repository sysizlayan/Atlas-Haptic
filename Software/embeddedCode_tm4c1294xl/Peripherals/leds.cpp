/*
 * leds.cpp
 *
 *  Created on: 24 Mar 2018
 *      Author: Yigit
 */
#include "leds.hpp"

_tm4c1294xl_leds::_tm4c1294xl_leds(void) :
        led0State(false), led1State(false), led2State(false), led3State(false)
{
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPION);
    while (!SysCtlPeripheralReady(SYSCTL_PERIPH_GPION))
    {
    }

    GPIOPinTypeGPIOOutput(GPIO_PORTN_BASE, GPIO_PIN_0 | GPIO_PIN_1);

    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOF);
    while (!SysCtlPeripheralReady(SYSCTL_PERIPH_GPIOF))
    {
    }

    GPIOPinTypeGPIOOutput(GPIO_PORTF_BASE, GPIO_PIN_0 | GPIO_PIN_4);

    GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_0 | GPIO_PIN_1, 0);
    GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_0 | GPIO_PIN_4, 0);
}
void _tm4c1294xl_leds::setLed(uint8_t ledIndex, bool state)
{
    switch (ledIndex)
    {
    case 0:
        GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_1,
                     state ? GPIO_PIN_1 : ~GPIO_PIN_1);
        this->led0State = state;
        break;
    case 1:
        GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_0,
                     state ? GPIO_PIN_0 : ~GPIO_PIN_0);
        this->led1State = state;
        break;
    case 2:
        GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_4,
                     state ? GPIO_PIN_4 : ~GPIO_PIN_4);
        this->led2State = state;
        break;
    case 3:
        GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_0,
                     state ? GPIO_PIN_0 : ~GPIO_PIN_0);
        this->led3State = state;
        break;
    }
}
void _tm4c1294xl_leds::openLed(uint8_t ledIndex)
{
    if (ledIndex < 4) // check if led is in range
        setLed(ledIndex, true);

}
void _tm4c1294xl_leds::closeLed(uint8_t ledIndex)
{
    if (ledIndex < 4) // check if led is in range
        setLed(ledIndex, false);
}

bool _tm4c1294xl_leds::getLedState(uint8_t ledIndex)
{
    switch (ledIndex)
    {
    case 0:
        return this->led0State;
    case 1:
        return this->led1State;
    case 2:
        return this->led2State;
    case 3:
        return this->led3State;
    }
    return 0;
}


_tm4c1294xl_leds tm4c1294xl_leds;
