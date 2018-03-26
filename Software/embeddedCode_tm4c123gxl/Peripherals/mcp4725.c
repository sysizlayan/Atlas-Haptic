/*
 * mcp4725.c
 *
 *  Created on: 21 Mar 2018
 *      Author: Yigit
 */

#include "mcp4725.h"

void initMCP4725(void)
{
    SysCtlPeripheralEnable(SYSCTL_PERIPH_I2C3); // Enable I2C1 peripheral
    SysCtlDelay(2); // Insert a few cycles after enabling the peripheral to allow the clock to be fully activated
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOD); // Enable GPIOA peripheral
    SysCtlDelay(2); // Insert a few cycles after enabling the peripheral to allow the clock to be fully activated

    // Use alternate function
    GPIOPinConfigure(GPIO_PD0_I2C3SCL);
    GPIOPinConfigure(GPIO_PD1_I2C3SDA);

    GPIOPinTypeI2CSCL(GPIO_PORTD_BASE, GPIO_PIN_0); // Use pin with I2C SCL peripheral
    GPIOPinTypeI2C(GPIO_PORTD_BASE, GPIO_PIN_1); // Use pin with I2C peripheral

    I2CMasterInitExpClk(I2C3_BASE, SysCtlClockGet(), true); // Enable and set frequency to 400 kHz

    SysCtlDelay(2); // Insert a few cycles after enabling the I2C to allow the clock to be fully activated
}

void writeVoltage(uint32_t voltage)
{
    uint8_t outBuf[2];
    uint16_t deneme = voltage *10;

    outBuf[0] = deneme / 16;
    outBuf[1] = (deneme %16) << 4;
    mcp4725WriteData(MCP4725_ADDR,WRITE_VOLTAGE_DAC,outBuf,2);
}

void mcp4725WriteData(uint8_t addr, uint8_t regAddr, uint8_t *data, uint8_t length)
{
    uint8_t i;
    I2CMasterSlaveAddrSet(I2C3_BASE, addr, false); // Set to write mode

    I2CMasterDataPut(I2C3_BASE, regAddr); // Place address into data register
    I2CMasterControl(I2C3_BASE, I2C_MASTER_CMD_BURST_SEND_START); // Send start condition
    while (I2CMasterBusy(I2C3_BASE)); // Wait until transfer is done

    for (i = 0; i < length - 1; i++) {
        I2CMasterDataPut(I2C3_BASE, data[i]); // Place data into data register
        I2CMasterControl(I2C3_BASE, I2C_MASTER_CMD_BURST_SEND_CONT); // Send continues condition
        while (I2CMasterBusy(I2C3_BASE)); // Wait until transfer is done
    }

    I2CMasterDataPut(I2C3_BASE, data[length - 1]); // Place data into data register
    I2CMasterControl(I2C3_BASE, I2C_MASTER_CMD_BURST_SEND_FINISH); // Send finish condition
    while (I2CMasterBusy(I2C3_BASE)); // Wait until transfer is done
}
