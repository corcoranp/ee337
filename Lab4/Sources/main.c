/*
Name:         Peter Corcoran, PMCORCOR
Program:      Lab 4
Version:      1.0
Date Started: Nov 10, 2014  


DESCRIPTION:
   This is Lab 4 for EE337.  Binary Second Keeper
   In this lab assignment we start to use interrupts with timers.            
   
LAB MANUAL:
https://github.com/corcoranp/ee337/blob/master/ee337_lab_manual_v2_2.pdf
               
PRELAB:               
   In the example code for this lab, what are the main methods of altering the 
   timer frequency? Explain how each method affects the frequency.             

REQUIREMENTS:
   - No Blocking
   - Buttons can only be polled in interrupt
   - LEDs can only be set in main code
   - Count on LEDs
   - Up/Down at 1 second
   - Stop at 255
   - Stop at 0
   
   PORT H0
   - Starts counting when PortH_0 pressed first time
   - Stop when pressed second time
   PORT H1
   - First press, count up
   - Second press, count down
   PORT H2
   - Preset timer to 255
   PORT H3
   - Preset timer to 0
   

ADDITIONAL INFORMATION:
   Hardware Used: DRAGON12 PLUS2
http://www.evbplus.com/dragon12_plus2_9s12_hcs12/dragon12_plus2_9s12_hcs12.html   

   There are two clock sources for the MC9S12 Hardware
   -  8 MHZ - Oscillator Clock 
            - Used by Real Time Interrupt system
   - 24 MHz - Bus Clock 
            - Used by the Timer System 

REGISTER DEFINITIONS
   CRGINT:     Clock & Reset Generator INTerrupt enable register 
   CRGFLG:     Clock & Reset Generator Flag
   RTICTL:     Real-Time Interrupt Control
   
   
REAL TIME INTERRUPT  (RTI) CHARACTERISTICS 
   Interrupt Mask:   
      RTIE bit of the CRGINT register
      When RTI occurs the RTIE bit of the CRGFLG register is set
      To clear the RTI write a 1 to the RTIF bit of the CRGFLG
   
*/

//----------------------------Include Libraries--------------------------------

#include <hidef.h>            //common defines and macros 
#include "derivative.h"       //derivative-specific definitions
//#include "vectors12.h"        //RAM-Based interrupt vectors
#include "corcoran.h"         //just some of my c helpers...



//INTERRUPTS
//interrupt VectorNumber_Vrti void checkState(void); // interrupt function for checking
//void interrupt VectorNumber_Vrti checkState(void) ;


//INIT FUNCTIONS
void initializeLab(void);     //Initialization of program 
void initSystemClock(void);
void initSystemPorts(void);
void initSystemInterrupts(void);
void systemController(void);
void updateDisplay(void);
bool setFlag(bool currentState, bool *previousState);

//VARS
volatile int counter             = 0;     //current count
int counterUpperLimit   = 255;   //upper limit of counter before repeat
int counterLowerLimit   = 0;     //lower limit of counter before repeat

const int timerLimit    = 122; // 1s/8.192ms = 122
volatile int timer      = 0;     //number of RTI times past...
volatile int iterator   = 0;     //timer iterator

bool isCounterOn        = true; //is counting 0 = false; 1 = true;
bool isCountingUp       = true;  //is counting up = false; 1 = true;

bool isCounterOnFlagged  = false; // CounterOn Flag Raised
bool isCountingUpFlagged = false; //Reset Flag
bool isPresetHighFlagged = false;
bool isPresetLowFlagged  = false;

struct buttonPressState buttonState;


//#region ----------- STARTUP/RUN CODE ----------

/*  
   Function: Main
   
   - SHOULDN'T scan buttons
   - SHOULDN'T use privates vars from interupt
   - MUST interact with shared vars
   - MUST update LEDs on port B with counter value
*/
void main(void) {
   initializeLab();           //Initialize the lab

   while(true){
      systemController();     //control system...      
      updateDisplay();        //update display with value
   }
}


/* 
   InitializeLab - Initialization of system
*/
void initializeLab(){
      DisableInterrupts;      //Disables interrupts while init is running
      initSystemClock(); 
      initSystemPorts();
      initSystemInterrupts();
      EnableInterrupts;
}


void initSystemClock(){
//CLOCK SETUP
   //SYNTHESIZER
   SYNR     = 0x02;  // use PPL and 4-MHz crystal to genreate 24MHz clk
   REFDV    = 0;     // REFERENCEDIVIDER
   CLKSEL   =0x80;   // CLOCKSELECT, enable PPL, keep SYSCLK in wait mode   
   PLLCTL   =0x60;   // enable PPL, set automatic bandwidth control         
   while(!(CRGFLG & 0x08)); //wait until PLL locks into the target freq     
}


void initSystemPorts(){
//PORTS 
      DDRB  = 0xFF;      //PORT B as output
      DDRJ  = 0xFF;      //PORT J as output
      DDRP  = 0X0F;      //disable 7 segment
      PTJ   = 0x00;     // LED display
      PTH   = 0;         // push button inputs...
}


void initSystemInterrupts(){
//INTERRUPTS 
      CRGINT |= CRGINT_RTIE_MASK;     //enable RTI 	 
      RTICTL = 0x70;    //RTI Interval = 8.192ms 

      //set each button state.      
      buttonState.button0Pressed = false;
      buttonState.button1Pressed = false;
      buttonState.button2Pressed = false;
      buttonState.button3Pressed = false;
}

//#endregion ----------- STARTUP/RUN CODE ----------




//#region ----------- HELPER METHODS ----------
void compliment(bool *val){
   if(*val){
      *val = false;
   }
   else{
      *val = true;
   }   
}

/*
   Function:   systemController
   Params:     none
   Return:     none
   Desc:       Function to control system's functions
*/
void systemController(){
      //Start/Stop 
      if(isCounterOnFlagged){ //system on/off by button
         isCounterOnFlagged = false;     //reset flag
         compliment(&isCounterOn);
      }else { //system on/off by rule
         //isCounterOn = !((isCountingUpFlagged==true & counter==counterUpperLimit) || (isCountingUpFlagged==false & counter==counterLowerLimit));
      }
      //check for direction change
      if(isCountingUpFlagged){
         isCountingUpFlagged = false;  // reset flag
         compliment(&isCountingUp);
         //isCountingUp != isCountingUp; // flip up counter
      }
      //check for HIGH reset
      if(isPresetHighFlagged){
         isPresetHighFlagged = false; //reset flag
         counter = counterUpperLimit;         
      }
      //check for LOW reset
      if(isPresetLowFlagged){
         isPresetLowFlagged = false; //reset flag
         counter = counterLowerLimit;
      }
}


/*
   Function:   updateDisplay
   Params:     none
   Return:     none
   Desc:       Function updates the counter displayed on the LEDs
*/
void updateDisplay(){
      
      PORTB = counter;             //display on LEDs
      PTP   = 0x0F; 
      if(isCounterOn == false){
         return;                    //Just show on LEDs then return
      }
      
      if(timer >= timerLimit ){     //count every 26042 cycles
         if(isCountingUp){          //if counting up, add one
            counter++;
         } else {                   //if counting down, minus one
            counter--;
         }
         timer = 0;                 //reset counter
      }
}

//#endregion ----------- HELPER METHODS ----------






//#region ----------- Interrupt CODE ----------
#pragma CODE_SEG __NEAR_SEG NON_BANKED
/*
   Function:   checkState
   Return:     void
   Desc:       Interrupt for checking the state of the button.
*/
void interrupt VectorNumber_Vrti checkState(void){   
   //get current state:
   bool button0Pressed = (PTH & BIT0) == 0;  //is button 0 pressed?
   bool button1Pressed = (PTH & BIT1) == 0;  //is button 1 pressed?
   bool button2Pressed = (PTH & BIT2) == 0;  //is button 2 pressed?
   bool button3Pressed = (PTH & BIT3) == 0;  //is button 3 pressed?
   bool triggerFlag    = false;              //set trigger to false
  
   CRGFLG = 0X80;          //clear rti flag...
   timer++;                // increase timer value by 1

   /*
      BUTTON ANALYSIS:
      CURRENT PREVIOUS
         0        0     = Disable flag
         1        1     = Disable flag
         1        0     = Enable flag & previous
         0        1     = Disable flag & previous
   */
   //BUTTON0 STATE ANALYSIS
   //If they are equal, disable the flag...   
   /*if(buttonState.button0Pressed==button0Pressed){
      isCounterOnFlagged = false;
   }
   if(!buttonState.button0Pressed & button0Pressed){
      buttonState.button0Pressed = isCounterOnFlagged = true;
   }
   if(buttonState.button0Pressed & !button0Pressed){
      buttonState.button0Pressed = isCounterOnFlagged = false;
   } */
   
   isCounterOnFlagged  = setFlag(button0Pressed, &buttonState.button0Pressed);
   isCountingUpFlagged = setFlag(button1Pressed, &buttonState.button1Pressed);
   isPresetHighFlagged = setFlag(button2Pressed, &buttonState.button2Pressed);
   isPresetLowFlagged  = setFlag(button3Pressed, &buttonState.button3Pressed); 
   
   //trigger flags only after 3 interrupts (20ms), and if this is a new press
   /*
   if(button0Pressed || button1Pressed || button2Pressed || button3Pressed){
      iterator++;    //a button is pressed, add 1 to iterator...
      
      //check previous button state...
      if(!(buttonState.button0Pressed==true & button0Pressed==true)){  
         //new press event
         buttonState.button0Pressed = button0Pressed;
      }
      
      //trigger only if new press
      triggerFlag = (iterator > 3); //trigger flag if iterator is greater than 9
   } 
   
   if(triggerFlag){
      if(button0Pressed) { //Read BIT0 for counter flag 
         isCounterOnFlagged   = true;
      }
      if(button1Pressed) { //Read Bit2 for direction flag  
         isCountingUpFlagged  = true;
      }                                                  
      //up    
      if(button2Pressed) { 
         isPresetHighFlagged = true;
      }
      //down    
      if(button3Pressed) { 
         isPresetLowFlagged = true;
      }
      iterator = 0;  //reset iterator...
   } */
}
#pragma CODE_SEG DEFAULT
bool setFlag(bool currentState, bool *previousState){
   if(*previousState==currentState){ //both states are equal = false
      return false;
   }
   if(!*previousState & currentState){
      return *previousState = true;
   }
   if(*previousState & !currentState){
      return *previousState = false;
   }
   return false; //always return false
}



//#endregion ----------- INTERRUPT CODE ----------








/*
******************************************************************************
    ___              _   _                                                   *
   / _ \ _  _ ___ __| |_(_)___ _ _  ___                                      *
  | (_) | || / -_|_-<  _| / _ \ ' \(_-<                                      *
   \__\_\\_,_\___/__/\__|_\___/_||_/__/                                      *
******************************************************************************
* QUESTIONS TO BE ANSWERED IN COMMENTS AT THE END OF YOUR CODE               *
1) What other applications might timers have?
2) What is the speed of the oscillator? (Refer to the schematics!!)
3) What changes would need to be made if the Oscillator speed was changed?
*/
