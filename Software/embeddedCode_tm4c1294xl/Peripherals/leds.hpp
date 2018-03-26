/*
 * leds.h
 *
 *  Created on: 24 Mar 2018
 *      Author: Yigit
 */

#ifndef LEDS_HPP_
#define LEDS_HPP_

#include "main.h"

class _tm4c1294xl_leds
{
private:
    bool led0State;
    bool led1State;
    bool led2State;
    bool led3State;
    void setLed(uint8_t ledIndex, bool state);
public:
    _tm4c1294xl_leds(void);
    void openLed(uint8_t ledIndex);
    void closeLed(uint8_t ledIndex);
    bool getLedState(uint8_t ledIndex);
};

extern _tm4c1294xl_leds tm4c1294xl_leds;
#endif /* LEDS_HPP_ */
