/*
 * pointersForPrint.h
 *
 *  Created on: 25 Mar 2018
 *      Author: Yigit
 */

#ifndef POINTERSFORPRINT_H_
#define POINTERSFORPRINT_H_
#include "simulationVariables_forSpringMassDamper.h"
#include "pedalVariables.h"

extern char delimStr[]; //Delimiters
extern char *timePointer,
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

void initializePrintPointers(void);

#endif /* POINTERSFORPRINT_H_ */
