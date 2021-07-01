	.equ SWI_Open_File, 0x66
	.equ SWI_Read_Int, 0x6C
	.equ SWI_Print_Int, 0x6B
	.equ SWI_Close, 0x68
	.equ SWI_Exit, 0x11
	.equ SWI_Print_Char, 0x00
        .equ SWI_Open, 0x66
        .equ SWI_RdInt, 0x6c
	.equ Stdout, 1
        .equ SWI_PrInt, 0x6b
        .equ SWI_PrStr, 0x69
        .data
InFileName:
	.asciz "input.txt"
InFileError:
        .asciz "Unable to open Input file\n"
        .align
InFileHandle:
        .word  0        
NL:
        .asciz "\n"
Message:
        .asciz "Sum of the integers is: "

Message2:
.asciz "Number of inputs: "
	.text

	.global _start
_start:
       	;; Register r7 is used to store number of inputs
        mov r7,#0
        ;; Register R6 is used for sum...
         mov r6,#0            
        ;; Open the file, putting the filehandle in
        ldr r0,=InFileName
        mov r1,#0
        swi SWI_Open
        ;;bcs InFileError
        ldr r1,=InFileHandle
        str r0,[r1]

;; Reading the integers
          
loop:
        ldr r0,=InFileHandle
        ldr r0,[r0]
        swi SWI_RdInt
        bcs EofReached        ;; checking for end of file if yes then jump to EofReached
        mov r1,r0
        add r6,r6,r1
        add r7,r7,#1
        mov R0,#Stdout
        swi SWI_PrInt
        mov R0,#Stdout
        ldr r1,=NL
        swi SWI_PrStr
        
        bal loop            


EofReached:
        mov R0,#Stdout
        ldr r1,=Message2
        swi SWI_PrStr

        mov R0,#Stdout
        mov r1,r7
        swi SWI_PrInt
        mov R0,#Stdout
        ldr r1,=NL
        swi SWI_PrStr
         
        
        mov R0,#Stdout
        ldr r1,=Message
        swi SWI_PrStr
        mov r1,r6
        mov r0,#Stdout
        swi SWI_PrInt


        ;; Close the file
        ldr R0,=InFileHandle
        ldr R0,[R0]
        swi SWI_Close

	;; exit the program
	swi SWI_Exit
	.end
	
