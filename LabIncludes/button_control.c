 /*
Name:         Peter Corcoran, PMCORCOR
Program:      PUSH BUTTON CONTROL SUBSYSTEM
Version:      1.0
Date Started: Nov 30, 2014  
*/

#include "derivative.h"       //derivative-specific definitions
#include "common.h"           //just some of my c helpers...
#include "button_control.h"




void initializePushButtons(){
   setSwitchEnabled(true);
   clearButtonState();
}

void setSwitchEnabled(bool enabled){
   if(enabled){
      PTH = 0; //enable for input   
   }else{
      PTH = 1; //disable (output)
   }
}


void getButtonState(){
   buttonStateSingleton.button0Pressed = (PTH & BIT0) == 0;  //is button 0 pressed?
   buttonStateSingleton.button1Pressed = (PTH & BIT1) == 0;  //is button 1 pressed?
   buttonStateSingleton.button2Pressed = (PTH & BIT2) == 0;  //is button 2 pressed?
   buttonStateSingleton.button3Pressed = (PTH & BIT3) == 0;  //is button 3 pressed?
}

void clearButtonState(){
   //set each button state.      
   buttonStateSingleton.button0Pressed = false;
   buttonStateSingleton.button1Pressed = false;
   buttonStateSingleton.button2Pressed = false;
   buttonStateSingleton.button3Pressed = false;
}


/*
   BUTTON ANALYSIS:
   CURRENT PREVIOUS
      0        0     = Disable flag
      1        1     = Disable flag
      1        0     = Enable flag & previous
      0        1     = Disable flag & previous
*/
bool setFlag(bool currentState, bool *previousState){
   if(*previousState==currentState){ //both states are equal = false
      return false;
   }
   if(!*previousState && currentState){
      return *previousState = true;
   }
   if(*previousState && !currentState){
      return *previousState = false;
   }
   return false; //always return false
}