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
; Description: Variable setup for the Dragon 12 Plus 2
;******************************************************************************
;* GLOBAL DATA CONDITIONING
;******************************************************************************
;-----------------------------variable/data section----------------------------


;* LED & 7 SEGMENT LED Display

LED7Dec:            EQU     $80           ;7SEG LED at bit 7
LED6G:              EQU     $40           ;7SEG LED at bit 6
LED5E:              EQU     $20           ;7SEG LED at bit 5
LED4E:              EQU     $10           ;7SEG LED at bit 4
LED3D:              EQU     $08           ;7SEG LED at bit 3
LED2C:              EQU     $04           ;7SEG LED at bit 2
LED1B:              EQU     $02           ;7SEG LED at bit 1
LED0A:              EQU     $01           ;7SEG LED at bit 0

ZERO:               EQU     $3F           ;7SEG Zero
ONE:                EQU     $06           ;7SEG One
TWO:                EQU     $5B           ;7SEG Two
THREE:              EQU     $4F           ;7SEG Three or sideways W  
FOUR:               EQU     $66           ;7SEG Four
FIVE:               EQU     $6D           ;7SEG Five
SIX:                EQU     $7D           ;7SEG Six
SEVEN:              EQU     $07           ;7SEG Seven
EIGHT:              EQU     $7F           ;7SEG Eight
NINE:               EQU     $6F           ;7SEG Nine
LETA:               EQU     $77           ;7SEG Letter A (HEX 10)
LETB:               EQU     $5D           ;7SEG Letter B (HEX 11)
LETC:               EQU     $39           ;7SEG Letter C
LETD:               EQU     $7C           ;7SEG Letter D
LETE:               EQU     $79           ;7SEG Letter E
LETF:               EQU     $71           ;7SEG Letter F
LETH:               EQU     $76           ;GFE 0CB0 -> 76
LETL:               EQU     $38           ;0FE D000 ->
LETP:               EQU     $73           ;7SEG Letter P
LETt:               EQU     $78           ;7SEG Letter t
LETn:               EQU     $54           ;7SEG Letter n  G0E 0C00 
LETY:               EQU     $6E           ;GF0 DCB0

;******************************************************************************
;* LED and 7 SEGMENT IO PORTS AND DDRJ
LEDS:               EQU     $00000001     ;LED/7 Segment display Port IO
LEDS_DIR:           EQU     $00000003     ;LED/7 Segment display in/out dir
                                          ; 0 = IN
                                          ; 1 = OUT
LEDS_SW_DIR:        EQU     $0000026A     ;LED in/out dir 
                                          ; 0 = IN
                                          ; 1 = OUT
LEDS_SW             EQU     $00000268     ;LED/7 Segment Switch
                                          ; PTJ BIT 1 = LOW  LED ENABLED
                                          ; PTJ BIT 1 = HIGH LED DISABLED

;******************************************************************************
;* LED SWITCH CONFIGURATIONS 

ENABLE_LEDS         EQU     $01
DISABLE_LEDS        EQU     $00


;* SEVEN SEGMENT DISPLAYS IO PORTS AND DDRJ
SEG7_DIGITS:        EQU     $00000258     ;Connected to CATHODES OF 7-SEG 
                                          ;(DIG0-DIG3) Port P I/O Register
SEG7_DIGITS_DIR:    EQU     $0000025A     ;PP0 THRU PP3 ENABLE/DISABLE EACH 
                                          ;DIGIT OF 7SEG DISPALY DDRP
SEG7_DISP1          EQU     $0E           ;7 segment display 1
SEG7_DISP2          EQU     $0D           ;7 segment display 2
SEG7_DISP3          EQU     $0B           ;7 segment display 3
SEG7_DISP4          EQU     $07           ;7 segment display 4
SEG7_DISP_OFF       EQU     $0F 
          








