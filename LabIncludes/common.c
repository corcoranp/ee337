 /*
   Name:         Peter Corcoran, PMCORCOR
   Program:      COMMON CONTROL
   Version:      1.0
   Date Started: Nov 30, 2014  
*/

#include "derivative.h"       //derivative-specific definitions
#include "common.h"         //just some of my c helpers...


/*
   Must make sure interrupts are off...
*/
void initSystemClock(){
//CLOCK SETUP
   //SYNTHESIZER
   SYNR     = 0x02;  // use PPL and 4-MHz crystal to genreate 24MHz clk
   REFDV    = 0;     // REFERENCEDIVIDER
   CLKSEL   =0x80;   // CLOCKSELECT, enable PPL, keep SYSCLK in wait mode   
   PLLCTL   =0x60;   // enable PPL, set automatic bandwidth control         
   while(!(CRGFLG & 0x08)); //wait until PLL locks into the target freq   
}