/*
******************************************************************************
*                                                                            *
*                  .---------------------------------.                       *           
*                  |  .---------------------------.  |                       *      
*                  |[]|                           |[]|                       *      
*                  |  | Name: Peter M. Corcoran   |  |                       *      
*                  |  | BlazerID: PMCORCOR        |  |                       *      
*                  |  | Program: Lab 3 C          |  |                       *      
*                  |  | Version: 1.0              |  |                       *      
*                  |  | Date: September 8, 2014   |  |                       *      
*                  |  |                           |  |                       *      
*                  |  |                           |  |                       *      
*                  |  |                           |  |                       *      
*                  |  `---------------------------'  |                       *      
*                  |      __________________ _____   |                       *      
*                  |     |   ___            |     |  |                       *      
*                  |     |  |   |           |     |  |                       *      
*                  |     |  |   |           |     |  |                       *      
*                  |     |  |   |           |     |  |                       *      
*                  |     |  |___|           |     |  |                       *      
*                  \_____|__________________|_____|__|                       *
*                                                                            *
******************************************************************************
 Description: LAB 3                                                          *
*/

#include <hidef.h>            /* common defines and macros */
#include "derivative.h"      /* derivative-specific definitions */

void initPorts(void);

unsigned int count;



void main(void) {
   count = 0;
   initPorts();
   
   while(1)
      ;
   
}



void initPorts(void){
   
   DisableInterrupts;
   
   DDRH &= 0xF0;  // make port H bit 0 an input port
   PPSH &= 0xF0;  // set polarity
   PIEH |= 0x0F;  // enable interupt on bit 0
   PIFH = 0xFF;   // clear all interrupt flags on portH
   
   EnableInterrupts;   

}

void interrupt VectorNumber_Vporth myISR(void){


   PIFH = 0x0F; // clear interrupt flags
}