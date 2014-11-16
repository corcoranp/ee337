;******************************************************************************
;*                                                                            *
;*                  .---------------------------------.                       *           
;*                  |  .---------------------------.  |                       *      
;*                  |[]|                           |[]|                       *      
;*                  |  | Name: Peter M. Corcoran   |  |                       *      
;*                  |  | BlazerID: PMCORCOR        |  |                       *      
;*                  |  | Program: LCD Control Sys  |  |                       *      
;*                  |  | Version: 1.0              |  |                       *      
;*                  |  | Date: September 21, 2014  |  |                       *      
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
;* Description: LCD Control System                                            *
;*                                                                            *
;*  The LCD Control System is a set of functions needed to control the LCD    *
;*  On the Dragon 12 Plus 2                                                   *
;*                                                                            *
;******************************************************************************
;-----------------------------Include Libraries--------------------------------

;**** Define Public Methods
      XDEF        LedInitialization
      XDEF        Display7Segment
      XDEF        Display7SegmentOff    
      XDEF        TurnLedsOn
      XDEF        TurnLedsOff
      XDEF        SetLedsWithRegisterA
      XDEF        SetLedsWithRegisterB
      XDEF        DisplayNumberInD
           
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
      
      INCLUDE     'led_pmc.inc' 
      
      
;******************************************************************************
;* Description: LED Control System                                            *
;******************************************************************************
;-----------------------------variable/data section----------------------------


DISP1_VAL:        DS.B     1              ;Word value to display in 1
DISP2_VAL:        DS.B     1              ;Word value to display in 2
DISP3_VAL:        DS.B     1              ;Word value to display in 3
DISP4_VAL:        DS.B     1              ;Word value to display in 4     
DISP_TEMP:        DS.B     1              ;Temp variable for display use
INDEX             DS.B     1

;Number array: contains 7segment numbers in value placeholder
NUMARR:           DC.B     $3F,$06,$5B,$4F,$66,$6D,$7D,$07,$7F,$6F;





;******************************************************************************
;* LED Controller Code Section                                                *
;******************************************************************************
;-----------------------------code section-------------------------------------
LED_CONTROLLER_CODE:    SECTION
     
      
;******************************************************************************
;* LED Initialization function                                                *  
;******************************************************************************
;* LedInitialization                                                          *
;*  [DESCRIPTION]
;*    Sub-Routine initializes the LEDs on the DRAGON 12 Plus 2. This function
;*    sets the leds as outputs, and enables them.  It also initializes the 
;*    7segement display   
;*
;*  [ARGUMENTS]
;*    - NONE
;*
;*  [RETURNS]
;*    - NONE
;*                                                                            *
;******************************************************************************     
LedInitialization:
      ;*** LEDs DATA DIRECTION (AND 7 SEGMENT DISPLAY)
      MOVB        #$FF ,LEDS_DIR          ;Make Port B an output port
    
      ;*** LED Switch (Pin 1 low=enabled high=disable)
      MOVB        #$FF ,LEDS_SW_DIR       ;Make Port J an output port
    
      ;*** 7 SEGMENT DATA DIRECTION
      MOVB        #$FF ,SEG7_DIGITS_DIR   ;Make Port P an output port
      
      
   RTS


;******************************************************************************
;* SetLedsWithRegisterA                                                       *  
;******************************************************************************
;* SetLedsWithRegisterA                                                       *
;*  [DESCRIPTION]
;*    Turn Leds using Register A as pattern   
;*
;*  [ARGUMENTS]
;*    - REGISTER A should be set with pattern
;*
;*  [RETURNS]
;*    - NONE
;*                                                                            *
;****************************************************************************** 
SetLedsWithRegisterA:
      STAA        LEDS
      JSR         TurnLedsOn
   RTS
;******************************************************************************
;* SetLedsWithRegisterB                                                       *  
;******************************************************************************
;* SetLedsWithRegisterB                                                       *
;*  [DESCRIPTION]
;*    Turn Leds using Register B as pattern   
;*
;*  [ARGUMENTS]
;*    - REGISTER B should be set with pattern
;*
;*  [RETURNS]
;*    - NONE
;*                                                                            *
;****************************************************************************** 
SetLedsWithRegisterB:
      STAB        LEDS
      JSR         TurnLedsOn
   RTS

;******************************************************************************
;* Display7Segment                                                            *  
;******************************************************************************
;* LedInitialization                                                          *
;*  [DESCRIPTION]
;*    Method for displaying items on the 7-Segment Display
;*
;*  [ARGUMENTS]
;*    - NONE
;*
;*  [RETURNS]
;*    - NONE
;*                                                                            *
;******************************************************************************  
Display7Segment:
      MOVB        DISP1_VAL      ,LEDS          ;Show what's in display 1 value
      MOVB        #SEG7_DISP1    ,SEG7_DIGITS   ;ENABLE display 1
      JSR         Delay20ms    
      MOVB        DISP2_VAL      ,LEDS          ;Show what's in display 2 value
      MOVB        #SEG7_DISP2    ,SEG7_DIGITS   ;ENABLE display 2
      JSR         Delay20ms
      MOVB        DISP3_VAL      ,LEDS          ;Show what's in display 3 value
      MOVB        #SEG7_DISP3    ,SEG7_DIGITS   ;ENABLE display 3
      JSR         Delay20ms        
      MOVB        DISP4_VAL      ,LEDS          ;Show what's in display 4 value
      MOVB        #SEG7_DISP4    ,SEG7_DIGITS   ;ENABLE display 4
      JSR         Delay20ms                          ;Wait 1ms  
  
  RTS





DisplayNumberInD:
;      PSHX
;      LDY   NUMARR ;load with address of number array
;store x, y, d
;load x with 10
;divide d by x
;store remainder 
;convert BCD to 7seg 
;set disp4 with seg value
;      LDX   #$02
;      IDIV
;      STAB  INDEX
;      MOVB  INDEX,Y, SEG7_DISP3
      
;load x to d  
;load x with 10
;divide d by x
;store remainder (d) in disp3
;load x to d  
;load x with 10
;divide d by x
;store remainder (d) in disp2
;load x to d  
;load x with 10
;divide d by x
;store remainder (d) in disp1
;call Display7Segment....
;      JSR Display7Segment
;      PULX
;      RTS

;******************************************************************************
;* Display7SegmentOff                                                         *  
;******************************************************************************
;* LedInitialization                                                          *
;*  [DESCRIPTION]
;*    Method for disabling the 7-Segment Display
;*
;*  [ARGUMENTS]
;*    - NONE
;*
;*  [RETURNS]
;*    - NONE
;*                                                                            *
;****************************************************************************** 
Display7SegmentOff:
      MOVB        #SEG7_DISP_OFF ,SEG7_DIGITS   ;Turn off the displays
  RTS


;******************************************************************************
;* TURN LEDs ON|OFF                                                           *  
;******************************************************************************
;* LedInitialization                                                          *
;*  [DESCRIPTION]
;*    Funtions for turning on or off the Leds
;*
;*  [ARGUMENTS]
;*    - NONE
;*
;*  [RETURNS]
;*    - NONE
;*                                                                            *
;******************************************************************************
TurnLedsOn:
      BCLR        LEDS_SW        ,$02        ;TURN LEDS ON
   RTS

TurnLedsOff:
      BSET        LEDS_SW        ,$02        ;TURN LEDS OFF
   RTS


END
  
;******************************************************************************
;*   ___      __                                                              *
;*  | _ \___ / _|___ _ _ ___ _ _  __ ___ ___                                  *
;*  |   / -_)  _/ -_) '_/ -_) ' \/ _/ -_|_-<                                  *
;*  |_|_\___|_| \___|_| \___|_||_\__\___/__/                                  *
;******************************************************************************
;*                                                                            *
;******************************************************************************

