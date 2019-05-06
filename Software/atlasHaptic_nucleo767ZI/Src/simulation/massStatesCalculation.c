/*
 * simulation.c
 *
 *  Created on: 14 May 2018
 *      Author: Yigit
 */

#include <simulation/massStatesCalculation.h>
#include <arm_math.h>
#include "simulation/pedalVariables.h"
#include "experimentConfig.h"

#define DEGREE_TO_RADIAN 0.0174532925f

void calculateMassStatesAndForces(uint32_t measurementTime)
{
    //float timeVar, omega;
    float timeSecs;
    float timeIns = 0.0F;
    float sineValue, cosValue;
    timeSecs = (float)measurementTime / 1000.0f;
    //timeVar = TWO_PI * MOVEMENT_FREQ;
    //omega = timeVar * g_ui32measurementTime / 1000; //millis() / 1000;

    //g_ssimulatedMassStates.massPosition = 45 * sinf(omega);

    /*g_ssimulatedMassStates.massPosition = testMags[0] * sinf(testFreqs[0]*timeSecs)
                                            + testMags[1] * sinf(testFreqs[1]*timeSecs)
                                            + testMags[2] * sinf(testFreqs[2]*timeSecs)
                                            + testMags[3] * sinf(testFreqs[3]*timeSecs)
                                            + testMags[4] * sinf(testFreqs[4]*timeSecs);
        //g_ssimulatedMassStates.massVelocity = 45 * timeVar * DEGREE_TO_RADIAN * cosf(omega);
        g_ssimulatedMassStates.massVelocity = testMags[0] * testFreqs[0] * cosf(testFreqs[0]*timeSecs)
                                            + testMags[1] * testFreqs[1] * cosf(testFreqs[1]*timeSecs)
                                            + testMags[2] * testFreqs[2] * cosf(testFreqs[2]*timeSecs)
                                            + testMags[3] * testFreqs[3] * cosf(testFreqs[3]*timeSecs)
                                            + testMags[4] * testFreqs[4] * cosf(testFreqs[4]*timeSecs);*/

    g_ssimulatedMassStates.massPosition = 0;
    g_ssimulatedMassStates.massVelocity = 0;
    for(int i=0;i<experimentSineParams.numberOfFrequencies;i++)
    {
    	timeIns = 360 * experimentSineParams.frequencies[i] * timeSecs + experimentSineParams.phases[i]; // 2pi*f*t
    	arm_sin_cos_f32(timeIns, &sineValue, &cosValue);

		g_ssimulatedMassStates.massPosition += experimentSineParams.magnitudes[i] * sineValue;
		g_ssimulatedMassStates.massVelocity += experimentSineParams.magnitudes[i] * experimentSineParams.frequencies[i] * M_TWOPI * cosValue;
    }

    g_ssimulatedForces.springForce = (pedalVariables.estimatedVariables.positionFilterPlus
            - g_ssimulatedMassStates.massPosition) * k_spring;
    g_ssimulatedForces.damperForce = (pedalVariables.measuredVariables.gyroVelocity
            - g_ssimulatedMassStates.massVelocity) * b_damper;

    g_ssimulatedForces.totalForce = (g_ssimulatedForces.springForce
            + g_ssimulatedForces.damperForce) * forceGain + forceBias;

    g_ssimulatedMassStates_prev.massPosition =
               g_ssimulatedMassStates.massPosition;
       g_ssimulatedMassStates_prev.massVelocity =
               g_ssimulatedMassStates.massVelocity;
}
