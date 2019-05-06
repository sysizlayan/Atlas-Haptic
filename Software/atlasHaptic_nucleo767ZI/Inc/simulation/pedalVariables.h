/*
 * pedalVariables.h
 *
 *  Created on: 25 Mar 2018
 *      Author: Yigit
 */

#ifndef PEDALVARIABLES_H_
#define PEDALVARIABLES_H_

#include <stdint.h>

typedef struct _measuredVars
{
	volatile float position;
	volatile float gyroVelocity;
	volatile float positionPrevious;
} measuredVariables_t;

typedef struct _estimatedVars
{
	volatile float positionFilterPlus;
	volatile float positionFilterMinus;
	volatile float P_Minus;
	volatile float P_Plus;
} estimatedVariables_t;

typedef struct _kalmanConstants
{
	float delta_t;
	float Q_model;
	float R_encoder;
} kalmanConstants_t;

typedef struct _pedalVars
{
	volatile measuredVariables_t measuredVariables;
	volatile estimatedVariables_t estimatedVariables;
	volatile kalmanConstants_t kalmanConstants;
} pedalVariables_t;

void initEstimator(void);

extern volatile pedalVariables_t pedalVariables;
#endif /* PEDALVARIABLES_H_ */
