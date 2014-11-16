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
; Description: My program was getting messy so I moved my declarations to my  *
; own inlcude file...
;******************************************************************************
;* GLOBAL DATA CONDITIONING
;******************************************************************************
;-----------------------------variable/data section----------------------------
;* CLOCK REGISTERS AND VALUES
LOCK                EQU     %00001000     ;LOCK bit in CRGFLG 
                                          ;(1=PLL locked to frequency)



;* SWITCHES IO PORTS AND DDRJ
PUSHBUTTON:         EQU     PTH
DIP_DIR:            EQU     DDRH          ;SET DIP DDR      DIRECTION
PB_DIR:             EQU     DDRH          ;SET PUSH BUTTON  DIRECTION 
BUTTON3:            EQU     $08           ; %00001000   
BUTTON2:            EQU     $04           ; %00000100
BUTTON1:            EQU     $02           ; %00000010
BUTTON0:            EQU     $01           ; %00000001

;* TOUCH SWITCH (for my Dragon12 Plus 2 Board)
TOUCH_SW            EQU     PTT           ;Port T IO
TOUCH_SW_DIR        EQU     DDRT          ;DATA DIRECTION (IN 0 / OUT 1)


;* USEFUL VALUES:
OUTPUT:             EQU     $FF
INPUT:              EQU     $00
ON:                 EQU     $FF
OFF:                EQU     $00









