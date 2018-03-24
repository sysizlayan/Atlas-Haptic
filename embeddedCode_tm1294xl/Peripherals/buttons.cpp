/*
 * buttons.cpp
 *
 *  Created on: 24 Mar 2018
 *      Author: Yigit
 */
#include "buttons.hpp"

_tm4c1294xl_buttons::_tm4c1294xl_buttons()
{
    //
    // Enable the GPIO port to which the pushbuttons are connected.
    //
    SysCtlPeripheralEnable(BUTTONS_GPIO_PERIPH);

    //
    // Set each of the button GPIO pins as an input with a pull-up.
    //
    GPIODirModeSet(BUTTONS_GPIO_BASE, GPIO_PIN_0 | GPIO_PIN_1,
    GPIO_DIR_MODE_IN);
    GPIOPadConfigSet(BUTTONS_GPIO_BASE, GPIO_PIN_0 | GPIO_PIN_1,
    GPIO_STRENGTH_2MA,
                     GPIO_PIN_TYPE_STD_WPU);

    GPIOIntTypeSet(BUTTONS_GPIO_BASE, GPIO_PIN_0 | GPIO_PIN_1,
    GPIO_FALLING_EDGE); // for pin 0,1 enable falling edge interrupt
    GPIOIntRegister(BUTTONS_GPIO_BASE, handlerOfButtons); // handlerOfButtons is the interrupt handler

    IntPrioritySet(INT_GPIOJ_TM4C129, LOWEST_PRIORITY);
    GPIOIntEnable(BUTTONS_GPIO_BASE, GPIO_PIN_0 | GPIO_PIN_1); // enable PJ0, PJ1 interrupts

    this->SW1State = GPIOPinRead(BUTTONS_GPIO_BASE, GPIO_PIN_0);
    this->SW2State = GPIOPinRead(BUTTONS_GPIO_BASE, GPIO_PIN_1);
}
void handlerOfButtons()
{
    uint8_t ledIndex = 0;
    uint32_t status = GPIOIntStatus(BUTTONS_GPIO_BASE, 0); // get which button is changed
    GPIOIntClear(BUTTONS_GPIO_BASE, GPIO_PIN_0 | GPIO_PIN_1); //clear corresponding interrupts
    SysCtlDelay(100); // wait for debouncing

    if (status & GPIO_PIN_0) //PJ0 interrupt
    {
        for (ledIndex = 0; ledIndex < 2; ledIndex++)
        {
            if (tm4c1294xl_leds.getLedState(ledIndex))
                tm4c1294xl_leds.closeLed(ledIndex);
            else
                tm4c1294xl_leds.openLed(ledIndex);
        }

    }
    if (status & GPIO_PIN_1) //PJ1 interrupt
    {
        for (ledIndex = 2; ledIndex < 4; ledIndex++)
        {
            if (tm4c1294xl_leds.getLedState(ledIndex))
                tm4c1294xl_leds.closeLed(ledIndex);
            else
                tm4c1294xl_leds.openLed(ledIndex);
        }

    }

}

_tm4c1294xl_buttons tm4c1294xl_buttons;
