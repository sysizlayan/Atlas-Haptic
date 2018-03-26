/*
 * QEI.cpp
 *
 *  Created on: 20 Eki 2017
 *      Author: Yigit
 */
#include "QEI.h"
encoderReader g_sQEI1;

void update_QEI1_velocity(void);

void initQEI1(encoderReader* encReader, uint32_t ppm, uint32_t frequency)
{
    encReader->vel_samp_period = (uint32_t)(ROM_SysCtlClockGet()/frequency);
    encReader->vel_samp_freq = (float)frequency;
    encReader->countToDegree = (360.0f)/ppm;

    //QEI initialization
    ///////////
    // QEI1 Peripheral
    // PC4 --> Index
    // PC5 --> Phase A
    // PC6 --> Phase B
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_QEI1);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOC);

    ROM_GPIOPinConfigure(GPIO_PC4_IDX1);
    ROM_GPIOPinConfigure(GPIO_PC5_PHA1);
    ROM_GPIOPinConfigure(GPIO_PC6_PHB1);
    ROM_GPIOPinTypeQEI(GPIO_PORTC_BASE, GPIO_PIN_4 |  GPIO_PIN_5 | GPIO_PIN_6);

    ROM_QEIConfigure(QEI1_BASE, (QEI_CONFIG_CAPTURE_A_B | QEI_CONFIG_NO_RESET | QEI_CONFIG_QUADRATURE | QEI_CONFIG_NO_SWAP), ppm-1); //the position will not be reset with index pulse
    ROM_QEIVelocityConfigure(QEI1_BASE, QEI_VELDIV_1, encReader->vel_samp_period);
    ROM_QEIEnable(QEI1_BASE);
    ROM_QEIVelocityEnable(QEI1_BASE);

    //QEIIntRegister(QEI1_BASE, update_QEI1_velocity);

    //QEIIntEnable(QEI1_BASE, QEI_INTTIMER);

    //IntPrioritySet(INT_QEI1_TM4C123,HIGHEST_PRIORITY);
    //IntEnable(INT_QEI1_TM4C123);
}

uint32_t get_pos_count(encoderReader* encReader)
{
    encReader->positionCount = ROM_QEIPositionGet(QEI1_BASE);
    return encReader->positionCount;
}

int32_t get_dir(encoderReader* encReader)
{
    encReader->direction = ROM_QEIDirectionGet(QEI1_BASE);
    return encReader->direction;
}
float get_pos_0_360(encoderReader* encReader)
{
    get_pos_count(encReader);
    encReader->position = encReader->positionCount * encReader->countToDegree;

    return encReader->position;
}
float get_pos_minus180_plus180(encoderReader* encReader)
{
    get_pos_count(encReader);
    encReader->position = encReader->positionCount * encReader->countToDegree;
    if(encReader->position >= 0 && encReader->position <= 180)
        return encReader->position;
    if(encReader->position > 180 && encReader->position <= 360)
            return encReader->position - 360.0f;
    return 0.0;
}
/*uint32_t get_vel_count(encoderReader* encReader)
{
    encReader->velocityCount = ROM_QEIVelocityGet(QEI1_BASE);
    return encReader->velocityCount;
}*/

/*float get_vel(encoderReader* encReader)
{
    return encReader->velocity;
}*/

/*
void update_QEI1_velocity(void)
{
    QEIIntClear(QEI1_BASE, QEI_INTTIMER);  // clear velocity timer, timeout interrupt
    int32_t directed_velocity;
    float vel;
    encoder.get_dir(); //get direction first to be able to find sign
    encoder.get_vel_count(); //get velocity count
    directed_velocity = encoder.direction * (int)encoder.velocityCount * encoder.vel_samp_freq;
    vel= (float)directed_velocity * encoder.countToDegree ;
    encoder.velocity = vel;
}
*/

