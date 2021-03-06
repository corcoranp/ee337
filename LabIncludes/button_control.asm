;******************************************************************************
;*                                                                            *
;*                  .---------------------------------.                       *           
;*                  |  .---------------------------.  |                       *      
;*                  |[]|                           |[]|                       *      
;*                  |  | Name: Peter M. Corcoran   |  |                       *      
;*                  |  | BlazerID: PMCORCOR        |  |                       *      
;*                  |  | Program: Button Cntrl Sys |  |                       *      
;*                  |  | Version: 1.0              |  |                       *      
;*                  |  | Date: September 28, 2014  |  |                       *      
;*                  |  |                           |  |                       *      
;*                  |  |                           |  |                       *      
;*                  |  |                           |  |                       *      
;*                  |  `---------------------------'  |                       *      
;*                  |      __________________ _____   |                       *      
;*                  |     |   ___            |     |  |                       *      
;*                  |     |  |   |           |     |  |                       *      
;*                  |     |  |   |           |     |  |                       *      
;*                  |     |  |   |           |     |  |                       *      
;*                  |     |  |___|           |     |  |                       *      
;*                  \_____|__________________|_____|__|                       *
;*                                                                            *
;******************************************************************************
;* Description: Button Control System                                         *
;* REFERENCED:                                                                *
;* HCS12_9S12 An Intro to Software and Hardware Interfacing 2nd Edition       *
;* - Chapter 7 Example 7.7                                                    *
;*                                                                            *
;* This file contains the controllers used for all button systems on the      *
;* Dragon 12 Plus 2                                                           *
;*                                                                            *
;******************************************************************************

;**** Define Public KEYPAD Methods
      XDEF        KeypadInitialization, ScanKeypad, WaitForKeypadPress
      XDEF        KeyPressed
      XDEF        PutKeyPressedInA          
      XDEF        PutKeyPressedInB
      XDEF        PutKeyPressedInX
      XDEF        PutKeyPressedInY
      XDEF        SwitchButtonInitialization

;**** DELAY INLUCDES
      XREF        Delay1s
      XREF        Delay100ms
      XREF        Delay20ms
      XREF        Delay10ms
      XREF        Delay5ms
      XREF        Delay1ms
      XREF        Delay500us
      XREF        Delay100us
      XREF        Delay50us      
      XREF        Delay10us 
      
      INCLUDE     'button_pmc.inc'      


;******************************************************************************
;* PH SW2-SW5 Push Button Controller Code Section                             *
;*                                                                            *
PHBUTTONS_CONTROLLER_CODE:    SECTION

SwitchButtonInitialization
      ;*** PUSH BUTTONS
      MOVB        #$00  ,PB_DIR           ;Make Port H an input port 
      RTS
END
;******************************************************************************
;* KeyPad Controller Code Section                                             *
;*                                                                            *
KEYPAD_CONTROLLER_CODE:    SECTION
      
      


;******************************************************************************
;* Keypad Initialization function                                             *      
KeypadInitialization:
      ;Only need to run once
      MOVB        #$F0,    KEYPAD_DIR     ;Set Port A as in/output
   RTS         

;******************************************************************************
;* Method for blocking the program until a button is pressed                  * 
WaitForKeypadPress:
      JSR         KeypadInitialization
      LDAA        #$00
      MOVB        #16, KeyPressed
      JSR         ScanKeypad
      CMPA        #16
      BEQ         WaitForKeypadPress
   RTS  



;******************************************************************************
;* Keypad Scanner                                                             * 
ScanKeypad:
      ;Start scan by resetting the control vars
      ;We want to return the number of the key pressed in A
      ;index=val, 0=1, 1=2, 2=3, 3=A etc.
      PSHX
      PSHY
      ;PSHB
conditionVars:      
      
      LDX         #KEYS                   ;array
      LDAA        #0                      ;set A=0
      MOVB        #$1F,KEYPAD             ;Setup Keypad- since upper bits are 
                                          ; output they stay at their value

;brute for, just check the 16 values...
                                      
iteration:                                ;iterate through array items in rvrs
      ;if A <= 3  
      CMPA        #3
      BHI         T2
      MOVB        #$1F,KEYPAD
      BRA         EVAL
      
      ;if A <= 7
T2:   CMPA        #7
      BHI         T3
      MOVB        #$2F,KEYPAD
      BRA         EVAL
      
      ;if A <= 11
T3:   CMPA        #11
      BHI         T4
      MOVB        #$4F,KEYPAD
      BRA         EVAL
      
      ;if A <= 15
T4:   CMPA        #15
      BHI         noKeyPress              ;if A is 16 no item detected
      MOVB        #$8F,KEYPAD             ;set col flag...
      
EVAL: LDAB        KEYPAD                  ;Load B with number from array
      ;ANDB        KEYPAD                 ;AND them, if output is the same=matc
      LDY         a,x
      CMPB        a,x                     ;debounce and check again...
      BEQ         debounce
      ADDA        #1                      ;weren't the same, test next
      BRA         iteration               ;loop again...
      
debounce:                                 ;Debounce the item
      JSR         Delay20ms               ;wait...
      LDAB        KEYPAD                  ;test again..
      CMPB        a,x
      BEQ         onKeyPress              ;still the same, return value
      BRA         conditionVars           ;not the same, start over
noKeyPress:                             
      LDAA        #16
      STAA        KeyPressed              ;set the private var to 16
      BRA         exitScanKeypad
onKeyPress:                               ;return value in A
      MOVB        a,x,KeyPressed
      
              
exitScanKeypad:                           ;Exit keypad 
      ;PULB
      PULY
      PULX
   RTS                                    ;Return to sub


PutKeyPressedInA:                         
      LDAA        #KeyPressed
   RTS     
PutKeyPressedInB:
      LDAB        #KeyPressed
   RTS                         
PutKeyPressedInX:
      LDX         #KeyPressed
   RTS
PutKeyPressedInY:                                                     
      LDY         #KeyPressed
   RTS   
   
  
  
;******************************************************************************
;*   ___      __                                                              *
;*  | _ \___ / _|___ _ _ ___ _ _  __ ___ ___                                  *
;*  |   / -_)  _/ -_) '_/ -_) ' \/ _/ -_|_-<                                  *
;*  |_|_\___|_| \___|_| \___|_||_\__\___/__/                                  *
;******************************************************************************
