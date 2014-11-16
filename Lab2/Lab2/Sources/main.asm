;******************************************************************************
;*                                                                            *
;*                  .---------------------------------.                       *           
;*                  |  .---------------------------.  |                       *      
;*                  |[]|                           |[]|                       *      
;*                  |  | Name: Peter M. Corcoran   |  |                       *      
;*                  |  | BlazerID: PMCORCOR        |  |                       *      
;*                  |  | Program: Lab 2            |  |                       *      
;*                  |  | Version: 1.0              |  |                       *      
;*                  |  | Date: September 8, 2014   |  |                       *      
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
; Description: LAB 2                                                          *
; SEE CORCORAN.INC for included variable references                           *
;******************************************************************************
;*    ___           _         _                                               *
;*   | _ \_ _ ___  | |   __ _| |__                                            *
;*   |  _/ '_/ -_) | |__/ _` | '_ \                                           *
;*   |_| |_| \___| |____\__,_|_.__/                                           *
;*                                                                            *
;******************************************************************************
; 1.  Explain the purpose of the software delay that is required for this lab 
;     assignment. 
;     The purpose of the software delay is to wait a specific amount of time
;     that is known to be longer than the time it takes for the switch to 
;     "bounce". This avoids getting multiple switch presses

; 2.  Explain how the X and Y registers are used in the example code to 
;     create a 32-bit number
;     Y is set to 4095 decimal,  
;     X is set to 65,535 decimal
;     Using nested looping X is looped through 4095, which is like multiplying      
;     these two numbers: 65535x4095= 268,365,825
;     which requires 27bits to represent, or 32bits since X & Y are 16bits    

; 3.  Explain how this is different than two 16-bit numbers.
;     You could use 2 16bit numbers to represent a 32bit number, using 
;     one 16bit number as the bottom, and the other as the top.  However,
;     using the nested looping method, a count is used and which weaves the 
;     count between the two registers.  Meaning Y=0 is the count from 1
;     to 65535, Y=2 is the count from 65536 to 2x65535, and so on.



;******************************************************************************
;*    __   __        _      _    _       ___       __                         *
;*    \ \ / /_ _ _ _(_)__ _| |__| |___  |   \ ___ / _|___                     *
;*     \ V / _` | '_| / _` | '_ \ / -_) | |) / -_)  _(_-<                     *
;*      \_/\__,_|_| |_\__,_|_.__/_\___| |___/\___|_| /__                      *
;*                                                                            *
;******************************************************************************
;-----------------------------Include Libraries--------------------------------
;*                                                                            *  
      
      XDEF        Entry, MAIN                                                
      XREF        __SEG_END_SSTACK        ;Stack Pointer setup

;**** COMMON INLUCDES
      XREF        SetClockTo48MHz
      
;**** DELAY INLUCDES
      XREF        Delay1s
      XREF        Delay500ms
      XREF        Delay100ms
      XREF        Delay20ms
      XREF        Delay10ms
      XREF        Delay5ms
      XREF        Delay1ms
      XREF        Delay500us
      XREF        Delay100us
      XREF        Delay50us      
      XREF        Delay10us  
      
;**** LED INLUCDES
      XREF        LedInitialization      
      XREF        Display7Segment
      XREF        Display7SegmentOff    
      XREF        TurnLedsOn
      XREF        TurnLedsOff
      XREF        SetLedsWithRegisterA
      XREF        SetLedsWithRegisterB
      XREF        DisplayNumberInD
      
;**** LCD INLUCDES
      XREF        LcdInitialization 
      XREF        SetLcdFxOff
      XREF        LcdWriteLine1 
      XREF        LcdWriteLine2  
      XREF        SetLcdFxTextDelay
      XREF        ClearDisplay
                                     
;**** KEYPAD/BUTTON INCLUDES
      XREF        KeypadInitialization
      XREF        WaitForKeypadPress
      XREF        ScanKeypad
      XREF        PutKeyPressedInA
      XREF        KeyPressed
      XREF        SwitchButtonInitialization

      
;**** Buzzer
      XREF        BuzzerInitialization 
      XREF        BuzzerOn

;*                                                                            *
;**** FILE INJECTION **********************************************************
;*                                                                            *      
      INCLUDE     'mc9s12dg256.inc';                                         
      INCLUDE     'common_pmc.inc'
      INCLUDE     'lcd_pmc.inc' 
;*                                                                            *
;******************************************************************************
;-----------------------------variable/data section----------------------------
;*  LOCAL DATA CONDITIONING

                  ORG      $2000          ;Starting Memory location
CURRENT_LED:      DS.B     1              ;Track current led
CURRENT_COUNT:    DS.B     1              ;COUNTER VALUE
RETURNED_KEY:     DS.B  1      

;******************************************************************************
;  LAB VARIABLES SECTION
;******************************************************************************
;*  Lab 0 Variables
l0title:          FCC      "Lab 0 - Intro to"
l0title2:         FCC      "Assembly        "
l0intro1:         FCC      "Load 5 random   "
l0intro2:         FCC      "complex numbers "
l0intro3:         FCC      "into memory.    "
l0intro4:         FCC      "Add them togeth-"
l0intro5:         FCC      "er.             "


l2intro1:         FCC      "Lab 2 Debouncing"

array             DC.B     $02,$01,$04,$03,$06,$05,$08,$07,$0A,$09;

lab3display:      FCC      "Lab 3 Selected  "

count             RMB      1

DISP1_VAL:        DS.B     1              ;Word value to display in 1
DISP2_VAL:        DS.B     1              ;Word value to display in 2
DISP3_VAL:        DS.B     1              ;Word value to display in 3
DISP4_VAL:        DS.B     1              ;Word value to display in 4 
INDEX             DS.B     1
;Number array: contains 7segment numbers in value placeholder
NUMARR:           DC.B     $3F,$06,$5B,$4F,$66,$6D,$7D,$07,$7F,$6F;


;******************************************************************************
;*   __  __      _        ___                                                 *
;*  |  \/  |__ _(_)_ _   | _ \_ _ ___  __ _ _ _ __ _ _ __                     *
;*  | |\/| / _` | | ' \  |  _/ '_/ _ \/ _` | '_/ _` | '  \                    *
;*  |_|  |_\__,_|_|_||_| |_| |_| \___/\__, |_| \__,_|_|_|_|                   *
;*                                    |___/                                   *
;******************************************************************************                        
;           
MYCODE:           SECTION
MAIN:
Entry:
;******************************************************************************
;*  System Initialization
;* 
      LDS         #__SEG_END_SSTACK       ;Stack Starting Addy
      JSR         SetClockTo48MHz         ;Set Clock Speed
      
      
     
      
;******************************************************************************
;*  Program Initialization - Base port,stack,etc initialization...

      ;***  INITIALIZE REGISTER VALUES
      LDAA        #OFF
      LDAB        #OFF
      LDX         #OFF 
      LDY         #OFF
      
      ;***  LED Initialization       
      JSR         LedInitialization
    
      ;*** LCD Initialization
    	JSR	      LcdInitialization		   ;LCD Initialization
    	JSR         SetLcdFxOff             ;LCD Visual Effects
      
      ;*** PUSH BUTTON INIT
      JSR         SwitchButtonInitialization
      
    
;******************************************************************************
;*  MAIN LOOP
MAINLOOP:                                 ;LOOP FOREVER

      JSR         LcdMenu                 ;Show Lab Menu
      JSR         KeypadInitialization    ;Keypad Buttons init

MENUSELECT:                               ;Menu selection loop
      JSR         WaitForKeypadPress      ;Wait for a key press on keypad
      STAA        RETURNED_KEY            ;The return value stored in var
      
      CMPA        #0                      ;compare keypad index 0 to A
      LBEQ        StartLab1               ;Show selection and execute lab0

      CMPA        #1                      ;Index 1, Lab 2
      LBEQ        StartLab2
      
      CMPA        #2                      ;Index 2, Lab 3
      LBEQ        StartLab3

      CMPA        #13                     ;Index 13, Lab 0
      LBEQ        StartLab0



      CMPA        #4   
      JMP         PushedA
      

           
      BRA         MAINLOOP                ;Go Back to Main



;******************************************************************************
;*   ___      _        ___          _   _                                     *
;*  / __|_  _| |__ ___| _ \___ _  _| |_(_)_ _  ___ ___                        *
;*  \__ \ || | '_ \___|   / _ \ || |  _| | ' \/ -_|_-<                        *
;*  |___/\_,_|_.__/   |_|_\___/\_,_|\__|_|_||_\___/__/                        *
;*                                                                            *
;******************************************************************************

LcdMenu:

      LDX         #MENU_WELCOME           ;load welcome screen to x
      JSR         LcdWriteLine1           ;and write it out....
      LDX         #AUTHOR
      JSR         LcdWriteLine2
      JSR         Delay1s
      JSR         Delay1s
      JSR         Delay1s

   
      LDX         #MAINMENU
      JSR         LcdWriteLine1
      LDX         #MAINMENU1
      JSR         LcdWriteLine2
      JSR         Delay1s
      JSR         Delay1s      
      
      LDX         #MAINMENU2
      JSR         LcdWriteLine1
      LDX         #EMPTY
      JSR         LcdWriteLine2
      JSR         Delay1s
      JSR         Delay1s      
      
      LDX         #MAINMENU3
      JSR         LcdWriteLine1
      LDX         #MAINMENU4
      JSR         LcdWriteLine2
      JSR         Delay1s
      JSR         Delay1s      
   
  RTS
  
  
;******************************************************************************
;* Run Lab 0 Code
StartLab0:  

      LDX         #l0title                      
      JSR         LcdWriteLine1 
      LDX         #l0title2     
      JSR         LcdWriteLine2
      
      JSR         Delay1s
      JSR         Delay1s
      JSR         Delay1s

      JSR         ClearDisplay


      LDX         #l0intro1
      JSR         LcdWriteLine1
      LDX         #l0intro2
      JSR         LcdWriteLine2

      JSR         Delay1s
      LDX         #l0intro2
      JSR         LcdWriteLine1
      LDX         #l0intro3
      JSR         LcdWriteLine2

      JSR         Delay1s
      LDX         #l0intro3
      JSR         LcdWriteLine1
      
      LDX         #l0intro4
      JSR         LcdWriteLine2

      JSR         Delay1s
      LDX         #l0intro4
      JSR         LcdWriteLine1
      LDX         #l0intro5
      JSR         LcdWriteLine2
      JSR         Delay1s
      JSR         Delay1s
      JSR         Delay1s
      
n     EQU         5                       ;Set number of iterations
      LDX         #n                      ;Set x-index to iterator, 
      LDY         #array                  
Loop: DBEQ        x, l0End                ;go to end when done  
      INY                                 ;Increase y by 1
      INY           
      ADDD        y
      ;LDX         0,y
      ;JSR         LcdWriteLine2       
      JSR         Delay1s
      BRA         Loop                    ;Always Branch to Loop
l0End:      
      
      ;JSR         ClearDisplay
      LDX         #EMPTY                     
      JSR         LcdWriteLine1 
      LDX         #EMPTY  
      JSR         LcdWriteLine2
      LDX         #PRESS2CONTINUE      
      JSR         LcdWriteLine2

l0WaitForKeypress:
      JSR         WaitForKeypadPress         
      STAA        RETURNED_KEY               
      
      CMPA        #12                        
      LBEQ        MAINLOOP                  
      BRA         l0WaitForKeypress      
      JMP         MAINLOOP
   
;******************************************************************************
;* Run Lab 1 Code
StartLab1:                                ;Run EE337 LAB 1
      
      LDX         #EMPTY     
      JSR         LcdWriteLine2
      LDX         #MENULAB1               ;Menu 1 Click Event     
      JSR         LcdWriteLine1 
      JSR         Delay1s

    
      JSR         TurnLedsOn
      JSR         MapButtons2Leds         ;Map Push Buttons to LEDs
      STAA        CURRENT_LED
      JSR         SetLedsWithRegisterA
      
      ;MOVB        CURRENT_LED     ,LEDS  ;Load current led to leds
      JSR         Delay100ms              ;wait a tick!

      BRA         StartLab1               ;Restart lab 1
  RTS

;******************************************************************************
;* Run Lab 2 Code
StartLab2:                                ;Run EE337 LAB 2
      LDX         #EMPTY     
      JSR         LcdWriteLine2
      LDX         #l2intro1               ;Menu 2 Click Event     
      JSR         LcdWriteLine1
      JSR         TurnLedsOn
      
ClearCount:      
      LDAA        #$00
      LDAB        #$00

CounterLoop:

      LDAA        PTIH                    ;read pushbuttons 
      COMA     
      ANDA        #BUTTON1                ;AND with button 1
      CMPA        #BUTTON1                ;compare to button1
      BNE         NoCount
      JSR         Delay20ms               ;wait 10 ms
      LDAA        PTIH                    ;read pushbuttons again     
      COMA
      ANDA        #BUTTON1      
      CMPA        #BUTTON1
      BNE         NoCount                 ;Bad bounce
      ;now count
      ADDB        #1         
      JSR         SetLedsWithRegisterB    ;good press
      BRA         WaitUntilButtonIsClear
          
NoCount:      
      LDAA        PTIH                    ;read pushbuttons
      COMA
      ANDA        #BUTTON0      
      CMPA        #BUTTON0
      BNE         CounterLoop             ;restart
      JSR         Delay20ms               ;wait 10 ms
      LDAA        PTIH                    ;read pushbuttons again     
      COMA
      ANDA        #BUTTON0      
      CMPA        #BUTTON0
      BNE         CounterLoop             ;Bad bounce
      ;Clear
      
      LDAB        #$00
      JSR         SetLedsWithRegisterB    
      BRA         WaitUntilClearButtonClear
  
WaitUntilButtonIsClear:
      LDAA        PTIH                    ;read pushbuttons 
      COMA
      ANDA        #BUTTON1                ;AND with button 1
      CMPA        #BUTTON1                ;compare to button1
      BNE         CounterLoop
      BRA         WaitUntilButtonIsClear
WaitUntilClearButtonClear:      
      LDAA        PTIH                    ;read pushbuttons 
      ANDA        #BUTTON0                ;AND with button 0
      CMPA        #BUTTON0                ;compare to button0
      BGT         WaitUntilClearButtonClear
      BRA         CounterLoop
      
  RTS

;******************************************************************************
;* Run Lab 3 Code
StartLab3:        

      JMP         MAINLOOP


;******************************************************************************
;*  SUB ROUTINE - BUTTON PRESS TO LEDs lights.
MapButtons2Leds: 
      PSHB
      PSHA
      LDAB        #$0F                    ;Reset LED Tracker by clearing B Reg
     
CaseButton0:                              ;Start Button 0
      LDAA        PTIH                    ;read switches on port H into A
      ANDA        #BUTTON0                ;Compare what's in A to Button 0
      CMPA        #BUTTON0
      BNE         CaseButton1             ;Go to next button if 0
      SUBB        #$0A                    ;Subtract LED value from B

CaseButton1:      
      LDAA        PTIH                    ;read switches on port H into A
      ANDA        #BUTTON1                ;Compare what's in A to Button 1
      CMPA        #BUTTON1
      BNE         CaseButton2             ;Go to next button if 0
      SUBB        #$1B
            
CaseButton2:      
      LDAA        PTIH                    ;read switches on port H into A
      ANDA        #BUTTON2                ;Compare what's in A to Button 2
      CMPA        #BUTTON2
      BNE         CaseButton3             ;Go to next button if 0
      SUBB        #$2C
            
CaseButton3:      
      LDAA        PTIH                    ;read switches on port H into A
      ANDA        #BUTTON3                ;Compare what's in A to Button 3
      CMPA        #BUTTON3
      BNE         CaseButtonFinally       ;Go to end if 0
      SUBB        #$3D

CaseButtonFinally:
      STAB        CURRENT_LED             ;Store B into CURRENT_LED
      PULA
      PULB
   RTS                                    ;Return to Sender




;******************************************************************************
;* Push Button Event Handlers - should move to pb controller
;*  [DESCRIPTION]
;*    Functions define how each push button should react
;*
;*  [ARGUMENTS]
;*    - NONE
;*
;*  [RETURNS]
;*    - NONE
;*
;****************************************************************************** 
Pushed1:
Pushed2:
Pushed3:

PushedA:
ASelected:        FCC  "A: Bad Selection"
      LDX         #ASelected
      JSR         LcdWriteLine1      
      LDX         #EMPTY   
      JSR         LcdWriteLine2   
      BRA         CommonPBExit
Pushed4:
Pushed5:
Pushed6:
PushedB:

Pushed7:
Pushed8:
Pushed9:
PushedC:

PushedAst:
Pushed0:
PushedHash:
PushedD:

CommonPBExit:                          ;Common push button exit
      JSR         Delay1s
      JSR         Delay1s
      JSR         Delay1s
      JMP         MAINLOOP             ;Return to Menu select 

;******************************************************************************
;* CPU LOOP
GRACEFULLY_END:
      NOP      
      BRA         GRACEFULLY_END ;Make sure we don't run into any other memory
   END




;******************************************************************************
;* Template SubRoutine
;*  [DESCRIPTION]
;*
;*
;*  [ARGUMENTS]
;*    - NONE
;*
;*  [RETURNS]
;*    - NONE
;*
;****************************************************************************** 

;******************************************************************************
;    ___              _   _                                                   *
;   / _ \ _  _ ___ __| |_(_)___ _ _  ___                                      *
;  | (_) | || / -_|_-<  _| / _ \ ' \(_-<                                      *
;   \__\_\\_,_\___/__/\__|_\___/_||_/__/                                      *
;******************************************************************************
;* QUESTIONS TO BE ANSWERED IN COMMENTS AT THE END OF YOUR CODE               *
;* 1) Why is debouncing important
;     To ensure you program functions as expected, debouncing is required
;     for some operations, otherwise false-positive results can occur 
;* 2) How can I debounce in hardware?
;     Create a feedback loop to ensure the value is sustained.  An SR latch
;     is an example.
;  3) What other electro-mechanical device might bebounce:
;     the dip switches would probably need debouncing
;     relays
;     usb ports probably require some "debouncing"
;  4) List the number of cycles for each of the opcodes used in your delay 
;     function then sum the total time of the delay in clock cycles;
;     The main delay function is:
;     Delay250ns:		DEX			         ;1 cycle
;		   INX			                     ;1 cycle
;        DEX			                     ;1 cycle
;		   BNE	   Delay250ns		         ;3 cycles
;        RTS 
;     6 cycles total
;     Function delays by 250 ns based on a 24MHz Clock Frequency     
;     1s/(24,000,000/6) = 250ns
;     The length of the delay is dependent on the value stored in X


;******************************************************************************
;*   ___      __                                                              *
;*  | _ \___ / _|___ _ _ ___ _ _  __ ___ ___                                  *
;*  |   / -_)  _/ -_) '_/ -_) ' \/ _/ -_|_-<                                  *
;*  |_|_\___|_| \___|_| \___|_||_\__\___/__/                                  *
;******************************************************************************




