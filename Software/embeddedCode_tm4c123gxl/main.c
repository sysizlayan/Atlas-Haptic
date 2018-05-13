/**
 * main.cpp
 */

#include "main.h"

#include "./Peripherals/Time.h"
#include "./Peripherals/LaunchPadButtonsAndLeds.h"
#include "./Peripherals/QEI.h"
#include "./Peripherals/VelocityTimer.h"
#include "./Peripherals/uarts.h"
#include "./Peripherals/MPU6050.h"
//#include "./Peripherals/mcp4725.h"
#include "./Peripherals/I2C.h"
#include "./Peripherals/hapticFeedbackTimer.h"

#include "sensorlib/hw_mpu6050.h"

#include "pedalVariables.h"
#include "simulationVariables.h"
#include "pointersForPrint.h"

#include "haptic_feedback.h"
#include "printFloat.h"


uint32_t g_systemClock;

int main(void)
{

    // CLOCK SET and FPU enabling
    ROM_SysCtlClockSet(SYSCTL_USE_PLL | SYSCTL_OSC_MAIN | SYSCTL_XTAL_16MHZ|SYSCTL_SYSDIV_2_5);//80Mhz Clock
    ROM_FPUEnable();//Enable FPU
    ROM_FPULazyStackingEnable();//Enable FPU stacking while interrupt

    g_systemClock=ROM_SysCtlClockGet();
    initTime();
    //IntMasterDisable();

    initializePrintPointers();

    // PORTF initialization
    // SW2 : PF0
    // SW0 : PF4
    // LED_R : PF1
    // LED_G : PF2
    // LED_B : PF3
    // Interrupts of buttons are disabled for now!
    portf_init();

    // Initialize QEI1 with
    // 2000 ppm, 100Hz update rate
    initQEI1(&g_sQEI1, 1999, 100);

    //
    // UART0 stdio initialization
    //
    //UART0, main usb connection in launchpad, as stdio source
    uart_stdio_init(460800);

    //
    // Initialize i2c module
    // SCL: PA6
    // SDA: PA7
    //
    initI2C();

    //initMCP4725();

    //
    // Initializes MPU6050 module with active low interrupt
    // MPU_INT pin: PE3
    //
    initMPU6050();

    //
    // Initialize the timer for pulse-width measurement
    // Uses WTIMER1 CCP pin, C7
    //initialize_pulse_timer(g_sQEI1.countToDegree);

    //
    // Initialize haptic feedback pulse timer
    // give_feedback will make PF2 up and starts timer
    // The interrupt will take PF2 down
    // TIMER0 peripheral
    //
    //hapticFeedbackTimerInit(800000); //10ms pulse length


    //GIVE GREEN LIGHT! :D
    GPIOPinWrite(GPIO_PORTF_BASE,GPIO_PIN_3,GPIO_PIN_3);
    delay(1000);
    //IntMasterEnable();
    while(true)
    {

    }
}
