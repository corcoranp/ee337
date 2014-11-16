;******************************************************************************
;*                                                                            *
;*                  .---------------------------------.                       *           
;*                  |  .---------------------------.  |                       *      
;*                  |[]|                           |[]|                       *      
;*                  |  | Name: Peter M. Corcoran   |  |                       *      
;*                  |  | BlazerID: PMCORCOR        |  |                       *      
;*                  |  | Program: Common Delays    |  |                       *      
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
;* Description: Common Time Delays                                            *
;*                                                                            *
;*  At 24MHz                                                                  *
;*  5 cycles per loop                                                         *
;*  24 million / 5 = 4,800,000                                                *
;*  1sec/4,800,000                                                            *
;*                                                                            *
;* setup/shutdown: 8 cycles                                                   *
;******************************************************************************
;-----------------------------Include Libraries--------------------------------

      ;Define functions available for external usage
      XDEF        Delay1s
      XDEF        Delay500ms
      XDEF        Delay100ms
      XDEF        Delay20ms
      XDEF        Delay10ms
      XDEF        Delay5ms
      XDEF        Delay1ms
      XDEF        Delay500us
      XDEF        Delay100us
      XDEF        Delay50us      
      XDEF        Delay10us


;******************************************************************************
;-----------------------------variable/data section----------------------------
TEN_MS:	   	   EQU	40000
FIVE_MS:	         EQU	20000
ONE_MS:		      EQU	4000	         ;4000 x 250ns = 1 ms at 24 MHz bus speed
FIVEHUNDRED_US:	EQU	2000
ONEHUNDRED_US:	   EQU	400
FIFTY_US:	      EQU	200


;******************************************************************************
;-----------------------------code section-------------------------------------
DELAY_CODE_SECTION:     SECTION

Delay1s:                               ;1 second delay	
		PSHY
		LDY      #100
dlay1s:  		
  		BSR   	Delay10ms
  	   DEY
  	   BNE      dlay1s
      PULY
   RTS                                 ;Return

Delay500ms:  	
		PSHY
		LDY      #50
dlay500ms:  		
  		BSR   	Delay10ms
  	   DEY
  	   BNE      dlay500ms
      PULY
   RTS 
   
Delay100ms:  	
		PSHY
		LDY      #10
dlay100ms:  		
  		BSR   	Delay10ms
  	   DEY
  	   BNE      dlay100ms
      PULY
   RTS                                 ;Return
  
Delay20ms:  	PSHX
		LDX      #2
  		BSR   	Delay10ms
		PULX
   RTS                                 ;Return
    
Delay10ms:  	PSHX
		LDX      #TEN_MS
  		BSR	   Delay250ns
		PULX
   RTS                                 ;Return

Delay5ms:	   PSHX
		LDX      #FIVE_MS
  		BSR	   Delay250ns
		PULX
   RTS                                 ;Return

  
Delay1ms:  	   PSHX
		LDX      #ONE_MS
  		BSR	   Delay250ns
		PULX
   RTS                                 ;Return

Delay500us:	   PSHX
		LDX      #FIVEHUNDRED_US
  		BSR	   Delay250ns
		PULX
   RTS                                 ;Return

Delay100us:	   PSHX
		LDX      #ONEHUNDRED_US
  		BSR	   Delay250ns
		PULX
   RTS                                 ;Return

  
Delay50us:	   PSHX
		LDX      #FIFTY_US
  		BSR	   Delay250ns
		PULX
   RTS                                 ;Return
   
Delay10us:	   PSHX     
		LDX      #40
  		BSR	   Delay250ns
		PULX
   RTS                                 ;Return


;******************************************************************************
;* Delay250ns
;*  [DESCRIPTION]
;*    Function delays by 250 ns based on a 24MHz Clock Frequency. This is the 
;*    base function for which all the above functions are based.
;*
;*  [ARGUMENTS]
;*    - NONE
;*
;*  [RETURNS]
;*    - NONE
;*
;******************************************************************************  
Delay250ns:		DEX			            ;1 cycle
		INX			                     ;1 cycle
		DEX			                     ;1 cycle
		BNE	   Delay250ns		         ;3 cycles
   RTS 


END

