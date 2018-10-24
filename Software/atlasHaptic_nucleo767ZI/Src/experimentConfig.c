/*
 * experimentConfigs.c
 *
 *  Created on: 22 Eki 2018
 *      Author: Yigit
 */

#include "experimentConfig.h"

experimentSineParams_t experimentSineParams;
experimentConfig_t experimentConfig;
char configJSONBuffer[1024];

void initExperimentConfig()
{
	experimentConfig.hapticDeviceState 		= BEGIN;
	experimentConfig.hasJSONCome 			= false;
	experimentConfig.period 				= 150000; // 2.5 mins
	experimentConfig.waitingPeriod 			= 10000; // 10 secs

	experimentSineParams.frequencies 	= (void *)0;
	experimentSineParams.magnitudes 	= (void *)0;
	experimentSineParams.phases 		= (void *)0;

	experimentSineParams.numberOfFrequencies = 0;
}

void readExperimentConfiguration(char* configurationString)
{
	// Avoid memory leaks
	if(!experimentSineParams.frequencies)
		free(experimentSineParams.frequencies);
	if(!experimentSineParams.magnitudes)
		free(experimentSineParams.magnitudes);
	if(!experimentSineParams.phases)
		free(experimentSineParams.phases);

	if(experimentSineParams.numberOfFrequencies > 0)
	{
		// Allocate memory for frequency array
		experimentSineParams.frequencies 	= (float*)malloc(experimentSineParams.numberOfFrequencies * sizeof(float));
		experimentSineParams.magnitudes 	= (float*)malloc(experimentSineParams.numberOfFrequencies * sizeof(float));
		experimentSineParams.phases 		= (float*)malloc(experimentSineParams.numberOfFrequencies * sizeof(float));
	}
}

