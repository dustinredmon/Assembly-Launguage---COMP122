	.equ SWI_Open, 0x66
	.equ SWI_RdInt, 0x6C
	.equ SWI_PrInt, 0x6B
	.equ SWI_Close, 0x68
	.equ SWI_Exit, 0x11
	.equ SWI_Print_Char, 0x00
        .equ SWI_PrStr, 0x69
        .equ Stdout,1



	.data

InFileName:   
	.asciz "input.txt"
InFileHandle:
         .word 0

NL:
         .asciz "\n"
Message1:
         .asciz "Accending :"

MyArray:
         .skip 20*4

	.text
	.global _start
_start:
        
        ;; TODO: write your code below this comment
        
         ldr r0, =InFileName
         mov r1,#0
         swi SWI_Open           ;; Opening the file that contains integer
         ldr r1,=InFileHandle
         str r0,[r1]
         mov R7,#2
         LDR R5,=MyArray
         mov R4,#0
;;Reading the integer
loop:         
         ldr r0, =InFileHandle
         ldr r0,[r0]
         swi SWI_RdInt
         mov r6,r0         
         
         STR R6,[R5,R7]
         ADD R7,R7,#4
         
         
         
         cmp r6,#-1
       beq Sorting
         add R4,R4,#1
         mov r1,r6
   

                 
         b loop 

Sorting: 
         LDR R9,=MyArray
         mov R3,#2
         mov r5,r4
outer_loop:
	LDR R1,[R9,R3]
        ;;ADD R3,R3,#4
        sub R7,R4,#1          
        mov R8,R3   
	
        inner_loop1:         
                add R8,R8,#4
                LDR R2,[R9,R8]                         	
         	
                sub R7,R7,#1
                cmp R7,#-1
                beq Again
                cmp R1,R2
                bgt Swap
                        
                
                
                 
        	b inner_loop1

Again:
     ADD R3,R3,#4
     sub R4,R4,#1
     cmp R4,#0
     beq print
     bal outer_loop

Swap:
    LDR R6,[R9,R3]
    STR R2,[R9,R3]
    STR R6,[R9,R8]
    mov R1,R2
    bal inner_loop1



print: 
         LDR R9,=MyArray
         mov R3,#2
         LDR R1,=Message1
         swi SWI_PrStr
         
         LDR R1,=NL
         swi SWI_PrStr
loop1:         
         LDR r1,=NL
         swi SWI_PrStr
         
         LDR R1,[R9,R3]
         ADD R3,R3,#4
         mov R0,#Stdout
         
         swi SWI_PrInt
         sub R5,R5,#1
         cmp R5,#0
         beq exit
         b loop1

  

exit:
        ;;Closing the File
        ldr R0,=InFileHandle
        ldr R0,[R0]
        swi SWI_Close
             
	;; exit program
	swi SWI_Exit
	.end
	
