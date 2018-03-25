/*
 * pointersForPrint.cpp
 *
 *  Created on: 25 Mar 2018
 *      Author: Yigit
 */
#include "pointersForPrint.h"

char delimStr[] = { '$', '$', '*', '*', '\n' }; //Delimiters
char *timePointer, *positionPointer, *velocityPointer, *filteredPositionPointer,
        *massPositionPointer, *massVelocityPointer;

void initializePrintPointers(void)
{
    //For uart communication!
    timePointer = (char*) &g_ui32measurementTime;
    positionPointer = (char*) &g_fposition;
    velocityPointer = (char*) &g_fgyroVelocity;
    filteredPositionPointer = (char*) &g_fposition_filtered_plus;
    massPositionPointer = (char*) &g_fMassPosition;
    massVelocityPointer = (char*) &g_fMassVelocity;
}

