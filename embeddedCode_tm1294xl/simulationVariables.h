/*
 * simulationVariables.h
 *
 *  Created on: 24 Mar 2018
 *      Author: Yigit
 */

#ifndef SIMULATIONVARIABLES_H_
#define SIMULATIONVARIABLES_H_


//Simulated Variables
extern volatile float g_fMassPosition;
extern volatile float g_fMassVelocity;

extern volatile float g_fMassPosition_prev;
extern volatile float g_fMassVelocity_prev;

extern const float k_spring; // N/cm
extern const float M_mass; // kg
extern const float b_damper; // N*s/m
// Discrete model from matlab with Ts = 0.001s
extern const float A_0_0;
extern const float A_0_1;
extern const float A_1_0;
extern const float A_1_1;

extern const float B_0_0;
extern const float B_0_1;
extern const float B_1_0;
extern const float B_1_1;
extern const float R_pedal; //cm

// Calculated Variables
extern float g_fspringForce, g_fdamperForce, g_ftotalForce;


#endif /* SIMULATIONVARIABLES_H_ */
