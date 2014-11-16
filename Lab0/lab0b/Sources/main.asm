;**************************************************************
; Name: Peter M. Corcoran
; BlazerID: PMCORCOR
; Program: Lab 0b
; Version: 1.0
; Date: September 1, 2014
; Description: 
;   For this assignment you are asked to do some very simple math. 
;   First off you are to load five random imaginary numbers (ex. 2+5i) 
;   into memory. You should load the real portion into the first memory
;   slot followed by the imaginary portion in the next location. 
;   
;   For example 0x1000 would contain ‘2’ and 0x1001 would contain ‘5’. 
;   Next you are to add the complex numbers that you have put into 
;   memory into the accumulators. 
;   
;   Accumulator A should contain the real portion of the answer 
;   Accumulator B should contain the imaginary portion of the answer
;**************************************************************

;**************************************************************
;* Define entry point for the main program:
;* XDEF: make a symbol public (visible to some other file)
;* we use export 'Entry' and main as symbol. Either can
;* be referenced in the linker .prm file or from C/C++ later on
;**************************************************************
    XDEF Entry, main

;**************************************************************
;* Stack section
;* Import reference to an external symbol; symbol defined by the
;* linker for the end of the stack
;**************************************************************
    XREF __SEG_END_SSTACK

;**************************************************************
;* Include derivative specific macros
;**************************************************************
    INCLUDE 'mc9s12dg256.inc'
    
;************************************************************
;* DATA CONDITIONING
;*  Set origin memory location
;*  Load 5 "random" values into memory  
;*  HOURS spent fighting this, needed to put it before main program
;*  2+4+6+8+10 = 30 Re = 0x1E 
;*  1+3+5+7+9  = 25 Im = 0x19
;*  
;*  array dc.b -> const byte array
;************************************************************
  ORG $1000 ;sets the location counter to $1000
              ;$1000   $1002   $1004   $1006   $1008     <$100A
array  dc.b    $02,$01,$04,$03,$06,$05,$08,$07,$0A,$09;
     
;**************************************************************
;* MAIN PROGRAM
;**************************************************************
MyCode: SECTION
main:
Entry:

  ;************************************************************
  ;* Accumulator A & B Initialization
  ;*  Accumulators store the summed values
  ;************************************************************
      LDD  $1000

  ;************************************************************
  ;* SETUP LOOP
  ;************************************************************ 
      ;********************************************************
      ;* EQU (equate) This directive assigns a value to a label
      ;* Using equ to define constants will make a program more 
      ;* readable.
      ;********************************************************
n     EQU   5       ;Set number of iterations
      LDX   #n      ;Set x-index to iterator, I suppose I could have just set this to 5
      LDY   #array  ;Set y-index register to the array address, like a pointer...
Loop: DBEQ x, Next  ;DBEQ Decrement counter (x) and if = 0 GOTO Next
      INY           ;Increase array address y-reference by 1
      INY           ;Increase array address y-reference by 1
      ADDD  y       ;Add value that is stored in address Y references to value in D
      BRA Loop      ;Always Branch to Loop
Next:
      NOP      
      BRA Next      ;Make sure we don't run into any other memory
END

;**************************************************************
;* QUESTIONS TO BE ANSWERED IN COMMENTS AT THE END OF YOUR CODE
;* 1) List the tools that you will use in this lab.
;*    - The Textbook: The HCS12/9S12: An Introduction to Software and Hardware Interfacing
;*    - CPU12 Reference Manual M68HC12 and HCS12 Microcontrollers
;*      http://www.freescale.com/files/microcontrollers/doc/ref_manual/CPU12RM.pdf
;*    - Lab Manual: http://www-ece.eng.uab.edu/jmars/courses/ee337_x/labs/ee337_lab_manual_v2_1.pdf
;*    - Code Warrior
;*    - 
;* 2) List five functions of the demo board that you would be most interested in using in this lab.
;*    - for this lab 0?...I'm interested in uploading the program to the board
;*    - for this Lab as in the class: LED indicator 
;*    - speaker
;*    - temp sensor
;*    - ir transceiver
;*    
;* 3) What is expected of you, the student, prior to the start of your lab time? 
;*    - The student should do any necessary research to complete the lab prior to attempting to write code
;*    - Code from the textbook often cannot be copied and pasted into your code and be expected to work for your lab.
;*        although I've copied the last 2 statements right out of the lab manual...
;*    - As with any type of research, you must ALWAYS reference the sources for any work that you did not do yourself  
;*    - The student is also expected to complete some amount of code and perform some testing prior to the start of lab 
;*    - Students will be expected to have completed a minimum assignment BEFORE coming to lab
;*    
;*    What did you do to meet these expectations this week? 
;*    - YES
;**************************************************************