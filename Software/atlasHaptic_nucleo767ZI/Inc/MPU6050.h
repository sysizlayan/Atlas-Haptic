#ifndef __mpu6050_h__
#define __mpu6050_h__

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif
#include "simulation/pedalVariables.h"
#include "simulation/simulationVariables_forSpringMassDamper.h"
#include "simulation/massStatesCalculation.h"
#include "simulation/pointersForPrint.h"

#define MPU9250_WHO_AM_I_MPU9250 0x71
#define DEGREE_TO_RADIAN 0.0174532925f
#define MPU6050_ADDRESS MPU6050_WHO_AM_I_MPU6050<<1

extern bool isGyroCalibrated;
extern int32_t g_i32gyro_readingZ_raw;
extern const float resolution;
extern float g_fgyroBias;
extern uint32_t biasSampleCount;

uint8_t initMPU6050(void);
void hapticLoop(void);
void writeToDAC(uint8_t dac1, uint8_t dac2);

//void GPIOEHandler6050(void);

#ifdef __cplusplus
}
#endif

#endif
