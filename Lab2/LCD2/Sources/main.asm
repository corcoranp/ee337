; 
; LCD.asm ----- LCD sample program for DRAGON12-Plus board 
;		(c)2007, EVBplus.com, written by Wayne Chu 
; 
;     Function:	This is the simplest way to display a message on the 
;		16X2 LCD display module. The cursor is off. 
; 
;  This sample program uses 4-bit transfer via port K: 
;  PK0 ------- RS ( register select, 0 = register transfer, 1 = data transfer). 
;  PK1 ------- Enable ( write pulse ) 
;  PK2 ------- Data Bit 4 of LCD 
;  PK3 ------- Data Bit 5 of LCD 
;  PK4 ------- Data Bit 6 of LCD 
;  PK5 ------- Data Bit 7 of LCD 
; 
; Timing of 4-bit data transfer is shown on page 11 of the Seiko LCD 
; application note on the distribution CD. The file name is Seikolcd.pdf 
; 

    XDEF    Entry                                                  
    ;XREF    __SEG_END_SSTACK                                              
    INCLUDE 'mc9s12dg256.inc' 



ONE_MS:		   equ	4000	; 4000 x 250ns = 1 ms at 24 MHz bus speed 
FIVE_MS:	      equ	20000 
TEN_MS:		   equ	40000 
FIFTY_US:	   equ	200 
 
 
DB0:		      equ	1 
DB1:		      equ	2 
REG_SEL:	      equ	DB0	; 0=reg, 1=data              register select
NOT_REG_SEL:   equ	$FE   ;  not register select                              
ENABLE:		   equ   DB1   ;enabled 1
NOT_ENABLE:	   equ   $FD   ;not enabled 13 -> 1111 1101
 
LCD:		      equ	PORTK 
LCD_RS:		   equ	PORTK 
LCD_EN:		   equ	PORTK  
REGBLK:		   equ	$0      ;register blank?
 
 
STACK:	      equ	$2000 
 
	            org	$1000       ;ORG - defines the absolute address of a segment
 
pkimg:		DS	1              ;stands for “reserve memory byte(s)”. It allocates a specified number of bytes. varname RMB 2
                                 ;DS – stands for “define space”. It is the same as RMB  varname DS 2

temp1:		rmb	1              ;  reserve memory block
 
LCDimg:		equ	pkimg       ;LCD image       PORTK
LCD_RSimg:	equ	pkimg       ;LCD Reset image PORTK
LCD_ENimg:	equ	pkimg       ;LCD ENabled image
 
	;org	$2000 
	

Entry:
    jmp	start 
 
lcd_ini: 
	ldaa	#$ff     ;load ff into a so we can output on port k
	staa	DDRK		; port K = output 
	clra	         ; clear register A
	staa	pkimg    ; store cleared register to pkimg (memory space)
	staa	PORTK    ;  store cleared register to PORT K
 
   ldx	#inidsp 	; point to init. codes. 
   
   
	pshb           ; output instruction command to stack, instructions are place on B
       	jsr    	sel_inst                         ;SELECT INSTRUCTION
       	ldab   	0,x 
       	inx 
onext:	ldaa   	0,x 
       	jsr    	wrt_nibble 	                     ; initiate write pulse. 
       	inx 
	jsr	delay_5ms ; every nibble is delayed for 5ms 
       	decb      ; in reset sequence to simplify coding 
       	bne    	onext 
       	pulb 
   RTS 
      	;ini display 
      	
      	
;	FCB – stands for “form constant byte(s)”. It allocates byte(s) of storage with initialized values
;	addrfirstval FCB  $01,250,@373,%111001101
;	FCB $23 

;  DB – stands for define byte(s). It is the same as FCB

inidsp: fcb	12		; number of high nibbles 
*				      ; use high nibbles only, low nibbles are ignored 
	fcb	$30		; 1st reset code, must delay 4.1ms after sending 
   fcb	$30		; 2nd reste code, must delay 100us after sending 
         
; all following 10 nibbles must be delay 40us each after sending 
	fcb   $30      ; 3rd reset code, 
	fcb	$20		; 4th reste code, 
   fcb	$20      ; 4 bit mode, 2 line, 5X7 dot 
	fcb	$80   	; 4 bit mode, 2 line, 5X7 dot 
   fcb	$00		; cursor increment, disable display shift 
	fcb	$60		; cursor increment, disable display shift 
   fcb	$00		; display on, cursor off, no blinking 
	fcb	$C0		; display on, cursor off, no blinking 
	fcb	$00		; clear display memory, set cursor to home pos 
	fcb	$10		; clear display memory, set cursor to home pos 
* 
sel_data:                                                         ;SELECT DATA
	psha 
;	bset	LCD_RSimg REG_SEL	; select instruction 
	ldaa	LCD_RSimg 
	oraa	#REG_SEL 
	bra	sel_ins 
sel_inst:                                                            ;SELECT INSTRUCTION START 
	psha      ;push A to stack
;	bclr	LCD_RSimg REG_SEL	; select instruction 
	ldaa	LCD_RSimg      ;load A with 0 
	anda	#NOT_REG_SEL   ;AND with FE
sel_ins:                                                             ;select ins  
	staa	LCD_RSimg 
	staa	LCD_RS 
	pula 
   
   RTS 
 
lcd_line1: 
	jsr    	sel_inst		   ; select instruction 
   ldaa   	#$80     		; starting address for the line1 
	bra	   line3 
lcd_line2: 
	jsr    	sel_inst 
       	ldaa   	#$C0     		; starting address for the line2 
line3: 	jsr    	wrt_byte 
 
       	jsr    	sel_data 
	jsr	msg_out 
	rts	 
; 
; at entry, x must point to the begining of the message, 
;           b = number of the character to be sent out 
            
msg_out: 
	ldaa   	0,x 
       	jsr    	wrt_byte 
       	inx 
       	decb 
       	bne    	msg_out 
	rts 
 
wrt_nibble: 
       	anda   	#$f0     		; mask out 4 low bits 
       	lsra 
	lsra                            ; 4 MSB bits go to pk2-pk5 
	staa   	temp1 			; save high nibble 
       	ldaa   	LCDimg    		; get LCD port image 
       	anda   	#$03     		; need low 2 bits 
       	oraa   	temp1    		; add it with high nibble 
        staa   	LCDimg    		; save it 
        staa   	LCD    			; output data to LCD port 
        jsr	enable_pulse 
 	rts 
* 
 
;       @ enter, a=data to output  
; 
wrt_byte: 
	pshx 
       	psha        			; save it tomporarily. 
       	anda   #$f0     		; mask out 4 low bits.            
	lsra 
	lsra				; 4 MSB bits go to pk2-pk5				 
       	staa   temp1 			; save nibble value. 
       	ldaa   LCDimg    		; get LCD port image. 
       	anda   #$03     		; need low 2 bits. 
       	oraa   temp1    		; add in low 4 bits.  
       	staa   LCDimg    		; save it 
       	staa   LCD    			; output data           
; 
	bsr	enable_pulse 
	pula 
 	asla            		; move low bits over. 
	asla 
       	staa   	temp1			; store temporarily. 
; 
       	ldaa   	LCDimg 			; get LCD port image. 
       	anda   	#$03   			; need low 2 bits. 
       	oraa   	temp1  			; add in loiw 4 bits.  
       	staa   	LCDimg    		; save it 
       	staa   	LCD    			; output data           
; 
	bsr	enable_pulse 
	jsr	delay_50us 
 	pulx 
       	rts 
; 
enable_pulse: 
;	bset	LCD_ENimg ENABLE	; ENABLE=high 
	ldaa	LCD_ENimg 
	oraa	#ENABLE 
	staa	LCD_ENimg 
	staa	LCD_EN 
	 
;	bclr	LCD_ENimg ENABLE	; ENABLE=low 
	ldaa	LCD_ENimg 
	anda	#NOT_ENABLE 
	staa	LCD_ENimg 
	staa	LCD_EN 
        rts 
 
delay_10ms:   
	pshx 
	ldx     #TEN_MS 
  	bsr	del1 
	pulx 
	rts 
delay_5ms: 
	pshx 
	ldx     #FIVE_MS 
  	bsr	del1 
	pulx 
	rts 
delay_50us: 
	pshx 
	ldx     #FIFTY_US 
  	bsr	del1 
	pulx 
	rts 
; 
; 250ns delay at 24MHz bus speed 
; 
del1:	dex				; 1 cycle 
	inx				; 1 cycle 
	dex				; 1 cycle 
	bne	del1			; 3 cylce 
	rts 
 
start: 
	lds	#STACK 
   jsr	delay_10ms		; delay 20ms during power up 
   jsr	delay_10ms 
 
   jsr	lcd_ini			; initialize the LCD  
                      	 
	ldx    	#MSG1			; MSG1 for line1, x points to MSG1 
   ldab    #16                     ; send out 16 characters 
   jsr	lcd_line1                                          ;CALL line 1
 
   ldx    	#MSG2			; MSG2 for line2, x points to MSG2 
   ldab    #16                     ; send out 16 characters ; load 16 into B
   jsr	lcd_line2                                          ;CALL line 2
   jsr	delay_10ms 
   jsr	delay_10ms 
     	
back:     	
     	jmp	back 

;FCC – stands for “form constant character(s)” and it is used to allocate and initialize memory for storage of a string
;	addrfirstchar FCC “some string”
;  FCC “Alarm 5A high!”
                        
MSG1:   FCC     " Peter Corcoran " 
MSG2:   FCC     "  EE337  LAB 1  " 
       	end 
 