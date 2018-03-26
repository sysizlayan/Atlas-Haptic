/*
 * pointersForPrint.cpp
 *
 *  Created on: 25 Mar 2018
 *      Author: Yigit
 */
#include "pointersForPrint.h"

char delimStr[] = { '$', '$', '*', '*', '\n' }; //Delimiters
char *timePointer,
            *pedalPositionPointer,
            *pedalVelocityPointer,
            *filteredPedalPositionPointer,
            *linearPedalPositionPointer,
            *linearPedalVelocityPointer,
            *massPositionPointer,
            *massVelocityPointer,
            *totalForcePointer,
            *springForcePointer,
            *damperForcePointer;

void initializePrintPointers(void)
{
    //For uart communication!
    timePointer                     = (char*) &g_ui32measurementTime;
    pedalPositionPointer            = (char*) &g_fposition;
    pedalVelocityPointer            = (char*) &g_fgyroVelocity;
    filteredPedalPositionPointer    = (char*) &g_fposition_filtered_plus;
    linearPedalPositionPointer      = (char*) &g_fpedalLinearPosition;
    linearPedalVelocityPointer      = (char*) &g_fpedalLinearVelocity;

    massPositionPointer             = (char*) &g_fMassPosition;
    massVelocityPointer             = (char*) &g_fMassVelocity;

    totalForcePointer               = (char*) &g_ftotalForce;
    springForcePointer              = (char*) &g_fspringForce;
    damperForcePointer              = (char*) &g_fdamperForce;
}

