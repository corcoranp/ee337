 /*
   Name:         Peter Corcoran, PMCORCOR
   Program:      LED CONTROL SUBSYSTEM
   Version:      1.0
   Date Started: Nov 30, 2014  
   
   PORT B
   The value sent to PORT B drives what is displayed on the 
   PB LEDS and 7 Segment LEDS
   
   PORT J Pin 1
   Pin 1 on Port J controls the display of PB LEDS      
   
   PORT P
   The value sent to Port P controls with of the 7 segement display 
   is on.
   
   
*/
#include "derivative.h"       //derivative-specific definitions
#include "common.h"         //just some of my c helpers...
#include "LedControl.h"

void count(int to);

bool isSegmentEnabled = false;
bool isPBLedsEnabled = false;
bool isDecimal = false;
bool isWholeNumber = false;
int segmentArr[10]      = {
  0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F
};
int decimalSegmentArr[10]      = {
  0xBF,0x86,0xDB,0xCF,0xE6,0xED,0xFD,0x87,0xFF,0xEF
};

int decimalPlace = 4;

/*
   Initializes the LEDS for usage.
*/
void initializeLeds(){
   //Allow LED output
   setOutputEnabled(true);   //PORT B as output
   //setSegmentLedsEnabled(true);//PORT P as output;   
   //Set Port Direction   
   DDRJ  = 0xFF;
   DDRP  = 0xFF;

}

/*
   
*/
void setPBLedsEnabled(bool enabled){
   isPBLedsEnabled = enabled;
   if(enabled){
      PTJ   = PTJ & 0xFD;    // PB LEDS enabled to light (pin 1 is low)
   }else {
      PTJ   = PTJ | 0x02;    // PB LEDS disabled (pin 1 is high)      
   }
}

/*
   Basically an On/Off Switch for all Segement LEDS
*/
void setSegmentLedsEnabled(bool enabled){
   isSegmentEnabled = enabled;
   if(enabled){
      //DDRP  = 0xFF;              //PORT P as output
      PTP = 0x00   ;
   }else{
      //DDRP  = 0x00;              //PORT P as input 
      PTP = 0x0F   ;
   }
}

/*
   Enables LED output
*/
void setOutputEnabled(bool enabled){
   if(enabled){
      DDRB = 0xFF;
   }else{
      DDRB = 0x00;
   }
}

/*
   Push output to port b
*/
void setLedOutput(int output){
   PORTB = output;
}

void showNumberOnSegment(int number, int segment){
   if((isDecimal || isWholeNumber) && segment == 2){
      PORTB = decimalSegmentArr[number];
   }else{
      PORTB = segmentArr[number];
   }
   showSegment(segment);
}

/*
   Show a specific segment (DSP 1-4)
   
*/
void showSegment(int segment){
   if(segment == 4){
      PTP   = 0x07; //ones place
   }
   if(segment == 3){
      PTP   = 0x0B; //tens place 
   }
   if(segment == 2){
      PTP   = 0x0D; //hundreds place 
   }
   if(segment ==1){
      PTP   = 0x0E; //thousands place
   }
   
}

void showMultiSegmentNumber(int number){
      int ones =0;
      int tens =0;
      int hund =0;
      int thou =0;
      
      //disable all segments
      PTP = 0x0F;
      if(!isSegmentEnabled) return;
      
      if(isWholeNumber){
         if(number>=10){         
            tens=number/10;
            showNumberOnSegment(tens, 1);
            count(500);
         }
         ones=(number-(tens*10));
         showNumberOnSegment(ones, 2);

         count(500);
         return;
      }
      
      if(isDecimal){
         if(number>=1000){
            thou=(number/1000);
         }
         if(number>=100){
            hund=(number-(thou*1000))/100;
         }
         if(number>=10){         
            tens=(number-(thou*1000)-(hund*100))/10;        
            showNumberOnSegment(tens, 3);
         }else{
            showNumberOnSegment(0,3);
         }
         count(500);
         ones=(number-(thou*1000)-(hund*100)-(tens*10));
         if(ones>0){
            showNumberOnSegment(ones, 4);
         }else{
            showNumberOnSegment(0, 4);
         }
         count(500);
         return;
      }
     
      if(number>=1000){
         thou=(number/1000);
         showNumberOnSegment(thou, 1);
         //adds a small delay that is needed to stablize the segment display
         count(100);     
      }
      if(number>=100){
         hund=(number-(thou*1000))/100;
         showNumberOnSegment(hund, 2);
         count(100);
      }
      if(number>=10){         
         tens=(number-(thou*1000)-(hund*100))/10;
         showNumberOnSegment(tens, 3);
         count(100);
      }
      ones=(number-(thou*1000)-(hund*100)-(tens*10));
      showNumberOnSegment(ones, 4);
      count(100);
      //PTP = 0xF;//turn it back off...
}

void count(int to){
   int i;
   for(i=0; i<=to;i++){
      asm("nop"); 
   }
}


/*
   Function that shows what's stored in the output on 
   the LEDs
*/
void show(int value){
   bool segmentlocal = isSegmentEnabled;
   bool pblocal = isPBLedsEnabled;
   PTP = 0x0F;  
    
   //set value
   setLedOutput(value);   
return;
   if(isSegmentEnabled){
      setPBLedsEnabled(false);
      //show on segment...
      showMultiSegmentNumber(value);
      setPBLedsEnabled(pblocal);
   }
   
}

void showDecimal(int wholeNumber, int decimalNumber){
   bool pblocal = isPBLedsEnabled;
   PTP = 0x0F;  //disable lcd
   //set value
   if(isSegmentEnabled){
      setPBLedsEnabled(false);
      isWholeNumber = true;
      setLedOutput(wholeNumber);
      showMultiSegmentNumber(wholeNumber);
      count(100);
      isWholeNumber = false;
      isDecimal = true;
      setLedOutput(decimalNumber);
      showMultiSegmentNumber(decimalNumber);
      setPBLedsEnabled(pblocal);
      isDecimal=false;
   }
   
   
}
