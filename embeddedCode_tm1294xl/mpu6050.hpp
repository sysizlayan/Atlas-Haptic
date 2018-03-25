/*
 * mpu6050.hpp
 *
 *  Created on: 25 Mar 2018
 *      Author: Yigit
 */

#ifndef MPU6050_HPP_
#define MPU6050_HPP_

#include "main.h"
#define MPU6050_ADDRESS 0x68

void initMPU6050();
void GPIOEHandler6050(void);

#endif /* MPU6050_HPP_ */
