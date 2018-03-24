/*
 * QEI.hpp
 *
 *  Created on: 24 Mar 2018
 *      Author: Yigit
 */

#ifndef PERIPHERALS_QEI_HPP_
#define PERIPHERALS_QEI_HPP_
#include "main.h"
class _encoder
{
public:
    _encoder(uint32_t ppm);
    float get_pos_0_360();
    float get_pos_minus180_plus180();
    uint32_t get_pos_count();
    int32_t get_dir();
private:
    float position;
    int32_t direction;
    uint32_t positionCount;
    float countToDegree;

};
extern _encoder encoder;
#endif /* PERIPHERALS_QEI_HPP_ */
