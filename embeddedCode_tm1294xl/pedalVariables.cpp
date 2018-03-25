/*
 * pedalVariables.cpp
 *
 *  Created on: 25 Mar 2018
 *      Author: Yigit
 */


//Measured Variables
volatile float g_fposition;
volatile float g_fgyroVelocity;
volatile float g_fpulse_velocity;
volatile float g_fposition_prev;
volatile float g_ui32measurementTime;


//Calculated Variables
volatile float g_fposition_filtered_plus;
volatile float g_fposition_filtered_minus;
volatile float g_fP_minus;
volatile float g_fP_plus;

volatile float pedalLinearPosition, pedalLinearVelocity;

// Constants for kalman filter
const float g_fdelta_t = 0.001f;
const float g_fQ_model = 0.000557542f;
const float g_fR_encoder = 0.0027f;

