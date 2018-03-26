/*
 * mpu6050.hpp
 *
 *  Created on: 25 Mar 2018
 *      Author: Yigit
 */

#ifndef MPU6050_HPP_
#define MPU6050_HPP_
#include <math.h>

#include "main.h"
#include "time.hpp"

#include "sensorlib/hw_mpu6050.h"

#include "Peripherals/uarts.h"
#include "Peripherals/buttons.hpp"
#include "Peripherals/leds.hpp"
#include "Peripherals/QEI.hpp"
#include "Peripherals/I2C.h"

#include "pointersForPrint.h"
#include "pedalVariables.h"
#include "simulationVariables.h"


#define MPU6050_ADDRESS 0x68
#define DEGREE_TO_RADIAN 0.0174532925f
#define HOW_MANY_SAMPLES_FOR_BIAS 1000

extern const float resolution; //  from datasheet, LSB/(º/s)
extern bool isGyroCalibrated;
extern float g_fgyroBias;
extern int32_t gyroReading;
extern uint8_t i2cOutBuffer[]; // Buffer for I2C data

void initMPU6050();
void GPIOEHandler6050(void);

#endif /* MPU6050_HPP_ */
