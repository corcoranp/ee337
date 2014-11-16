;******************************************************************************
;*                                                                            *
;*                  .---------------------------------.                       *           
;*                  |  .---------------------------.  |                       *      
;*                  |[]|                           |[]|                       *      
;*                  |  | Name: Peter M. Corcoran   |  |                       *      
;*                  |  | BlazerID: PMCORCOR        |  |                       *      
;*                  |  | Program: Buzzer Cntrl Sys |  |                       *      
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
;* Description: Buzzer Control System                                         *
;* REFERENCED:                                                                *

;*                                                                            *
;******************************************************************************

      ;Define Public Methods
      XDEF        BuzzerInitialization, BuzzerOn

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
      
BUZZER:           EQU   $00000240            ;PTT
BUZZER_DIR:       EQU   $00000242            ;DDRT
BUZZER_ENABLE     EQU   %00100000
      
      
;******************************************************************************
;* LCD Controller Code Section                                                *
;*                                                                            *
BUZZER_CONTROLLER_CODE:    SECTION
      
      
;******************************************************************************
;* Keypad Initialization function                                             *      
BuzzerInitialization:
      ;Only need to run once
      BSET        BUZZER_DIR     ,%00100000     ;PTT5 as Output pin for buzzer
   RTS         

;******************************************************************************
;* Buzzer On                                                                  * 
BuzzerOn:
      BSET        BUZZER         ,BUZZER_ENABLE
      JSR         Delay100ms
      BCLR        BUZZER         ,BUZZER_ENABLE
      JSR         Delay50us
      DBNE        x, BuzzerOnExit
      BRA         BuzzerOn
BuzzerOnExit:
      BCLR        BUZZER         ,BUZZER_ENABLE      
   RTS      

END
  
;******************************************************************************
;*   ___      __                                                              *
;*  | _ \___ / _|___ _ _ ___ _ _  __ ___ ___                                  *
;*  |   / -_)  _/ -_) '_/ -_) ' \/ _/ -_|_-<                                  *
;*  |_|_\___|_| \___|_| \___|_||_\__\___/__/                                  *
;******************************************************************************
