#ifndef __mpu6050_h__
#define __mpu6050_h__

#include <stdbool.h>

#include "main.h"
#include "sensorlib/hw_mpu6050.h"
#include "I2C.h"
#include "Time.h"
#include "QEI.h"

#define MPU9250_WHO_AM_I_MPU9250 0x71


void initMPU6050();
void GPIOEHandler6050(void);

#ifdef __cplusplus
}
#endif

#endif
