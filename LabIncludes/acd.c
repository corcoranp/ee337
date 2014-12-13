/*
   Name:         Peter Corcoran, PMCORCOR
   Program:      Analog to Digital Converter
   Version:      1.0
   Date Started: Nov 14, 2014  
*/
#include <stdtypes.h>
#include "derivative.h"      /* derivative-specific definitions */
//#include "common.h"

Byte CTR5 = 0x00;
int _converter;

struct ATD {
   unsigned char *ATDCTR2;
   unsigned char *ATDCTR3;
   unsigned char *ATDCTR4;
   unsigned char ATDCTR5;
   unsigned char *ATDATDSTAT;
   unsigned char *ATDDR;
} thisATD;


void initializeACD(int converter){
   if(converter==0){
      ATD0CTL2 = 0x80; 
      ATD0CTL3 = 0x08;  
      ATD0CTL4 = 0xEB;  
      ATD0CTL5 = 0x87;  
      _converter=0;
      /*
      thisATD.ATDCTR2 = &ATD0CTL2;   
      thisATD.ATDCTR3 = &ATD0CTL3;
      thisATD.ATDCTR4 = &ATD0CTL4;
      thisATD.ATDCTR5 = CTR5;
      thisATD.ATDATDSTAT = &ATD0STAT0;
      thisATD.ATDDR   = &ATD0DR0L;      
      */
   }
   if(converter==1){
      ATD1CTL2 = 0x80; 
      ATD1CTL3 = 0x08;  
      ATD1CTL4 = 0xEB;  
      ATD1CTL5 = 0x87;  
      _converter=1;
      /*
      thisATD.ATDCTR2 = &ATD1CTL2;   
      thisATD.ATDCTR3 = &ATD1CTL3;
      thisATD.ATDCTR4 = &ATD1CTL4;
      thisATD.ATDCTR5 = CTR5;
      thisATD.ATDATDSTAT = &ATD1STAT0;
      thisATD.ATDDR   = &ATD1DR0L;   
      */
   }
}

void enableACD(Bool enabled){
   if(enabled){
      *thisATD.ATDCTR2 = *thisATD.ATDCTR2 | 0x80;
   }else{
      *thisATD.ATDCTR2 = *thisATD.ATDCTR2 & 0x7F;      
   }
}

void selectConversionPerSequence(int number){
   *thisATD.ATDCTR3 = *thisATD.ATDCTR3 | number;
}

void enable8BitMode(void){
   *thisATD.ATDCTR4 = 0xEB;
}
void enable10BitMode(void){
   
}

void enableLeftJustified(void){
   thisATD.ATDCTR5 = CTR5 | 0x80;
}
void enableRightJustified(void){
   thisATD.ATDCTR5 = CTR5 & 0x7F;      
}

void enableUnsignedData(){
   thisATD.ATDCTR5 = CTR5 & 0xBF;
}
void enableSignedData(){
   thisATD.ATDCTR5 = CTR5 | 0x40;
}

void enableMultiChannel(){
   thisATD.ATDCTR5 = CTR5 | 0x10;
}
void enableSingleChannel(int channelSelect){
   thisATD.ATDCTR5 = CTR5 & 0xEF;
   thisATD.ATDCTR5 = CTR5 | channelSelect;
}

void enableScanOneSequence(){
   thisATD.ATDCTR5 = CTR5 & 0xEF;
}
void enableScanMultiSequence(){
   thisATD.ATDCTR5 = CTR5 | 0x20;
}

Bool isInReadyStatus(){
   if(!(thisATD.ATDCTR5 & 0x80)){
      return FALSE;
   }
   return TRUE;
}
void startNewADCSequence(){
   //*thisATD.ATDCTR5 = 0x87;//CTR5;
   //ATD0CTL5 = CTR5;
      
   //startNewADCSequence();
   ATD0CTL5 = 0x87;  
   while(!(ATD0STAT0 & 0x80));
}


Byte getData(){
   return ATD0DR0L; //*thisATD.ATDDR;
}