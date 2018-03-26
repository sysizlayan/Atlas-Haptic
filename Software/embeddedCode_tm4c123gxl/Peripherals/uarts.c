/*
 * uartInitialization.c
 *
 *  Created on: 4 Ara 2017
 *      Author: Yigit
 */

#include "./Peripherals/uarts.h"
#include "../printFloat.h"
extern int32_t g_i32gyroVelocity_raw;
extern const float resolution;
extern float g_fgyroVelocity;

extern uint8_t g_pui8uart7Buffer[32];
extern uint8_t g_ui8uart7BufferCount;

void uart_stdio_init(uint32_t baudrate)
{
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOA); //open clock for port a
    ROM_GPIOPinTypeUART(GPIO_PORTA_BASE, GPIO_PIN_0 | GPIO_PIN_1); // set pin 0 and 1 as uart
    ROM_GPIOPinConfigure(GPIO_PA0_U0RX); //PA0 as Rx
    ROM_GPIOPinConfigure(GPIO_PA1_U0TX); //PA1 as Tx
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_UART0); //Open clock for UART0
    UARTStdioConfig(0, baudrate, ROM_SysCtlClockGet()); //Configure UART0 as stdio
    IntPrioritySet(INT_UART0_TM4C123, LOWEST_PRIORITY);

}

