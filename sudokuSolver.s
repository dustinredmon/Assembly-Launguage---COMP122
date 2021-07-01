.equ SWI_Open, 0x66 @open a file 
.equ SWI_Close,0x68 @close a file
.equ SWI_PrChr,0x00 @ Write an ASCII char to Stdout
.equ SWI_PrStr, 0x69 @ Write a null-ending string
.equ SWI_PrInt,0x6b @ Write an Integer
.equ SWI_RdInt,0x6c @ Read an Integer from a file
.equ Stdout, 1 @ Set output target to be Stdout
.equ SWI_Exit, 0x11 @ Stop execution
.equ SWI_RdStr, 0x6a @ Stop execution

.global _start
.text

ldr r0, =FileName 				; open the file
mov r1, #0 
swi SWI_Open
bcs errorMessage
ldr r1,=FileHandle 
str r0,[r1]
ldr r1, =STK_SZ

readPuzzle:
	ldr r1,=CharArray			
	mov r2,#1000
	swi SWI_RdStr
	@bcs endOfFileReached		
	mov r9,r1
	ldr r8, =STK_TOP
	ldr r7,=0				; current row
	ldr r6,=0				;current column
	ldr r5,=0				;current location of stack
	ldr r4,=0x31				;keep track of assigned values 1-9
	ldr r3,=0				;current location of the board
	mov r0,r9	
solve:						; branch to beginning of loop until puzzle is solved

findFirstEmpty:
	ldrb r0, [r0]				
	cmp r0,#0x30				
	beq testNumbers				
	bne moveToNextCell			
testNumbers:
	sub r0,r8,r5				
	str r4,[r0]				
	cmp r4,#0x3A				
	add r4,r4,#1				
	beq moveBack			
	bal unhappyRow
returnUnhappyRow:
	cmp r1,#1
	beq unhappyCol				; a 1 in R1 means unhappyRow has returned true
	bne testNumbers				
returnUnhappyCol:
	cmp r1,#1					
	beq unhappyBox				; a 1 in R1 means unhappyCol has returned true
	bne testNumbers			
returnUnhappyBox:
	cmp r1,#1					
	beq assignValue				; a 1 in R1 means unhappyBox has returned true
	bne testNumbers			


assignValue:
	sub r0, r8,r5				; address of stack location
	ldr r0,[r0]				
	add r1,r9,r3				; address of current location of the board
	strb r0,[r1]				; change the value 
	sub r0, r8,r5				; address of current location of the stack
	str r1,[r0]				
	add r5,r5,#4				; move the stack pointer to the next location
	ldr r4, =0x31				
	bal moveToNextCell

moveBack:
	bal findPrevZero			

findPrevZero:					; find previous zero
	sub r5,r5,#4				
	sub r0,r8,r5				
	ldr r0,[r0]					
	sub r1,r8,#4				
	cmp r0, r1					
	beq boardUnsolvable		
    	bal changeColumnAndRow		

returnChangeColumnAndRow:
	add r0,r9,r3				
	ldrb r0,[r0]				
	add r0,r0,#1				
	mov r4,r0					
	sub r1,r8,r5				
	str r4,[r1]					
	add r1,r9,r3				
	ldr r2,=0x30				
	strb r2,[r1]				
	cmp r0,#0x3A				
	beq findPrevZero		
	bal testNumbers			

changeColumnAndRow:				; adjust the board location keeper
	mov r2,r3					
	sub r3,r0,r9				
	ldr r1,=1
	sub r1,r3,r1
changeColumnAndRowLoop:
	sub r2,r2,#1
	cmp r2,r1
	beq returnChangeColumnAndRow
	sub r6,r6,#1
	cmp r6,#-1
	bne solvedIf4
	sub r7,r7,#1
	cmp r7,#-1
	beq boardUnsolvable
	ldr r6, =8

solvedIf4:
bal changeColumnAndRowLoop

moveToNextCell:					
	add r3, r3, #1				
	add r0, r9, r3				
	add r6,r6,#1				
	cmp r6,#9					
	bne solvedIf1					
	add r7,r7,#1
	cmp r7,#9
	beq printBoard				; Board is solved
	ldr r6,=0
solvedIf1:
	bal solve 				; branch to solve loop
	

unhappyRow:					; check row
	ldr r2, =9					
	mul r2,r7,r2				
	add r2,r9,r2				
	stmia sp!, {r2}				
	ldr r1, =0					
	stmia sp!,{r1}				
whileUnhappyRow:
	ldrb r1, [r2]				
	ldr r2,[r0]					
	cmp r1,r2					
	ldmdb sp!, {r1}				
	ldmdb sp!, {r2}				
	beq testNumbers									
	add r1,r1,#1				
	cmp r1, #9					
	beq breakUnhappyRowWhile
	add r2,r2,#1				
	stmia sp!, {r2}				
	stmia sp!,{r1}				
	bal whileUnhappyRow
breakUnhappyRowWhile:
	ldr r1,=1					; make r1=1 to show the checkRow was successfull
bal returnUnhappyRow

unhappyCol:					;Check Column
	add r2, r9, r6				
	stmia sp!, {r2}				
	ldr r1, =0					
	stmia sp!,{r1}				
whileUnhappyColumn:
	ldrb r1, [r2]				
	ldr r2,[r0]					
	cmp r1,r2					
	ldmdb sp!, {r1}				
	ldmdb sp!, {r2}				
	beq testNumbers								
	add r1,r1,#1				
	cmp r1, #9					
	beq breakUnhappyColumnWhile								
	add r2,r2,#9				
	stmia sp!, {r2}				
	stmia sp!,{r1}				
bal whileUnhappyColumn
breakUnhappyColumnWhile:
	ldr r1,=1					
bal returnUnhappyCol

unhappyBox:				;Check Box
	ldr r1, =2
	cmp r6, r1
	bls compareRow			
	ldr r1, =5
	cmp r6, #5
	bls compareRow			
	ldr r1, =8
	cmp r6, #8
	bls compareRow			
compareRow:
	ldr r2, =2
	cmp r7, r2
	bhi checkRow5				
	cmp r1, #2
	beq checkBox0				
	cmp r1, #5
	beq checkBox1				
	cmp r1, #8
	beq checkBox2				
checkRow5:
	ldr r2, =5
	cmp r7, r2
	bhi checkRow8				
	cmp r1, #2
	beq checkBox3				
	cmp r1, #5
	beq checkBox4				
	cmp r1, #8
	beq checkBox5				
checkRow8:
	ldr r2, =8
	cmp r7, r2
								
	cmp r1, #2
	beq checkBox6				
	cmp r1, #5
	beq checkBox7				
	cmp r1, #8
	beq checkBox8				

checkBox0:						
	ldr r1,=0
	bal checkFocusBox
checkBox1:						
	ldr r1,=3
	bal checkFocusBox
checkBox2:						
	ldr r1,=6
	bal checkFocusBox
checkBox3:						
	ldr r1,=27
	bal checkFocusBox
checkBox4:						
	ldr r1,=30
	bal checkFocusBox
checkBox5:						
	ldr r1,=33
	bal checkFocusBox
checkBox6:						
	ldr r1,=54
	bal checkFocusBox
checkBox7:						
	ldr r1,=57
	bal checkFocusBox
checkBox8:						
	ldr r1,=60
	bal checkFocusBox

checkFocusBox:						
	stmia sp!,{r1}				
	ldr r2, =0					
	stmia sp!,{r2} 				
loopInTheBox:
	add r1,r9,r1				
	ldrb r1,[r1]				
	ldr r2,[r0]			
	cmp r1,r2			
	beq testNumbers			
	ldmdb sp!,{r2}				
	ldmdb sp!,{r1}				
	add r2,r2,#1				
	cmp r2, #3					
	bhs endOfRow1
	add r1,r1,#1				
	stmia sp!,{r1}				
	stmia sp!,{r2} 				
	bal loopInTheBox
endOfRow1:
	cmp r2, #6					
	bhs endOfRow2		
	cmp r2, #3					
	bne solvedIf2					
	sub r1,r1,#2				
	add r1,r1,#8				
solvedIf2:	
	add r1,r1, #1				
	stmia sp!,{r1}				
	stmia sp!,{r2} 				
	bal loopInTheBox
endOfRow2:
	cmp r2, #9
	bhs breakUnhappyBoxWhile		
	cmp r2, #6					
	bne solvedIf3					
	sub r1,r1,#11				
	add r1,r1,#17				
solvedIf3:
	add r1,r1, #1				
	stmia sp!,{r1}				
	stmia sp!,{r2} 				
	bal loopInTheBox

breakUnhappyBoxWhile:
	ldr r1,=1					
bal returnUnhappyBox

giveTheStatus:

break:
	mov r0, #Stdout
	ldr r1, =Count
	swi SWI_PrStr
	sub r1,r8,#1
	swi SWI_PrInt
	mov r0,#'\n
	swi SWI_PrChr				
@bal loopUntilEndOfTheFile		
bcs endOfFileReached		
@ =========== print board
printBoard:
	mov r0, #Stdout
	ldr r1, =BoardSolved
	swi SWI_PrStr
	mov r2,r9
	ldr r3,=0
loop1:
	ldrb r1, [r2]				
	sub r1,r1,#0x30
	swi SWI_PrInt
	add r2,r2,#1
	add r3,r3,#1
	cmp r3,#81
	beq endOfFileReached2
	bal loop1
boardUnsolvable:
	mov R0, #Stdout
	ldr r1, =BoardUnsolvable
	bal endOfFileReached2
endOfFileReached:				
	bal printBoard;
endOfFileReached2:	

closingTheFile:
	ldr r0, =FileHandle
	ldr r0,[r0]
	swi SWI_Close
Exit:
	swi SWI_Exit @ Stop executing
errorMessage:
	mov R0, #Stdout
	ldr R1, =OpeningFileError
	swi SWI_PrStr
	ldr R1,=FileName
	swi SWI_PrStr
	mov R0, #'\n
	swi SWI_PrChr
	bal Exit
.data
.align
FileName: .asciz "input.txt"
.align
OpeningFileError: .asciz "Error: Unable to open file"
.align
EndOfFileMessage: .asciz "End of file "
.align
Count: .asciz "Characters: "
.align
BoardSolved: .asciz "Board Successfully solved!\n"
.align
BoardUnsolvable: .asciz "Board can not be solved!\n"
.align
FileHandle: .word 0
.align
CharArray: .skip 82
.align
STK_SZ: .space 0x100 		;  stack
STK_TOP: .word 1
.end