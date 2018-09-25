/*
 * simulationVariables.cpp
 *
 *  Created on: 25 Mar 2018
 *      Author: Yigit
 */

#include <simulation/simulationVariables_forSpringMassDamper.h>

//Simulated Variables
volatile massStates_typedef g_ssimulatedMassStates;
volatile massStates_typedef g_ssimulatedMassStates_prev;

volatile forces_typedef g_ssimulatedForces;

const float k_spring = 1000.0f; // N/cm
const float M_mass = 0.1f; // kg
const float b_damper = 20.0f; // N*s/m
// Discrete model from matlab with Ts = 0.001s
const float A_0_0 = 0.999737744415373f;
const float A_0_1 = 0.000720691344621f;
const float A_1_0 = -0.720691344620985f;
const float A_1_1 = 0.985323917522953f;

const float B_0_0 = 0.000262255584627f;
const float B_0_1 = 0.000005245111693f;
const float B_1_0 = 0.720691344620985f;
const float B_1_1 = 0.014413826892420f;
const float R_pedal = 0.17f; //cm

