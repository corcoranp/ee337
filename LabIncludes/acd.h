/*
   Name:         Peter Corcoran, PMCORCOR
   Program:      Analog to Digital Converter Header
   Version:      1.0
   Date Started: Nov 14, 2014  
   
   AD results are stored in the registers ATD0DR0-ATD0DR7
   
   Need to setup 
   - ATD0CTL2
   - ATD0CTL3
   - ATD0CTL4
   - ATD0CTL5
   
   ATD0 uses eight bits of Port AD0 called PAD00 - PAD07
   ATD1 uses Port AD1 called PAD08 - PAD15
   
   Must choose between single or continuous conversion 
   
   
*/



/*
   requires a converter to be selected (0 or 1)
*/
void initializeACD(int converter);

void enableACD(Bool enabled);

void selectConversionPerSequence(int number);

void enable8BitMode(void);
void enable10BitMode(void);

void enableLeftJustified(void);
void enableRightJustified(void);

void enableUnsignedData();
void enableSignedData();

void enableMultiChannel();
void enableSingleChannel(int channelSelect);

void enableScanOneSequence();
void enableScanMultiSequence();

Bool isInReadyStatus();
void startNewADCSequence();

Byte getData();
