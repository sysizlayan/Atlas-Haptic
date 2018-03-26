/*
 * main.h
 *
 *  Created on: 20 Eki 2017
 *      Author: Yigit
 */

#ifndef MAIN_H_
#define MAIN_H_

#include <stdbool.h>          // included to use boolean data type
#include <math.h>             // standard C math library
#include <stdint.h>           // C99 variable types
#include <stdio.h>            // standard C input output library
#include <string.h>

#include "inc/hw_gpio.h"
#include "inc/hw_types.h"
#include "inc/hw_memmap.h"
#include "inc/hw_ints.h"
#include "inc/hw_memmap.h"
#include "inc/hw_types.h"
#include "inc/hw_gpio.h"
#include "inc/hw_uart.h"
#include "inc/hw_sysctl.h"
#include "inc/hw_i2c.h"
#include "driverlib/debug.h"
#include "driverlib/fpu.h"
#include "driverlib/gpio.h"
#include "driverlib/pin_map.h"
#include "driverlib/interrupt.h"
#include "driverlib/sysctl.h"
#include "driverlib/systick.h"
#include "driverlib/uart.h"
#include "driverlib/rom.h"
#include "driverlib/i2c.h"
#include "driverlib/qei.h"
#include "driverlib/timer.h"
#include "utils/uartstdio.h"

#define LOWEST_PRIORITY 0xE0 // Higher the priority number, lower the priority
#define PRIORITY_0 0x00
#define PRIORITY_1 0x40
#define PRIORITY_2 0x60
#define PRIORITY_3 0x80
#define PRIORITY_4 0xA0
#define PRIORITY_5 0xC0
#define PRIORITY_6 0xE0
#define HIGHEST_PRIORITY 0x00
#define MPU6050_ADDRESS 0x68

typedef struct _meas
{
    float fposition;
    float fgyroVelocity;
    uint32_t ui32measurementInstance;
} measurement;

#endif /* MAIN_H_ */
