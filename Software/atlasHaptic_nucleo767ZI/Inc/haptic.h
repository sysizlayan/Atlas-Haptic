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

#define DEGREE_TO_RADIAN 0.0174532925f
#define MPU6050_ADDRESS MPU6050_WHO_AM_I_MPU6050<<1

uint8_t initMPU6050(void);
void hapticLoop(void);
void giveHapticFeedback(float force);
//void GPIOEHandler6050(void);

#ifdef __cplusplus
}
#endif

#endif
