/*
 * buttons.h
 *
 *  Created on: 24 Mar 2018
 *      Author: Yigit
 */

#ifndef BUTTONS_H_
#define BUTTONS_H_
#include "main.h"
#define BUTTONS_GPIO_PERIPH     SYSCTL_PERIPH_GPIOJ
#define BUTTONS_GPIO_BASE       GPIO_PORTJ_BASE

#ifdef POLLING_BUTTONS
class _tm4c1294xl_buttons
{
private:
    bool button0State;
    bool button1State;
public:
    bool getButtonState(uint8_t buttonIndex);
};
#else

// User switch1: PJ0, User Switch2: PJ1
bool g_bSW1State, g_bSW2State;
void initTM4C1294XLButtons();
void handlerOfButtons();

#endif

#endif /* BUTTONS_H_ */
