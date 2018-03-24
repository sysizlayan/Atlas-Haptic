/*
 * leds.cpp
 *
 *  Created on: 24 Mar 2018
 *      Author: Yigit
 */

#include "leds.h"

_tm4c1294xl_leds::_tm4c1294xl_leds(void) :
        led0State(false), led1State(false), led2State(false), led3State(false)
{

}
void _tm4c1294xl_leds::setLed(uint8_t ledIndex, bool state)
{

}
void _tm4c1294xl_leds::openLed(uint8_t ledIndex)
{
    if (ledIndex < 5) // check if led is in range
        setLed(ledIndex, true);

}
void _tm4c1294xl_leds::closeLed(uint8_t ledIndex)
{
    if (ledIndex < 5) // check if led is in range
            setLed(ledIndex, false);
}
