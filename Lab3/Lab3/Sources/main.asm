;******************************************************************************
;*                                                                            *
;*                  .---------------------------------.                       *           
;*                  |  .---------------------------.  |                       *      
;*                  |[]|                           |[]|                       *      
;*                  |  | Name: Peter M. Corcoran   |  |                       *      
;*                  |  | BlazerID: PMCORCOR        |  |                       *      
;*                  |  | Program: Lab 3            |  |                       *      
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
; Description: LAB 3                                                          *
; SEE CORCORAN.INC for included variable references                           *
;******************************************************************************
;*    ___           _         _                                               *
;*   | _ \_ _ ___  | |   __ _| |__                                            *
;*   |  _/ '_/ -_) | |__/ _` | '_ \                                           *
;*   |_| |_| \___| |____\__,_|_.__/                                           *
;*                                                                            *
;******************************************************************************
; 1.  What is the difference between ‘polling’ and interrupts? 
;     Polling is looping through a set of code to determine if a change occurs
;     Interrupts are 'fired'  when an event occurs

;  2. Describe the purpose of each of the following things: 
;     PPSH, 
;     PIEH, 
;     PIFH, 
;     SEI, 
;     CLI, 
;     RTI. 



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
COUNT             DS.B     1
ACTION_DIR        DS.B     1


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
      ;JSR         SetClockTo48MHz         ;Set Clock Speed
     
      
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
      
      BSR         InitPorts
      BSR         ClearCount
      
;******************************************************************************
;*  MAIN LOOP
MAINLOOP:                                 ;LOOP FOREVER
      ;JSR         EventHandler
      BRA         MAINLOOP
            
InitPorts:
      SEI                                 ;Disable Interrupts
      
      ;Data direction h
      MOVB        DDRH, $F0
      MOVB        PPSH, $F0
      
      ;LDAA        PPSH                    ;Port Polarity Select Reg
      ;ANDA        #$F0
      ;STAA        PPSH                    ;Set polarity
      
      LDAA        PIEH                    ;Port Interrupt enable register
      ORAA        #$0F
      STAA        PIEH                    ;Enable interupt on bit 0
      
      LDAA        #$FF                    ;Port Interrupt Flag register
      STAA        PIFH
      
      CLR         COUNT
      MOVB        ACTION_DIR, $FF
      CLI                                 ;Enable Interrupts
      RTS      

      
Button1Push:
      ;ACTION
      ;CLR         COUNT                   ;Clear Count
      ;MOVB        COUNT, PORTB            ;Sent to LEDS
      
      BSET        PIFH, #$FF
      RTI
      
Button2Push:
      ;INCREASE ACTION
      INC         COUNT                   ;Count up
      MOVB        COUNT, PORTB
      ;MOVB        ACTION_DIR,$FF           ;set count to up
            
      BSET        PIFH, #$FF
      RTI
      
Button3Push:
      ;DECREASE ACTION
      DEC         COUNT
      MOVB        COUNT, PORTB            ;Count Down
      ;MOVB        ACTION_DIR,$00           ;Set Count to down
      
      BSET        PIFH, #$FF
      RTI

Button4Push:
      ;CLEAR ACTION
      CLR         COUNT                   ;Clear Count
      MOVB        COUNT, PORTB            ;Sent to LEDS
     
      
      BSET        PIFH, #$FF
      RTI

ClearCount:      
      LDAB        #$00
      RTS




;******************************************************************************
;*   ___      _        ___          _   _                                     *
;*  / __|_  _| |__ ___| _ \___ _  _| |_(_)_ _  ___ ___                        *
;*  \__ \ || | '_ \___|   / _ \ || |  _| | ' \/ -_|_-<                        *
;*  |___/\_,_|_.__/   |_|_\___/\_,_|\__|_|_||_\___/__/                        *
;*                                                                            *
;******************************************************************************
;******************************************************************************
;* Interrupt SubRoutine
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
IRQ_ISR:          
      LDAA        PIFH                    ;get state
     
      CMPA        #$01                    ;right most
      BEQ         Button1Push
      
      CMPA        #$02                    ;
      BEQ         Button2Push
      
      CMPA        #$04                    ;
      BEQ         Button3Push
      
      CMPA        #$08                    ;
      BEQ         Button4Push

      BSET        PIFH, #$FF
      RTI


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
      ORG         $FFCC                   ; port h interrupt vector
      DC.W        IRQ_ISR





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
;1) Why are interrupts important?
;2) What does the interrupt vector used for?
;3) Why are priorities important?
;4) What is an ISR?
;5) What is ‘Blocking’?
;6) Why do you not ‘block’ within an interrupt service routine?


;******************************************************************************
;*   ___      __                                                              *
;*  | _ \___ / _|___ _ _ ___ _ _  __ ___ ___                                  *
;*  |   / -_)  _/ -_) '_/ -_) ' \/ _/ -_|_-<                                  *
;*  |_|_\___|_| \___|_| \___|_||_\__\___/__/                                  *
;******************************************************************************




