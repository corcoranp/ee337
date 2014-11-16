;******************************************************************************
;*                                                                            *
;*                  .---------------------------------.                       *           
;*                  |  .---------------------------.  |                       *      
;*                  |[]|                           |[]|                       *      
;*                  |  | Name: Peter M. Corcoran   |  |                       *      
;*                  |  | BlazerID: PMCORCOR        |  |                       *      
;*                  |  | Program: Lab 1            |  |                       *      
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
; Description:                                                                *
;                                                                             *
;******************************************************************************
;*    ___           _         _                                               *
;*   | _ \_ _ ___  | |   __ _| |__                                            *
;*   |  _/ '_/ -_) | |__/ _` | '_ \                                           *
;*   |_| |_| \___| |____\__,_|_.__/                                           *
;*                                                                            *
;******************************************************************************
;PRE-LAB 1 Work:
; 1. Explain how PTIH relates to SW2-SW5
;    Each pin in Port H reads a switch
;
;     PTIH - Port Input Register
;     PH0 (input) Pin 52 DIP switch 1 or pushbutton switch SW5 
;     PH1 (input) Pin 51 DIP switch 2 or pushbutton switch SW4 (input) 
;     PH2 (input) Pin 50 DIP switch 3 or pushbutton switch SW3 (input) 
;     PH3 (input) Pin 49 DIP switch 4 or pushbutton switch SW2 (input) 
;   
;     PUSH BUTTON: RELEASED=1; PRESSED=0
;
;
; 2. Explain what PORTB relates to
;    Port B drives the LEDs


;******************************************************************************
;*    __   __        _      _    _       ___       __                         *
;*    \ \ / /_ _ _ _(_)__ _| |__| |___  |   \ ___ / _|___                     *
;*     \ V / _` | '_| / _` | '_ \ / -_) | |) / -_)  _(_-<                     *
;*      \_/\__,_|_| |_\__,_|_.__/_\___| |___/\___|_| /__                      *
;*                                                                            *
;******************************************************************************
;* XDEF: make a symbol public (visible to some other file)                    *
;*                                                                            *  
    XDEF    Entry, MAIN                                                   
    XREF    __SEG_END_SSTACK                                              
    INCLUDE 'mc9s12dg256.inc'                                              
                                                                          
;******************************************************************************
;*                 GLOBAL DATA CONDITIONING

;* LED & 7 SEGMENT LED Display
LEDs:               EQU     PORTB
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
LETP:               EQU     $73           ;7SEG Letter P
LETt:               EQU     $78           ;7SEG Letter t

;* LED IO PORTS AND DDRJ
LED_DIR:            EQU     DDRB          ;SET LED DDR      DIRECTION 
                                            ;(IN 0 / OUT 1)   DDRB
LED_SW_DIR:         EQU     DDRJ          ;SET LED SWITCH   DIRECTION 
LED_SW:             EQU     PTJ           ;LED ON/OFF SWITCH -> SET BIT 1 
                                            ;LOW to ENABLE


;* SEVEN SEGMENT DISPLAY IO PORTS AND DDRJ
SEG7_DIR:           EQU     DDRB          ;SET 7SEG DDR DIRECTION     DDRB
SEG7_SW_DIR:        EQU     DDRJ          ;SET 7SEG SW  DIRECTION     DDRJ
SEG7_SW             EQU     PTJ           ;7 SEGMENT DISPLAY -> SET BIT 0 
                                            ;HIGH to ENABLE
SEG7_DIGITS:        EQU     PTP           ;Connected to CATHODES OF 7-SEG 
                                            ;(DIG0-DIG3) Port P I/O Register
SEG7_DIGITS_DIR:    EQU     DDRP          ;PP0 THRU PP3 ENABLE/DISABLE EACH 
                                            ;DIGIT OF 7SEG DISPALY DDRP
SEG7_DISP1          EQU    $0E            ;7 segment display 1
SEG7_DISP2          EQU    $0D            ;7 segment display 2
SEG7_DISP3          EQU    $0B            ;7 segment display 3
SEG7_DISP4          EQU    $07            ;7 segment display 4

;* 7 SEGEMENT/LED CONFIGURATIONS 
; $01 to enable both LED and 7SEG
; $03 to enable only 7SEG
; $00 to enable only LED
; $02 to disable both
ENABLE_LED_SEG7     EQU     $01
ENABLE_SEG7         EQU     $03
ENABLE_LEDS         EQU     $00
DISABLE_LED_SEG7    EQU     $02

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

;* LCD DISPLAY
LCD_DATA:           EQU     PORTK
LCD_DIR:            EQU     DDRK          ;DIRECTION (IN 0 / OUT 1)
LCD_RS:             EQU     mPORTK_BIT0   ;LCD REGISTER SELECT SIGNAL Pin 8
LCD_EN:             EQU     mPORTK_BIT1   ;LCD E SIGNAL Pin 7
LCD_CMD:            EQU     0             ;LCD Command Type for put2lcd

;* USEFUL VALUES:
OUTPUT:             EQU     $FF
INPUT:              EQU     $00
ON:                 EQU     $FF
OFF:                EQU     $00


;* USE $1000-$2FFF for Scratch memory
DATA:               EQU     $1000      
R1                  EQU     $1001
R2                  EQU     $1002
R3                  EQU     $1003

             

;******************************************************************************
;*  LOCAL DATA CONDITIONING

                    ORG     $1100         ;Starting Memory location
CURRENT_LED:        DS.B  1               ;Track current led
STACK:              EQU     $2000         ;STACK starting address
     
;******************************************************************************
;*   __  __      _        ___                                                 *
;*  |  \/  |__ _(_)_ _   | _ \_ _ ___  __ _ _ _ __ _ _ __                     *
;*  | |\/| / _` | | ' \  |  _/ '_/ _ \/ _` | '_/ _` | '  \                    *
;*  |_|  |_\__,_|_|_||_| |_| |_| \___/\__, |_| \__,_|_|_|_|                   *
;*                                    |___/                                   *
;******************************************************************************                        

MYCODE:             SECTION
MAIN:
Entry:
    
;******************************************************************************
;*  Initialization
    LDS     #__SEG_END_SSTACK               ;Stack Starting Addy
    LDAA    #OFF
    LDAB    #OFF
    LDX     #OFF 
    LDY     #OFF
       
    ;*** LEDs DATA DIRECTION (AND 7 SEGMENT DISPLAY)
    MOVB    #OUTPUT           ,LED_DIR      ;Make Port B an output port - SET 
                                              ;to 1  (Move Byte) M1 -> M2
    MOVB    #$02              ,LED_SW_DIR   ;CONFIG PJ1 PIN FOR OUTPUT TO LEDs
    MOVB    #ENABLE_LED_SEG7  ,LED_SW       ;ENABLE BOTH LEDs and 7SEG DISPLAY 

    ;*** 7 SEGMENT DATA DIRECTION
    MOVB    #$0F          ,SEG7_DIGITS_DIR  ;ENABLE 7 SEGMENT DIGITS for OUTPUT
    MOVB    #$07          ,SEG7_DIGITS      ;ENABLE Only the first display
    
    ;*** PUSH BUTTONS
    MOVB    #INPUT        ,PB_DIR           ;Make Port H an input port 
                                              ;(Config push buttons for input)

    
;******************************************************************************
;*  MAIN LOOP
MAINLOOP:                                   ;LOOP FOREVER
    
    MOVB    #ENABLE_SEG7      ,SEG7_SW      ;
    
    MOVB    #LETP             ,LEDs         ;
    MOVB    #SEG7_DISP1       ,SEG7_DIGITS  ;ENABLE display 1
 JSR        DELAY    
    MOVB    #LETE             ,LEDs         ;
    MOVB    #SEG7_DISP2       ,SEG7_DIGITS  ;ENABLE display 2
 JSR        DELAY
    MOVB    #LETt             ,LEDs         ;
    MOVB    #SEG7_DISP3       ,SEG7_DIGITS  ;ENABLE display 3
 JSR        DELAY        
    MOVB    #LETE             ,LEDs         ;
    MOVB    #SEG7_DISP4       ,SEG7_DIGITS  ;ENABLE display 4
 JSR        DELAY                           ;Wait 1ms
    
    MOVB    ENABLE_LEDS       ,LED_SW       ;
    BSR     GET_ENABLED_LEDs                ;Sub-Routine GET_BUTTON
    ;LDAA    CURRENT_LED                    ;Load Register A with CURRENT_LED
    ;STAA    LEDs                           ;TURN ON LEDs (Port B) if pressed
    MOVB    CURRENT_LED       ,LEDs
    JSR     DELAY        

    BRA     MAINLOOP                        ;Go Back to Main

;******************************************************************************
;*  SUB ROUTINE - GET ENABLED LEDs
GET_ENABLED_LEDs: 
    PSHB
    PSHA
    LDAB    #$0F                  ;Reset LED Tracker by clearing B Register
     
CASE_BUTTON0:                     ;Start Button 0
    LDAA    PTIH                  ;read switches on port H into A
    ANDA    #BUTTON0              ;Compare what's in A to Button 0
    CMPA    #BUTTON0
    BNE     CASE_BUTTON1          ;Go to next button if 0
    SUBB    #LED0A                ;Subtract LED value from B

CASE_BUTTON1:      
    LDAA    PTIH                  ;read switches on port H into A
    ANDA    #BUTTON1              ;Compare what's in A to Button 1
    CMPA    #BUTTON1
    BNE     CASE_BUTTON2          ;Go to next button if 0
    SUBB    #LED1B
            
CASE_BUTTON2:      
    LDAA    PTIH                  ;read switches on port H into A
    ANDA    #BUTTON2              ;Compare what's in A to Button 2
    CMPA    #BUTTON2
    BNE     CASE_BUTTON3          ;Go to next button if 0
    SUBB    #LED2C
            
CASE_BUTTON3:      
    LDAA    PTIH                  ;read switches on port H into A
    ANDA    #BUTTON3              ;Compare what's in A to Button 3
    CMPA    #BUTTON3
    BNE     SW_BUTTON_FINALLY     ;Go to end if 0
    SUBB    #LED3D

SW_BUTTON_FINALLY:
    STAB    CURRENT_LED           ;Store B into CURRENT_LED
    PULA
    PULB
  RTS                             ;Return to Sender




;******************************************************************************
;*  SUB ROUTINE - DELAY 
;*  1ms delay: 
;*  "The serial monitor works at a speed of 48MHz with XTAL=8MHz
;*  on the Dragon12+ board.
;*  Frequency fro Instruction Clock Cycle is 24MHz (1/2 of 48 MHz).
;*  (1/24MHz) x 10 Clk x 240 x 10 = 1ms
;*  Overheads are excluded in this calculation."
;*  

DELAY
        PSHA		                  ;Save Reg A on Stack
        LDAA    #1		  
        STAA    R3		       
L3      LDAA    #10
        STAA    R2
L2      LDAA    #240
        STAA    R1
L1      NOP                           ;1 Intruction Clk Cycle
        NOP                           ;1
        NOP                           ;1
        DEC     R1                    ;4
        BNE     L1                    ;3
        DEC     R2                    ;Total Instr.Clk=10
        BNE     L2
        DEC     R3
        BNE     L3
;--------------        
        PULA			              ;Restore Reg A
        RTS

;******************************************************************************
;*                       CPU LOOP
GRACEFULLY_END:
    NOP      
    BRA     GRACEFULLY_END        ;Make sure we don't run into any other memory
END



;******************************************************************************
;    ___              _   _                                                   *
;   / _ \ _  _ ___ __| |_(_)___ _ _  ___                                      *
;  | (_) | || / -_|_-<  _| / _ \ ' \(_-<                                      *
;   \__\_\\_,_\___/__/\__|_\___/_||_/__/                                      *
;******************************************************************************
;* QUESTIONS TO BE ANSWERED IN COMMENTS AT THE END OF YOUR CODE               *
;* 1) Explain how the binary and hexadecimal number systems were              *
;     used or could be used to aid in this assignment.                        *
;*    - binary or hex numbers are used to turn ports into in|out put          *
;* 2) Explain how the binary and hexadecimal number systems can               *
;     be used to modify the input and output values for this assignment.      *  
;     - Binary or Hex values can be added or substracted to produce the desire*
;       ed bit combination                                                    ß*
;******************************************************************************


;******************************************************************************
;*   ___      __                                                              *
;*  | _ \___ / _|___ _ _ ___ _ _  __ ___ ___                                  *
;*  |   / -_)  _/ -_) '_/ -_) ' \/ _/ -_|_-<                                  *
;*  |_|_\___|_| \___|_| \___|_||_\__\___/__/                                  *
;******************************************************************************
; 
; $00   8-bit HEX Address Specific Memory location
; #$00  8-bit HEX Value   Direct Mode
; @00   Octal Number
; 0     Decimal Number
; %01   Binary Number
;
; BCLR  Clear bits in memory
; BSET  Set bits in memory (M) + (mm) => M
; 
; We want the following connections between switches and LEDs 
; SW2 -> PB3
; SW3 -> PB2
; SW4 -> PB1
; SW5 -> PB0


; Data Direction Registers
; NAME:     Address:    Description:

; PORT B - LED DISPLAYS
; PORTB     $0001       PORT B (PB) - LED 
; DDRB      $0003       PORT B Data Direction Register - LEDs, 7-Seg display
; pattern

; PORT H - BUTTON/SWITCH
; PTH       $0260       Port H I/O Register
; PTIH      $0261       Port H Input Register
; DDRH      $0262       Port H Data Direction Register

; PORT J -  Port J is a two-bit port that can be used for I/O or to generate 
    ;interrupts
; PTJ1      $0269       PIN 21 (PORT J PIN 1) - LED ENABLE 
; DDRJ      $026A       PORT J Data Direction Register - LED Control
     
; PORT P - Port P 7-Segment display
; PORTP                 
; DDRP 


; WRITE 1 to the associated bit in the DDR for OUTPUT
; WRITE 0 to the associated bit in the DDR for INPUT

; REFERENCE SOURCES:
;http://paws.kettering.edu/~jkwon/teaching/10-t1/ce-320/lecture/
;http://www.microdigitaled.com/HCS12/Hardware/Dragon12/CodeWarrior_asm/CW_LCD_AssemProg.txt
;******************************************************************************



