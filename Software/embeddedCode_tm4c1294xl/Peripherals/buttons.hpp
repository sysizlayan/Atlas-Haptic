/*
 * buttons.h
 *
 *  Created on: 24 Mar 2018
 *      Author: Yigit
 */

#ifndef BUTTONS_HPP_
#define BUTTONS_HPP_
#include "main.h"
#include "leds.hpp"

#define BUTTONS_GPIO_PERIPH     SYSCTL_PERIPH_GPIOJ
#define BUTTONS_GPIO_BASE       GPIO_PORTJ_BASE

class _tm4c1294xl_buttons
{
public:
    bool SW1State, SW2State;
    _tm4c1294xl_buttons();
};
// User switch1: PJ0, User Switch2: PJ1
void handlerOfButtons();

extern _tm4c1294xl_buttons tm4c1294xl_buttons;

#endif /* BUTTONS_HPP_ */
