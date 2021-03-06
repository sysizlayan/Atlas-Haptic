/*
 * pointersForPrint.cpp
 *
 *  Created on: 25 Mar 2018
 *      Author: Yigit
 */
#include "pointersForPrint.h"

char delimStr[] = { '$', '$', '*', '*', '\n' }; //Delimiters
char *timePointer, *pedalPositionPointer, *pedalVelocityPointer,
        *filteredPedalPositionPointer, *linearPedalPositionPointer,
        *linearPedalVelocityPointer, *targetPositionPointer, *targetVelocityPointer,
        *totalForcePointer, *springForcePointer, *damperForcePointer;

void initializePrintPointers(void)
{
    //For uart communication!
    timePointer = (char*) &g_ui32measurementTime;
    pedalPositionPointer = (char*) &g_fposition;
    pedalVelocityPointer = (char*) &g_fgyroVelocity;
    filteredPedalPositionPointer = (char*) &g_fposition_filtered_plus;
    linearPedalPositionPointer = (char*) &g_fpedalLinearPosition;
    linearPedalVelocityPointer = (char*) &g_fpedalLinearVelocity;

    targetPositionPointer = (char*) &(g_ssimulatedMassStates.massPosition);
    targetVelocityPointer = (char*) &(g_ssimulatedMassStates.massVelocity);

    totalForcePointer = (char*) &(g_ssimulatedForces.totalForce);
    springForcePointer = (char*) &(g_ssimulatedForces.springForce);
    damperForcePointer = (char*) &(g_ssimulatedForces.damperForce);
}

