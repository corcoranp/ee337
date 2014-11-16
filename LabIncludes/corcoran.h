/*
   Name:         Peter Corcoran, PMCORCOR
   Program:      corcoran.h - header for common items
   Version:      1.0
   Date Started: Nov 14, 2014  
*/


#define BIT0 0x01
#define BIT1 0x02
#define BIT2 0x04
#define BIT3 0x08
#define BIT4 0x10
#define BIT5 0x20
#define BIT6 0x40
#define BIT7 0x80


/*
   Define a boolean type 
*/
typedef enum { false, true } bool;
void compliment(bool *val);

struct buttonPressState {
   bool button0Pressed;
   bool button1Pressed;
   bool button2Pressed;
   bool button3Pressed;
};