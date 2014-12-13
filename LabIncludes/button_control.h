/*
   Name:         Peter Corcoran, PMCORCOR
   Program:      Button Control Header
   Version:      1.0
   Date Started: Nov 30, 2014  
*/

extern void initializePushButtons();
extern void setSwitchEnabled(bool enabled);

struct buttonPressState {
   bool button0Pressed;
   bool button1Pressed;
   bool button2Pressed;
   bool button3Pressed;
};

extern struct buttonPressState buttonStateSingleton;
extern void getButtonState();
extern void clearButtonState();
extern bool setFlag(bool currentState, bool *previousState);

