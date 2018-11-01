/*
 * parseConfig.c
 *
 *  Created on: 1 Kas 2018
 *      Author: Yigit
 */

#include "parseConfig.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "cJSON/cJSON.h"
#include "simulation/simulationVariables_forSpringMassDamper.h"
#include "experimentConfig.h"

bool parseConfigurationJSON(char* jsonBuffer)
{
	cJSON *configJson = cJSON_Parse(jsonBuffer);
	if (configJson == NULL)
	{
		printf("Error parsing json!");
		return false;
	}

	cJSON *experimentPeriod = cJSON_GetObjectItemCaseSensitive(configJson,
			"experimentPeriod");
	if (cJSON_IsNumber(experimentPeriod))
		experimentConfig.period = (uint32_t) experimentPeriod->valueint;

	cJSON *kSpringJ = cJSON_GetObjectItemCaseSensitive(configJson, "kSpring");
	if (cJSON_IsNumber(kSpringJ))
		k_spring = (float) kSpringJ->valuedouble;

	cJSON *bDamperJ = cJSON_GetObjectItemCaseSensitive(configJson, "bDamper");
	if (cJSON_IsNumber(bDamperJ))
		b_damper = (float) bDamperJ->valuedouble;

	cJSON *value1 = cJSON_GetObjectItemCaseSensitive(configJson, "forceGain");
	if (cJSON_IsNumber(value1))
		forceGain = (float) value1->valuedouble;

	cJSON *value2 = cJSON_GetObjectItemCaseSensitive(configJson, "forceBias");
	if (cJSON_IsNumber(value2))
	{
		forceBias = (float) value2->valuedouble;
	}

	cJSON *value3 = cJSON_GetObjectItemCaseSensitive(configJson, "numberFreq");
	if (cJSON_IsNumber(value3))
	{
		experimentSineParams.numberOfFrequencies = (uint32_t) value3->valueint;
	}
	if (experimentSineParams.numberOfFrequencies < 0
			|| experimentSineParams.numberOfFrequencies > 10)
		printf("ERROR Number of frequencies is errorous!");
	else
	{
		experimentSineParams.frequencies = (float*) malloc(
				sizeof(float) * experimentSineParams.numberOfFrequencies);
		experimentSineParams.magnitudes = (float*) malloc(
				sizeof(float) * experimentSineParams.numberOfFrequencies);
		experimentSineParams.phases = (float*) malloc(
				sizeof(float) * experimentSineParams.numberOfFrequencies);

		cJSON *value4 = cJSON_GetObjectItemCaseSensitive(configJson, "freqs");
		if (cJSON_IsArray(value4)
				&& cJSON_GetArraySize(value4)
						== experimentSineParams.numberOfFrequencies)
		{
			for (int i = 0; i < experimentSineParams.numberOfFrequencies; i++)
			{
				cJSON *item = cJSON_GetArrayItem(value4, i);
				if (cJSON_IsNumber(item))
				{
					experimentSineParams.frequencies[i] =
							(float) item->valuedouble;
				}
			}
		}

		cJSON *value5 = cJSON_GetObjectItemCaseSensitive(configJson, "phases");
		if (cJSON_IsArray(value5)
				&& cJSON_GetArraySize(value5)
						== experimentSineParams.numberOfFrequencies)
		{
			for (int i = 0; i < experimentSineParams.numberOfFrequencies; i++)
			{
				cJSON *item = cJSON_GetArrayItem(value5, i);
				if (cJSON_IsNumber(item))
				{
					experimentSineParams.phases[i] = (float) item->valuedouble;
				}
			}
		}

		cJSON *value6 = cJSON_GetObjectItemCaseSensitive(configJson,
				"magnitudes");
		if (cJSON_IsArray(value6)
				&& cJSON_GetArraySize(value6)
						== experimentSineParams.numberOfFrequencies)
		{
			for (int i = 0; i < experimentSineParams.numberOfFrequencies; i++)
			{
				cJSON *item = cJSON_GetArrayItem(value6, i);
				if (cJSON_IsNumber(item))
				{
					experimentSineParams.magnitudes[i] =
							(float) item->valuedouble;
				}
			}
		}
	}
	cJSON_Delete(configJson);
	return true;
}
