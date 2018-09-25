/*
 * pedalVariables.cpp
 *
 *  Created on: 25 Mar 2018
 *      Author: Yigit
 */
#include <simulation/pedalVariables.h>

volatile pedalVariables_t pedalVariables;
void initEstimator(void)
{
	pedalVariables.kalmanConstants.Q_model 					= 0.000557542f;
	pedalVariables.kalmanConstants.R_encoder 				= 0.0027f;
	pedalVariables.kalmanConstants.delta_t 					= 0.001f;

	pedalVariables.measuredVariables.position 				= 0;
	pedalVariables.measuredVariables.gyroVelocity 			= 0;
	pedalVariables.measuredVariables.positionPrevious 		= 0;

	pedalVariables.estimatedVariables.P_Minus 				= 0;
	pedalVariables.estimatedVariables.P_Plus 				= 0;
	pedalVariables.estimatedVariables.positionFilterMinus 	= 0;
	pedalVariables.estimatedVariables.positionFilterPlus 	= 0;
}
