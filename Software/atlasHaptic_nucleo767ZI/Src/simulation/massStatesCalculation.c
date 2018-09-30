/*
 * simulation.c
 *
 *  Created on: 14 May 2018
 *      Author: Yigit
 */

#include <simulation/massStatesCalculation.h>
#include "math.h"
#include "simulation/pedalVariables.h"

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
void calculateMassStatesAndForces(uint32_t measurementTime)
{

    //float timeVar, omega;
    float timeSecs;

    //timeVar = TWO_PI * MOVEMENT_FREQ;
    //omega = timeVar * g_ui32measurementTime / 1000; //millis() / 1000;
    timeSecs = (float)measurementTime / 1000.0f;
    //g_ssimulatedMassStates.massPosition = 45 * sinf(omega);
    g_ssimulatedMassStates.massPosition = testMags[0] * sinf(testFreqs[0]*timeSecs)
                                        + testMags[1] * sinf(testFreqs[1]*timeSecs)
                                        + testMags[2] * sinf(testFreqs[2]*timeSecs)
                                        + testMags[3] * sinf(testFreqs[3]*timeSecs)
                                        + testMags[4] * sinf(testFreqs[4]*timeSecs);
    //g_ssimulatedMassStates.massVelocity = 45 * timeVar * DEGREE_TO_RADIAN * cosf(omega);
    g_ssimulatedMassStates.massVelocity = testMags[0] * testFreqs[0] * cosf(testFreqs[0]*timeSecs)
                                        + testMags[1] * testFreqs[1] * cosf(testFreqs[1]*timeSecs)
                                        + testMags[2] * testFreqs[2] * cosf(testFreqs[2]*timeSecs)
                                        + testMags[3] * testFreqs[3] * cosf(testFreqs[3]*timeSecs)
                                        + testMags[4] * testFreqs[4] * cosf(testFreqs[4]*timeSecs);


    g_ssimulatedMassStates_prev.massPosition =
            g_ssimulatedMassStates.massPosition;
    g_ssimulatedMassStates_prev.massVelocity =
            g_ssimulatedMassStates.massVelocity;


    g_ssimulatedForces.springForce = (pedalVariables.estimatedVariables.positionFilterPlus
            - g_ssimulatedMassStates.massPosition) * k_spring;
    g_ssimulatedForces.damperForce = (pedalVariables.measuredVariables.gyroVelocity
            - g_ssimulatedMassStates.massVelocity) * b_damper;

    g_ssimulatedForces.totalForce = (g_ssimulatedForces.springForce
            + g_ssimulatedForces.damperForce) * FORCE_GAIN + FORCE_BIAS;
}