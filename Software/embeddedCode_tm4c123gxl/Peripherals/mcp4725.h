/*
 * mcp4725.h
 *
 *  Created on: 21 Mar 2018
 *      Author: Yigit
 */

#ifndef PERIPHERALS_MCP4725_H_
#define PERIPHERALS_MCP4725_H_

#include "main.h"

#define MCP4725_ADDR 0x62
#define WRITE_VOLTAGE_DAC 0x40

void initMCP4725(void);
void writeVoltage(uint32_t voltage);
void mcp4725WriteData(uint8_t addr, uint8_t regAddr, uint8_t *data, uint8_t length);

#endif /* PERIPHERALS_MCP4725_H_ */
