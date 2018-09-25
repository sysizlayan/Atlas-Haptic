/*
 * simulationVariables.h
 *
 *  Created on: 24 Mar 2018
 *      Author: Yigit
 */

#ifndef SIMULATIONVARIABLES_H_
#define SIMULATIONVARIABLES_H_

#define FORCE_GAIN -0.018
#define FORCE_BIAS 1900

//Simulated Variables
typedef struct _massStates
{
    volatile float massPosition;
    volatile float massVelocity;
} massStates_typedef;

typedef struct _forces
{
    volatile float springForce, damperForce, totalForce;
} forces_typedef;

extern volatile massStates_typedef g_ssimulatedMassStates;
extern volatile massStates_typedef g_ssimulatedMassStates_prev;

extern volatile forces_typedef g_ssimulatedForces;

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


#endif /* SIMULATIONVARIABLES_H_ */
