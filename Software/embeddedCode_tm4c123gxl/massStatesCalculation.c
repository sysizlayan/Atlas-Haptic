/*
 * simulation.c
 *
 *  Created on: 14 May 2018
 *      Author: Yigit
 */

#include "massStatesCalculation.h"
#include "math.h"
#define TWO_PI 6.28318530718f
//#define MOVEMENT_FREQ 0.55f
#define DEGREE_TO_RADIAN 0.0174532925f

//float testFreqs[] = {0.3f, 0.5f, 0.8f, 1.0f, 1.1f};
float testFreqs[] = {1.884955592154f,
                     3.141592653590f,
                     5.026548245744f,
                     6.283185307180f,
                     6.911503837898f};

float testMags[] = {9.0f,
                     9.0f,
                     9.0f,
                     9.0f,
                     9.0f};

float testTimeConsts[] = {0.0328986813f,
                          0.0548311355f,
                          0.0877298168f,
                          0.1096622710f,
                          0.1206284981f};
void calculateMassStatesAndForces()
{
    //float timeVar, omega;
    float timeSecs;
#if defined(springMassDamper)
    g_ssimulatedMassStates.massPosition = 0
    + A_0_0 * g_ssimulatedMassStates_prev.massPosition
    + A_0_1 * g_ssimulatedMassStates_prev.massVelocity;

    g_ssimulatedMassStates.massPosition = g_ssimulatedMassStates.massPosition
    + B_0_0 * g_fpedalLinearPosition
    + B_0_1 * g_fpedalLinearVelocity;

    g_ssimulatedMassStates.massVelocity = 0
    + A_1_0 * g_ssimulatedMassStates_prev.massPosition
    + A_1_1 * g_ssimulatedMassStates_prev.massVelocity;

    g_ssimulatedMassStates.massVelocity = g_ssimulatedMassStates.massVelocity
    + B_1_0 * g_fpedalLinearPosition
    + B_1_1 * g_fpedalLinearVelocity;

#elif defined(tracking_linear)
    timeVar = TWO_PI * MOVEMENT_FREQ;
    omega = timeVar * millis() / 1000;

    g_ssimulatedMassStates.massPosition = 0.05f * sinf(omega);

    g_ssimulatedMassStates.massVelocity = 0.05f * timeVar * DEGREE_TO_RADIAN * cosf(omega);
#elif defined(tracking_circular)
    //timeVar = TWO_PI * MOVEMENT_FREQ;
    //omega = timeVar * g_ui32measurementTime / 1000; //millis() / 1000;
    timeSecs = (float)g_ui32measurementTime / 1000.0f;
    //g_ssimulatedMassStates.massPosition = 45 * sinf(omega);
    g_ssimulatedMassStates.massPosition = testMags[0] * sinf(testFreqs[0]*timeSecs)
                                        + testMags[1] * sinf(testFreqs[1]*timeSecs)
                                        + testMags[2] * sinf(testFreqs[2]*timeSecs)
                                        + testMags[3] * sinf(testFreqs[3]*timeSecs)
                                        + testMags[4] * sinf(testFreqs[4]*timeSecs);
    //g_ssimulatedMassStates.massVelocity = 45 * timeVar * DEGREE_TO_RADIAN * cosf(omega);
    g_ssimulatedMassStates.massVelocity = testMags[0] * testTimeConsts[0] * cosf(testFreqs[0]*timeSecs)
                                        + testMags[1] * testTimeConsts[1] * cosf(testFreqs[1]*timeSecs)
                                        + testMags[2] * testTimeConsts[2] * cosf(testFreqs[2]*timeSecs)
                                        + testMags[3] * testTimeConsts[3] * cosf(testFreqs[3]*timeSecs)
                                        + testMags[4] * testTimeConsts[4] * cosf(testFreqs[4]*timeSecs);
#else
#endif

    g_ssimulatedMassStates_prev.massPosition =
            g_ssimulatedMassStates.massPosition;
    g_ssimulatedMassStates_prev.massVelocity =
            g_ssimulatedMassStates.massVelocity;

#if !defined(tracking_circular)
    g_ssimulatedForces.springForce = (g_fpedalLinearPosition
            - g_ssimulatedMassStates.massPosition) * k_spring;
    g_ssimulatedForces.damperForce = (g_fpedalLinearVelocity
            - g_ssimulatedMassStates.massVelocity) * b_damper;
#else
    g_ssimulatedForces.springForce = (g_fposition_filtered_plus
            - g_ssimulatedMassStates.massPosition) * k_spring;
    g_ssimulatedForces.damperForce = (g_fgyroVelocity
            - g_ssimulatedMassStates.massVelocity) * b_damper;
#endif
    g_ssimulatedForces.totalForce = (g_ssimulatedForces.springForce
            + g_ssimulatedForces.damperForce) * FORCE_GAIN + FORCE_BIAS;
}
