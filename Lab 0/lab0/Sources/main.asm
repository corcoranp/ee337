; *****************************************
; Name: Nicholas Christian/Jon Marstrander
; Program: Lab 0a
; Version: 1.0
; Date Started: August 23, 2008 
; Last Update: NA
; Copyright © 2008
;
; Description: This is Lab 0 for EE337. You are to describe
; the function of this program.
; *****************************************


; *****************************************
; Define entry point for the main program:
; XDEF: make a symbol public (visible to some other file)
; we use export 'Entry' and main as symbol. Either can
; be referenced in the linker .prm file or from C/C++ later on
; *****************************************
    XDEF Entry, main

; *****************************************
; Stack section
; Import reference to an external symbol; symbol defined by the linker for the end of the stack
; *****************************************
    XREF __SEG_END_SSTACK

; *****************************************
; include derivative specific macros
    INCLUDE 'mc9s12dg256.inc'
; *****************************************
MyCode:       SECTION
main:
Entry:
Init: 
; *****************************************
; LEARNING:
;   OPERATION FIELD:  ldaa
;   OPERAND FIELD:    #$00
;   COMMENT FIELD:    starts with ;
;   ADDRESS MODE:     #$00 -> IMMEDIATE MODE: Value located at address
;   CONDITION CODE REGISTER:  SXHI NZVC
;   CCR:                      ---- XX0-
; *****************************************
 ldaa #$00 ;clear accumulator A - Load A with 00
 ldab #$00 ;clear accumulator B - Load B with 00


; *****************************************
;   Star of your code
; *****************************************
Start: 
LoadVal:                ;Intialization portion

; *****************************************
; * Star of your code
; * Load accumulator A with a value, 
; * in this case we choose 0x71. (decimal 113)
; * PMC: In the case of the lab manual, 
; * you chose #$00 (decimal 0)
; * adjusting this value to 0x47 (decimal 71)
; * will allow the program to pass the less than
; * evaluation and continue to the next evaluation
; *****************************************
 ldaa #$00             
 ldaa #$47   

; *****************************************
;   Meat of the program
; *****************************************
CheckVal: 
  ; *****************************************
  ; 
  ; MNEMONIC:           cmpa <opr8a>
  ;   cmpa:             Compare accumulator A to memory
  ;   opr8a:            8-bit address used with direct address mode
  ; CCR: ---- XXXX   
  ;   
  ; OPERATION: (A) - (M) 
  ;   N <exclusive OR> V = 1
  ;
  ;   N:  Set if MSB of result is set; clear otherwise
  ;   Z:  Set if result is $00; clear otherwise
  ;   V:  A7 AND (NOT M7) AND (NOT R7) OR (NOT A7) AND M7 AND R7
  ;       Set if a two's complement overflow resulted from the operation; clear otherwise
  ;   C:  (NOT A7) AND M7 OR M7 AND R7 OR R7 AND (NOT A7)  
  ;       Set if there was a borrow from the MSB of the results; clear otherwise    
  ;
  ; WHAT HAPPENED:   
  ; #$00 is in A - so #$00 - #$41 = 0000 0000 - 0100 0001 = 1011 1111 (or Decimal: -65)
  ; CCR RESULT: ---- 1011
  ;  (not sure with the last CCR value) 
  ; *****************************************
  cmpa #$41   ;65

  ; *****************************************
  ;   BLT can be used to branch after subtracting or comparing 
  ;   signed two’s complement values. After CMPA, CMPB, CMPD, CPS, 
  ;   CPX, CPY, SBCA, SBCB, SUBA, SUBB, or SUBD, 
  ;   the branch occurs if the CPU register value is less than 
  ;   the value in M. 
  ;
  ;   MNEMONIC:         blt <rel8>
  ;     blt:            Branch if Less Than 
  ;     rel8:           Label of Brach Destination within -128 to +127 locations
  ;   ADDRESS MODE:     REL - Two's complement relative offset; for branch instructions 
  ;   IF N <exclusive OR> V = 1 then (PC) + $002 + REL => PC (Program Counter) 
  ;   CCR:              ---- ----
  
  ; WHAT HAPPENED:
  ;   CCR N-bit will be exclusively OR-ed with the V-bit. 
  ;   Since the result of the cmpa was the signed 8-bit number 1011 1111 
  ;   The program counter will be adjusted to point to the Winston memory location
  ; *****************************************
  blt Winston   

  ; *****************************************
  ; WHAT HAPPENED:
  ;   COMPARE accumulator A & 122
  ; *****************************************
  cmpa #$7a   ;122                     
  
  ; *****************************************
  ; WHAT HAPPENED:
  ;   IF    the value in memory was greater than acculator A
  ;   THEN  GOTO Winston memory address 
  ;   ELSE CONTINUE
  ; *****************************************
  bgt Winston  
  
  ; *****************************************
  ; WHAT HAPPENED
  ;   Load accumulator B with value #$01 (decimal 1)
  ; *****************************************  
  ldab #$01
  
  ; *****************************************
  ; WHAT HAPPENED
  ;   BRA = Branch Always
  ;   GOTO Julia memory location
  ; *****************************************                        
  bra Julia                    

; *****************************************
;  Winston LABEL
;   Identifies a memory location in the program
;   and data areas fot he assembly module
; *****************************************  
Winston:
  ldab #$00 ;What happend?       ;Load B with value $00
  
Julia:
Over:
  ; *****************************************
  ; NOP
  ; This single-byte instruction increments the PC and does nothing else. 
  ; No other CPU registers are affected. NOP is typically used to produce a time delay, 
  ; although some software disciplines discourage CPU frequency-based time delays. 
  ; During debug, NOP instructions are sometimes used to temporarily replace other 
  ; machine code instructions, thus disabling the replaced instruction(s).
  
  ; CCR: ---- ---- (not affected
  ; *****************************************  
  nop                           ;NO OPERATION
  nop                           ;NO OPERATION
  ;GOTO OVER: 
  ;The following command always braches to OVER resulting in an infinite loop
  ; to prevent the cpu from running into other memory locations...
  bra Over ;Why?                ;Branch always (if 1=1)  

  
; *****************************************
;   ASSEMBLER DIRECTIVE: end     The end directive is used to end a program to be processed by the assembler
; *****************************************
END
  
  


; **********************************************************************************
; LAB 0 QUESTIONS
; 1. What is the penalty for cheating on your lab assignments?
;     This class follows the UAB Student Conduct Guidelines, cheating is considered
;     an immediate failure 
;
; 2. List 3 arithmetic instructions in assembly
;     1. ADDD
;     2. EMUL
;     3. SUBD
;
; 3. What is a BCD? Based on this lab manual,what are the requirements for making a 100 on your lab reports?
;     a.  BCD = Binary Coded Decimal
;     b.  Page 7 of Lab Manual details rubric: 
;         http://www-ece.eng.uab.edu/jmars/courses/ee337_x/labs/ee337_lab_manual_v2_1.pdf
;     
;     1st Assignment - 20%
      ;   This is the assignment that is provided by the 
      ; lab manual. Strive to have this completed 
      ; before the assigned lab time

      ;2nd Assignment - 25%
      ;  This is the assignment that will be assigned 
      ; after successfully demonstrating your project 
      ; as explained in the lab manual. 


      ;Questions - 20%
      ;   Your labs will have accompanying questions 
      ; that must also be answered before you submit 
      ; your lab for grading. Do not forget to answer 
      ; these questions

      ;Formatting - 10%
      ;    This has to do with the overall format of your 
      ; code, including indentation, whitespace, and 
      ; readability, etc  

      ;Documentation - 10%
      ;   This has to do with your code documentation. 
      ; Please see the attached source code for 
      ; examples of how to write good comments in 
      ; assembly and C.

      ;Pre-Labs - 15%
      ;   You may be expected to turn in a prelab before 
      ; your lab can be demoed. The prelab 
      ; assignments are listed in each lab section of 
      ; this manual.
;
; **********************************************************************************   
  
  
  
  
  
  