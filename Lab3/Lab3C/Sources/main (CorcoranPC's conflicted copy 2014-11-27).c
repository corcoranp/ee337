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
*                  |  | Date: November 14, 2014   |  |                       *      
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
#include "corcoran.h"



//FUNCTIONS
void initPorts(void);
void add(void);
void clear(void);
void updateDisplay(void);

//MEMBERS
unsigned int count;



/*  
   Function: Main
*/
void main(void) {
   count = 0;
   initPorts();
   
   while(true){
   }
    
   
}
/*  
   Function: initPorts
   Desc: initializes ports needed
*/
void initPorts(void){
   
   DisableInterrupts;
   
   DDRH &= 0xF0;  // make port H bit 0 an input port
   PPSH &= 0xF0;  // set polarity
   PIEH |= 0x0F;  // enable interupt on bit 0
   PIFH = 0xFF;   // clear all interrupt flags on portH
   
   DDRB  = 0xFF;  //PORT B as output   LEDS
   DDRJ  = 0xFF;      //PORT J as output
   DDRP  = 0X0F;      //disable 7 segment
   PTJ   = 0x00;     // LED display
   EnableInterrupts;   

}

/*  
   Function: myISR
   Desc: interrupt that is fired when a button is pressed.
*/
#pragma CODE_SEG __NEAR_SEG NON_BANKED
void interrupt VectorNumber_Vporth myISR(void){
   bool button0Pressed = (PIFH_PIFH0 == 1);  //is button 0 pressed?
   bool button1Pressed = (PIFH_PIFH1 == 1);  //is button 1 pressed?
   bool button2Pressed = (PIFH_PIFH2 == 1);  //is button 2 pressed?
   bool button3Pressed = (PIFH_PIFH3 == 1);  //is button 3 pressed?

   if(button0Pressed){
      add();
   }
   
   if(button1Pressed){
      clear();
   }
   updateDisplay();
   PIFH = 0x0F; // clear interrupt flags
}
#pragma CODE_SEG DEFAULT
/*  
   Function: add
   Desc: add value to counter
*/
void add(){
   count++;
}

void clear(){
   count = 0;
}

/*  
   Function: updateDisplay
   Desc: updates the display on the leds
*/
void updateDisplay(){
   PORTB = count;
}



