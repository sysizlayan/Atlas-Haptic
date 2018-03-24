/*
 * QEI.cpp
 *
 *  Created on: 24 Mar 2018
 *      Author: Yigit
 */
#include "QEI.hpp"
_encoder::_encoder(uint32_t ppm)
{
    countToDegree = (360.0f) / ppm;

    ///////////
    // QEI0 Peripheral
    // PL3 --> Index
    // PL1 --> Phase A
    // PL2 --> Phase B
    SysCtlPeripheralEnable(SYSCTL_PERIPH_QEI0);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOL);

    GPIOPinConfigure(GPIO_PL3_IDX0);  // PL3 Index
    GPIOPinConfigure(GPIO_PL1_PHA0);  // PL1 Phase A
    GPIOPinConfigure(GPIO_PL2_PHB0);  // PL2 Phase B
    GPIOPinTypeQEI(GPIO_PORTL_BASE, GPIO_PIN_1 | GPIO_PIN_2 | GPIO_PIN_3);

    QEIConfigure(
            QEI0_BASE,
            (QEI_CONFIG_CAPTURE_A_B | QEI_CONFIG_NO_RESET
                    | QEI_CONFIG_QUADRATURE | QEI_CONFIG_NO_SWAP),
            ppm - 1); //the position will not be reset with index pulse
    QEIEnable(QEI0_BASE);
}

uint32_t _encoder::get_pos_count()
{
    positionCount = ROM_QEIPositionGet(QEI0_BASE);
    return positionCount;
}

int32_t _encoder::get_dir()
{
    direction = ROM_QEIDirectionGet(QEI0_BASE);
    return direction;
}

float _encoder::get_pos_0_360()
{
    get_pos_count();
    position = positionCount * countToDegree;

    return position;
}

float _encoder::get_pos_minus180_plus180()
{
    get_pos_count();
    position = positionCount * countToDegree;

    if (position > 180 && position <= 360)
        return position - 360.0f;

    return position;;
}

_encoder encoder(1999);
