/*
 * pointersForPrint.h
 *
 *  Created on: 25 Mar 2018
 *      Author: Yigit
 */

#ifndef POINTERSFORPRINT_H_
#define POINTERSFORPRINT_H_
#include "simulationVariables.h"
#include "pedalVariables.h"

extern char delimStr[]; //Delimiters
extern char *timePointer, *positionPointer, *velocityPointer,*filteredPositionPointer,*massPositionPointer,*massVelocityPointer;

void initializePrintPointers(void);

#endif /* POINTERSFORPRINT_H_ */
