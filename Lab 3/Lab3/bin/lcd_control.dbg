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

      ;Define Public Methods
      XDEF        LcdInitialization, LcdWriteLine1, SetLcdFxOff
      XDEF        SetLcdFxTextDelay, LcdWriteLine2
      XDEF        ClearDisplay         

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
      
   
;******************************************************************************
;* Description: LCD Control System                                            *
;******************************************************************************
;-----------------------------variable/data section----------------------------

LCD_OUT:          EQU      $00000032   ;Port K 
LCD_DIR:          EQU      $00000033   ;Port K DDR 



IS_DATA:          EQU      1           ;Register Select Bit 1 =1 is Data input
IS_INSTRUCTION:   EQU      $FE         ;Register Select Bit 1 =0 is instruction
IS_ENABLED:       EQU      2           ;Enable Signal bit 2 = 1
ISNT_ENABLED:     EQU      $FD         ;Enable Signal bit 2 = 0 is disabled

tempStorage       DS       1           ;temporary storage
CmdStorage        DS       1           ;keep track of what's been sent to lcd
FxMode:           EQU      0           ;Set FX Mode
                                       ;0 = No Fx
                                       ;1 = Key Delay FX
                                       ;2 = Scroll FX


;******************************************************************************
;* LCD Controller Code Section                                                *
;******************************************************************************
;-----------------------------code section-------------------------------------
LCD_CONTROLLER_CODE:    SECTION
;LCD init codes:   
                                       ;|R|R|D|D|D|D|D|D|D|D|
                                       ;|S|W|B|B|B|B|B|B|B|B|
InitialDisplayCodes:                   ;| | |7|6|5|4|3|2|1|0|
      FCB         12                   ;Number of Instructions
      FCB         $30		            ;|0|0|0|0|1|1|*|*|*|*|  1st Reset code
                                       ;Delay 4.1ms after sending 
      FCB	      $30		            ;|0|0|0|0|1|1|*|*|*|*|  2nd Reset code, 
                                       ;Delay 100us after sending 
      FCB         $30                  ;|0|0|0|0|1|1|*|*|*|*|  3rd reset code, 
	                                    ;Delay 40us after each:
      FCB	      $20		            ;FUNCTION SET
      
      FCB	      $20   		         ;4 bit mode 
      FCB         $80   		         ;2 line display; 5x7 dots

      FCB	      $00		            ;Cursor Increment, Disable Display Shift 
      FCB	      $60		            ;0110 - 

      FCB	      $00		            ;Turn Display on, Cursor Off, No Blinkin
      FCB	      $C0		            ; !!! DON'T BLINK

      FCB	      $00		            ;Clear Display Memory, Set cursor 
      FCB	      $10		            ; to home pos 
      
      
;******************************************************************************
;* LCD Initialization function                                                *  
;******************************************************************************
;* LcdInitialization                                                          *
;*  [DESCRIPTION]
;*   Sub-Routine initializes the LCD Screen on the DRAGON 12 Plus 2
;*   
;*  [ARGUMENTS]
;*    - NONE
;*
;*  [RETURNS]
;*    - NONE
;*                                                                            *
;******************************************************************************     
LcdInitialization:
      PSHB                             ;Save B
      MOVB        #$FF  ,LCD_DIR       ;Make Port K output
      MOVB        #$00  ,LCD_OUT       ;
      
      LDX         #InitialDisplayCodes ;Load X with display codes 
                                       ; memory location
      JSR         SelectInstruction    ;Select Instruction
      LDAB        0     ,x             ;Load B with X's first addy
      INX                              ;Increase X to addy of next instruct                            
nextInitInstruction:	
      LDAA   	   0     ,x             ;Load A with X's first addy
      JSR       	ExecuteLcdCommand    ;Run stored instruction
      INX                              ;Next instruction 	
      JSR         Delay5ms             ;Delay 5ms after each instruction
      DECB                             ;Decrement B
      BNE    	   nextInitInstruction  ;Get next init instuction 
      PULB                             ;Restore Register B
   RTS


;******************************************************************************
;* Execute LCD Command                                                        *  
;******************************************************************************
;* LcdInitialization                                                          *
;*  [DESCRIPTION]
;*   Run the instruction in register A
;*   
;*  [ARGUMENTS]
;*    - REGISTER A = Unshifted LCD command
;*
;*  [RETURNS]
;*    - NONE
;*                                                                            *
;******************************************************************************  
ExecuteLcdCommand: 
      ANDA        #$F0                 ;kill lower bits
      LSRA                             ;shift the bits
      LSRA                             ;AGAIN!
      STAA        tempStorage          ;save command to temp
      LDAA        CmdStorage           ;load the command in A
      ANDA        #$03                 ;only want the last 2 bits of cmd
      ORAA        tempStorage          ;combine cmd with passed instruction
      
      STAA        CmdStorage           ;Store complete cmd into CmdStorage
      STAA        LCD_OUT              ;Output to PORT K
      JSR         SetEnable 
 	RTS 


   RTS
;******************************************************************************
;* LCD Instruction Selection                                                  *
SelectData: 
      PSHA                             ;Hold on to A for later
      LDAA        CmdStorage           ;Load A with current command
      ORAA        #IS_DATA             ;Make Data based command
      BRA         SelectInstructionFinal ;Break to finally block 

      
SelectInstruction:
      PSHA                             ;Save A
	   LDAA        CmdStorage           ;Load A with current command
	   ANDA        #IS_INSTRUCTION      ;Set bit1 low for instruction cmd
	   
SelectInstructionFinal: 
	   STAA        CmdStorage           ;Cache command
	   STAA	      LCD_OUT              ;Store cmd to LCD out
	   PULA                             ;restore A
   RTS
 
WriteLine1: 
      JSR         SelectInstruction		; Write LCD Line 1
      LDAA     	#$80     		      ;1000 0000 LCD Address for line 1 
	   BRA         WriteLineFinal       ; Finish
WriteLine2: 
	   JSR    	   SelectInstruction 
      LDAA   	   #$C0     		      ;1100 0000 LCD Address for line 2 
WriteLineFinal: 
      JSR    	   WriteByte 
      JSR    	   SelectData 
                
MessageOutputLoop:                     ;Drain Message
      ;First thing is get a character, character mem locations are in x  
      LDAA        0     ,x             ;x posts to begining of message   

;**** Effects -----------------------------------------------------   
      ;Determine FX mode:
      PSHB
      BRA         NoFX
      ;if FxMode = 0 then key delay mode      
      LDAB        0
      CMPB        #FxMode
      BEQ         NoFX
      ;if FxMode = 1 then key delay mode      
      LDAB        1
      CMPB        #FxMode
      BEQ         KeyDelayFX
      ;If FxMode = 2 the scroll Fx      
      LDAB        2
      CMPB        #FxMode
      BEQ         ScrollFX
      
      BRA         NoFX                 ;if you made it here then nofx
KeyDelayFX:                            ;type text fx
      JSR         Delay100ms	      
      BRA         NoFX
ScrollFX:                              ;Scroll Text
      ;no scroll fx yet....      
      BRA         NoFX      
;**** Effects -----------------------------------------------------      
NoFX:      
      PULB                             ;pull value from b
      JSR         Delay20ms            ;wait 20ms
      JSR         WriteByte            ;write a byte
      INX                              ;Increment X
      DECB	                           ;Decrement B
      BNE         MessageOutputLoop    ;count down from 16
   RTS



 
;       @ enter, a=data to output  
; WriteByte
WriteByte: 
      PSHX                             ;save X out
      PSHA        			            ;save A out 
      ANDA        #$F0     		      ;Mask lower 4 bits
	   LSRA                             ;Align bits 
	   LSRA				                  ;to pk2-pk5				 
      STAA        tempStorage 		   ;Save in temp
      LDAA        CmdStorage    		   ;load cmd to A 
      ANDA        #$03     		      ;only need 2 bits 
      ORAA        tempStorage    		;combine with temp  
      STAA        CmdStorage    		   ;save it back to cmd 
      STAA        LCD_OUT    			   ;and send it to the lcd port           
      
	   BSR	      SetEnable            ;
	   PULA                             ;restore A
 	   ASLA              		         ;left shift 
	   ASLA                             ;left shift
      STAA   	   tempStorage			   ;
      LDAA   	   CmdStorage 			   ; 
      ANDA  	   #$03   			      ;
      ORAA   	   tempStorage  			;
      STAA   	   CmdStorage    		   ;
      STAA   	   LCD_OUT    			   ;output data           
      
      BSR         SetEnable 
	   JSR         Delay50us 
 	   PULX 
   RTS 


;******************************************************************************
;* LCD Properties Selection                                                   *
SetEnable: 
;IS_ENABLE=high
      LDAA        LCD_OUT              ;load port k address to A
      ORAA        #IS_ENABLED          ;Or A with signal bit
	   STAA        LCD_OUT              ;Store is out to port k
	   STAA        IS_ENABLED           ;Store is out to var
;ISNT_ENABLE=low 
	   LDAA        LCD_OUT              ;
	   ANDA        #ISNT_ENABLED        ;
	   STAA        LCD_OUT 
	   STAA        IS_ENABLED 
   RTS
 
;FX Mode Set Property
SetLcdFxOff:
      MOVB        0     ,FxMode
   RTS
SetLcdFxTextDelay:
      MOVB        1     ,FxMode
   RTS


ClearDisplay:
      LDX         #EmptyString                     
      JSR         LcdWriteLine1 
      LDX         #EmptyString  
      JSR         LcdWriteLine2
   RTS


LcdWriteLine1:
      ;MUST have string address to be in x
      ;y MUST contain size
      LDAB        #16                  ;16 Characters
    	JSR         WriteLine1      
      JSR         Delay20ms 
   RTS      	
LcdWriteLine2:
      ;console expects string address to be in x
      ;with the size of string in y
      LDAB        #16                  ;16 Characters
    	JSR         WriteLine2      
      JSR         Delay20ms 
   RTS      	
      	
EmptyString:      FCC      "                "
END
  
;******************************************************************************
;*   ___      __                                                              *
;*  | _ \___ / _|___ _ _ ___ _ _  __ ___ ___                                  *
;*  |   / -_)  _/ -_) '_/ -_) ' \/ _/ -_|_-<                                  *
;*  |_|_\___|_| \___|_| \___|_||_\__\___/__/                                  *
;******************************************************************************
;* Mostly command I wasn't familiar with when writing this                    *
;*                                                                            *
;* FCB (form constant byte)                                                   *
;* FCC (form constant character)                                              *
;*    This directive allows us to define a string of characters (a message).  *
;* The first character in the string is used as the delimiter. The last       *
;* character must be the same as the first character because it will be used  *
;* as the delimiter.                                                          *
;* The delimiter must not appear in the string. The space character cannot be *
;* used as the delimiter. Each character is encoded by its corresponding      *
;* American Standard Code for Information Interchange (ASCII) code.           *
;* For example, the statement:                                                *
;*                                                                            *
;* alpha: fcc “def”                                                           *
;*                                                                            *
;* will generate the following values in memory:                              *
;* $64                                                                        *
;* $65                                                                        *
;* $66                                                                        *
;*                                                                            *
;* and the assembler will use the label alpha to refer to the address of the  *
;* first letter, which is stored as the byte $64.                             *
;* A character string to be output to the LCD display is often defi ned using *
;* this directive.                                                            *
;*                                                                            *
;******************************************************************************
;*                                                                            *
;* The RMB "reserve memory block" pseudo-op takes an argument and skips 
;* that many bytes ahead in the stream of output. It is used to leave a 
;* gap in the object code that will later be filled in by the program 
;* while it is running.
;*
;* RMB     10        * reserve 10 bytes
;*                                                                            *
;******************************************************************************
; The LCD display can use either 8-bit or 4-bit data bus. The Dragon12 board uses a
; 4-bit bus, so it takes two transfers to send one command

