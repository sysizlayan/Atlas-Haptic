/*
 * time.h
 *
 *  Created on: 24 Mar 2018
 *      Author: Yigit
 */

#ifndef TIME_H_
#define TIME_H_
#include "main.h"

static volatile uint32_t counter;

void initTime(void);
void delay(uint32_t ms);
void delayMicroseconds(uint32_t us);
uint32_t millis(void);
uint32_t micros(void);


#endif /* TIME_H_ */
