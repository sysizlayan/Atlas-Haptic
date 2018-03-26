/*
 * printFloat.c
 *
 *  Created on: 4 Ara 2017
 *      Author: Yigit
 */
#include "printFloat.h"

//int g_print_integer, g_print_floating;
void printFloat(float number)
{
    int print_integer,print_floating;
    if(number>=0)
    {
        print_integer = (int)number;
        print_floating = (int)(1000.0f*number - print_integer);
    }
    else
    {
        number = -1*number;
        print_integer = (int)number;
        print_floating = (int)(1000.0f*number - print_integer);
        print_integer *= -1;
    }
    UARTprintf("%d.%d",print_integer,print_floating);
}
