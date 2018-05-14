#ifndef __mpu6050_h__
#define __mpu6050_h__

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif
#include "main.h"
#include "sensorlib/hw_mpu6050.h"
#include "I2C.h"
#include "Time.h"
#include "QEI.h"

#include "pedalVariables.h"
#include "simulationVariables_forSpringMassDamper.h"
#include "massStatesCalculation.h"
#include "pointersForPrint.h"

#define MPU9250_WHO_AM_I_MPU9250 0x71
#define DEGREE_TO_RADIAN 0.0174532925f

extern bool isGyroCalibrated;
extern int32_t g_i32gyro_readingZ_raw;
extern const float resolution;
extern float g_fgyroBias;
extern uint32_t biasSampleCount;

void initMPU6050();
void GPIOEHandler6050(void);

#ifdef __cplusplus
}
#endif

#endif
