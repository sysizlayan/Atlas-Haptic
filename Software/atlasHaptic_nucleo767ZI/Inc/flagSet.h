/*
 * flagSet.h
 *
 *  Created on: Sep 19, 2018
 *      Author: Kuartis
 */

#ifndef FLAGSET_H_
#define FLAGSET_H_

typedef struct _hapticFlagSet
{
	bool isIMUDiscovered;
} hapticFlagSet_t;

extern hapticFlagSet_t hapticFlagSet;
#endif /* FLAGSET_H_ */