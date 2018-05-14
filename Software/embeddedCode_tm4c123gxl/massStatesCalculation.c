/*
 * simulation.c
 *
 *  Created on: 14 May 2018
 *      Author: Yigit
 */

#include "massStatesCalculation.h"
#include "math.h"
#define TWO_PI 6.28318530718f
#define MOVEMENT_FREQ 1

void calculateMassStatesAndForces()
{
    float timeVar, omega;
#if defined(springMassDamper)
    g_ssimulatedMassStates.massPosition = 0
    + A_0_0 * g_ssimulatedMassStates_prev.massPosition
    + A_0_1 * g_ssimulatedMassStates_prev.massVelocity;

    g_ssimulatedMassStates.massPosition = g_ssimulatedMassStates.massPosition
    + B_0_0 * g_ssimulatedMassStates_prev.massPosition
    + B_0_1 * g_ssimulatedMassStates_prev.massVelocity;

    g_ssimulatedMassStates.massVelocity = 0
    + A_1_0 * g_ssimulatedMassStates_prev.massPosition
    + A_1_1 * g_ssimulatedMassStates_prev.massVelocity;

    g_ssimulatedMassStates.massVelocity = g_ssimulatedMassStates.massVelocity
    + B_1_0 * g_ssimulatedMassStates_prev.massPosition
    + B_1_1 * g_ssimulatedMassStates_prev.massVelocity;

#elif defined(massTracking)
    timeVar = TWO_PI * MOVEMENT_FREQ;
    omega = timeVar * millis() / 1000;

    g_ssimulatedMassStates.massPosition = 250 * sinf(omega);

    g_ssimulatedMassStates.massVelocity = 250 * timeVar * cosf(omega);
#else
#endif

    g_ssimulatedMassStates_prev.massPosition = g_ssimulatedMassStates.massPosition;
    g_ssimulatedMassStates_prev.massVelocity = g_ssimulatedMassStates.massVelocity;

    g_ssimulatedForces.springForce = (g_fpedalLinearPosition - g_ssimulatedMassStates.massPosition) * k_spring;
    g_ssimulatedForces.damperForce = (g_fpedalLinearVelocity - g_ssimulatedMassStates.massVelocity) * b_damper;

    g_ssimulatedForces.totalForce = (g_ssimulatedForces.springForce + g_ssimulatedForces.damperForce) * FORCE_GAIN + FORCE_BIAS;
}
