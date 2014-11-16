;******************************************************************************
;*                                                                            *
;*                  .---------------------------------.                       *           
;*                  |  .---------------------------.  |                       *      
;*                  |[]|                           |[]|                       *      
;*                  |  | Name: Peter M. Corcoran   |  |                       *      
;*                  |  | BlazerID: PMCORCOR        |  |                       *      
;*                  |  | Program: Common Cntrl Sys |  |                       *      
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
;* Description: Common Control System                                         *
;*                                                                            *
;* 
;* CRG = Clock and Reset Generation Block - Generates clock signals
;* 
;* PLL = Phased Locked Loop - Circuit technique that can accept a low freq
;*                            signal and produce a high-frequency clock output
;* 
;* CLKSEL = Clock Select
;* 
;* SYNR   = Synthesizer       = 5, PLL multiplier will be 6
;* REFDV  = Reference Divider = 1, PLL divisor will be 2
;* OSCCLK = Oscillator Clock
;* 
;* 
;******************************************************************************

      ;Define Public Methods
      XDEF        SetClockTo48MHz  

SYNTHESIZER:               EQU   $00000034
REFERENCEDIVIDER:          EQU   $00000035 
CLOCK_N_RESET_FLAG:        EQU   $00000037 
CLOCKSELECT:               EQU   $00000039
PLLCONTROL:                EQU   $0000003A 



;******************************************************************************
COMMON_CONTROLLER_CODE:    SECTION



;******************************************************************************
;* SetClockTo48MHz
;*  [DESCRIPTION]
;*  The crystal frequency on the Dragon12-Plus-USB board is 8 MHz so the 
;*  default bus speed is 4 MHz. In order to set the bus speed high than 4 MHz 
;*  the PLL must be initialized.
;*
;*  The math used to set the PLL frequency is:
;*  PLLCLK = CrystalFreq * 2 * (initSYNR+1) / (initREFDV+1)
;*  CrystalFreq                = 8 MHz on Dragon12 plus board
;*  BUS SPEED                  = PLLCLK / 2 = 24 MHz
;*
;*  [ARGUMENTS]
;*    - NONE
;*
;*  [RETURNS]
;*    - NONE
;*
;******************************************************************************
SetClockTo48MHz:
      SEI      ;Sets the I mask bit. interupt..
               ; This instruction is assembled as ORCC #$10. 
               ; The ORCC instruction can be used to set any combination of bits 
               ; in the CCR in one operation. When the I bit is set, all maskable
               ; interrupts are inhibited, and the CPU will recognize only 
               ; non-maskable interrupt sources or an SWI.                   
      LDX         #0
      BCLR     CLOCKSELECT   ,x    ,%10000000   ;Clear bit7-clock derived from oscclk
      BSET     PLLCONTROL    ,x    ,%01000000   ;Turn PLL on, bit6=1 PLL on
                                                ; bit 6=0 PLL off
      LDAA     #$05                             ; 5+1=6 Multiplier
      STAA     SYNTHESIZER   ,x
      LDAA     #$01                             ;Divisor=1+1=2, 
                                                ; 8*2*6 /2 = 48MHz PLL freq, 
                                                ; for 8 MHz crystal
      STAA     REFERENCEDIVIDER     ,x                       

WAIT: BRCLR    CLOCK_N_RESET_FLAG   ,x    ,%00001000     ,WAIT
      BSET     CLOCKSELECT          ,x    ,%10000000
      
            
   RTS      
      

END
  
;******************************************************************************
;*   ___      __                                                              *
;*  | _ \___ / _|___ _ _ ___ _ _  __ ___ ___                                  *
;*  |   / -_)  _/ -_) '_/ -_) ' \/ _/ -_|_-<                                  *
;*  |_|_\___|_| \___|_| \___|_||_\__\___/__/                                  *
;******************************************************************************
