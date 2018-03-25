/*
 * pedalVariables.h
 *
 *  Created on: 25 Mar 2018
 *      Author: Yigit
 */

#ifndef PEDALVARIABLES_H_
#define PEDALVARIABLES_H_

//Measured Variables
extern volatile float g_fposition;
extern volatile float g_fgyroVelocity;
extern volatile float g_fpulse_velocity;
extern volatile float g_fposition_prev;
extern volatile float g_ui32measurementTime;


//Calculated Variables
extern volatile float g_fposition_filtered_plus;
extern volatile float g_fposition_filtered_minus;
extern volatile float g_fP_minus;
extern volatile float g_fP_plus;

extern volatile float g_fpedalLinearPosition;
extern volatile float g_fpedalLinearVelocity;


// Constants for kalman filter
extern const float g_fdelta_t;
extern const float g_fQ_model;
extern const float g_fR_encoder;


#endif /* PEDALVARIABLES_H_ */
