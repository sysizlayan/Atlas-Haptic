/*
 * experimentConfig.h
 *
 *  Created on: 22 Eki 2018
 *      Author: Yigit
 */

#ifndef EXPERIMENTCONFIG_H_
#define EXPERIMENTCONFIG_H_
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>

enum hapticDeviceStates
{
	BEGIN,
	CALIBRATION,
	WAITING_JSON,
	WAIT_FOR_SPECIFIC_TIME,
	RUNNING,
	STOPPED
};

typedef struct _experimentSineParams
{
	uint32_t numberOfFrequencies;
	float * frequencies;
	float * magnitudes;
	float * phases;
} experimentSineParams_t;

typedef struct _experimentConfig
{
	uint8_t hapticDeviceState;
	uint32_t period;
	uint32_t waitingPeriod;
	bool hasJSONCome;
} experimentConfig_t;

extern experimentConfig_t experimentConfig;
extern experimentSineParams_t experimentSineParams;
extern char configJSONBuffer[];

void initExperimentConfig();
void readExperimentConfiguration(char* configurationString);
#endif /* EXPERIMENTCONFIG_H_ */
