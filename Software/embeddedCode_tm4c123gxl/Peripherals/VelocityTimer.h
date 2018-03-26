/*
 * VelocityTimer.h
 *
 *  Created on: 24 Eki 2017
 *      Author: Yigit
 */

///////////////////////////////////////////////////////////////////
// This timer will be used to determine high and low times of
// an encoder signal. With this times, the velocity variable of the QEI
// module will be updated.
///////////////////////////////////////////////////////////////////
// For now, we are going to use both velocity counter of both QEI peripheral
// and this timer. When the velocity timer of QEI module runs out, the velocity
// will be updated with QEI speed register. Between two consecutive interrupt,
// the velocity will be updated using this timer. This will allow us to determine
// the velocity more accurately.
///////////////////////////////////////////////////////////////////

#ifndef PERIPHERALS_VELOCITYTIMER_H_
#define PERIPHERALS_VELOCITYTIMER_H_

#include "main.h"

void initialize_pulse_timer(float countToDegree);  // initializes the edge time of a wide-timer
void read_period_raw();  // interrupt handler of the timer
float convert_period_to_velocity();  // converts raw period count to the dps unit


#endif /* PERIPHERALS_VELOCITYTIMER_H_ */
