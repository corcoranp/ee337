/*
   Name:         Peter Corcoran, PMCORCOR
   Program:      LedControl.h - header for LED Controls 
                 For the HCS12 Dragon Plus2 
   Version:      1.0
   Date Started: Nov 30, 2014  
*/

extern int decimalPlace ;
extern void initializeLeds();
extern void setOutputEnabled(bool enabled);
extern void setPBLedsEnabled(bool enabled);
extern void setSegmentLedsEnabled(bool enabled);

extern void showNumberOnSegment(int number, int segment);
extern void showMultiSegmentNumber(int number);

extern void setLedOutput(int output);
extern void showSegment(int segment);

extern void show(int value);
extern void showDecimal(int wholeNumber, int decimalNumber);

