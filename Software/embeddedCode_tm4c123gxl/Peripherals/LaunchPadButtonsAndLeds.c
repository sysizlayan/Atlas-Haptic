/*
 * LaunchPadButtonsAndLeds.cpp
 *
 *  Created on: 20 Eki 2017
 *      Author: Yigit
 */
#include "LaunchPadButtonsAndLeds.h"
#include "simulationVariables_forSpringMassDamper.h"
#include "pedalVariables.h"

//Calculated Variables
/*extern float g_fposition_filtered_plus;
extern float g_fposition_filtered_minus;
extern float g_fP_minus;
extern float g_fP_plus;*/

void portf_int_handler()
{
    uint32_t status = GPIOIntStatus(GPIO_PORTF_BASE,0); // get which button is changed
    GPIOIntClear(GPIO_PORTF_BASE, 0x11); //clear corresponding interrupts
    ROM_SysCtlDelay(100); // wait for debouncing

    if(status&0x01) //PF0 interrupt
    {
        QEIPositionSet(QEI1_BASE, 0);

        g_ui32measurementTime = 0;

        g_ssimulatedMassStates.massPosition = 0.0f;
        g_ssimulatedMassStates.massVelocity = 0.0f;

        g_ssimulatedMassStates_prev.massPosition = 0.0f;
        g_ssimulatedMassStates_prev.massVelocity = 0.0f;

        g_ssimulatedForces.damperForce = 0.0f;
        g_ssimulatedForces.springForce = 0.0f;
        g_ssimulatedForces.totalForce = 0.0f;

        g_fposition_filtered_plus = 0.0f;
        g_fposition_filtered_minus = 0.0f;
        g_fP_minus = 0.0f;
        g_fP_plus = 0.0f;

    }
    if(status&0x10) //PF4 interrupt
    {

    }
}
void portf_init()
{
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOF); //enable portf
    HWREG(GPIO_PORTF_BASE + GPIO_O_LOCK)=GPIO_LOCK_KEY; //PF0 needs to be unlocked
    HWREG(GPIO_PORTF_BASE + GPIO_O_CR)=0x1F; //Allow changes in PF0,1,2,3,4
    ROM_GPIOPinTypeGPIOOutput(GPIO_PORTF_BASE,0x0E);
    ROM_GPIOPinTypeGPIOInput(GPIO_PORTF_BASE,0x11);
    ROM_GPIOPadConfigSet(GPIO_PORTF_BASE,0x0E,GPIO_STRENGTH_8MA,GPIO_PIN_TYPE_STD_WPU); //weak pull up, 8mA, pin 1,2,3
    ROM_GPIOPadConfigSet(GPIO_PORTF_BASE,0x11,GPIO_STRENGTH_8MA,GPIO_PIN_TYPE_STD_WPU); //weak pull up, 8mA, pin 0,4

    ROM_GPIOIntTypeSet(GPIO_PORTF_BASE, 0x11, GPIO_FALLING_EDGE); //for pin 0,4 enable falling edge interrupt
    GPIOIntRegister(GPIO_PORTF_BASE, portf_int_handler); //portf_int_handler is the interrupt handler
    IntPrioritySet(INT_GPIOF_TM4C123, LOWEST_PRIORITY);
    GPIOIntEnable(GPIO_PORTF_BASE, 0x11); //enable pf0, pf4 interrupts
}
