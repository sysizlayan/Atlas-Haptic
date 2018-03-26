/*
 * QEI.h
 *
 *  Created on: 20 Eki 2017
 *      Author: Yigit
 */

#ifndef QEI_H_
#define QEI_H_

#include "main.h"

typedef struct QEI1
{
    float velocity, position;
    int32_t direction;
    uint32_t velocityCount, positionCount;
    float vel_samp_period, vel_samp_freq;
    float countToDegree;
} encoderReader;

extern encoderReader g_sQEI1;


// Takes the pulse per minute value of encoder as input
// initializes an encoder instance
void initQEI1(encoderReader* encReader, uint32_t ppm, uint32_t frequency);
uint32_t get_pos_count(encoderReader* encReader);
int32_t get_dir(encoderReader* encReader);
float get_pos_0_360(encoderReader* encReader);
float get_pos_minus180_plus180(encoderReader* encReader);

//uint32_t get_vel_count(encoderReader* encReader);
//float get_vel(encoderReader* encReader);
void update_vel();

#endif /* QEI_H_ */
