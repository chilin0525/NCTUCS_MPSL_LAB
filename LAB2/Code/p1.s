  .syntax unified
    .cpu cortex-m4
    .thumb
.data
    result: .zero 8
.text
    .global main
    .equ X, 0xFFFFFFFF
    .equ Y, 0xFFFFFFFF

kara_mul:
	MOV R3, R0, LSR #16 //a1
	MOV R4, R0
	ROR R4, #16
	MOV R4, R4, LSR #16 //a2
    MOV R5, R1, LSR #16 //b1
	MOV R6, R1
	ROR R6, #16
	MOV R6, R6, LSR #16 //b2

	MUL R7,R3,R5 //z1
	MUL R8,R4,R6 //z2

	ADD R9,R3,R4 //a1+b1
	ADD R10,R5,R6 // a2+b2
	UMULL R11,R12,R9,R10 //(a1+b1)*(b2+a2)
	// R11=RDlo R12=RDhi

	ADDS R10,R7,R8  //z1+z2
	MOV R9,#0
	ADC R9,R9,#0 // R9 for carry R10 for others

	// Z3:
	// 		R12 R11
	// 	-	R9  R10
	//-------------------
	// 		R11 R10
	SUBS R10,R11,R10 //z3=R11
	SBC  R11,R12,R9

	//z1:	R7(0x77777777)
	//z3:  	R11(0x0000000!),R10(0x????????)
	//z2:	R8(0x88888888)

	// 0x77777777|
// 0x0000000!????|????0000
	//			 |88888888

	// 0x77777777|
	//	   0x????|????0000
	// 0x000!0000|
	//			 |88888888

//--------------------------------

	MOV R9,R10,LSR #16 //z3 1
	MOV R3,R10
	ROR R3, #16
	MOV R3,R3,LSR #16 //z3 2
	MOV R3,R3,LSL #16

	// 		   R7|
	//	       R9|R3
	// 0x000!0000|
	//			 |R8

//--------------------------------

	MOV R4,R11
	MOV R4,R4,LSL #16

	// 		   R7|
	//	       R9|R3
	// 		   R4|
	//			 |R8

//--------------------------------

	ADDS R5,R3,R8
	ADC R6,R9,R4
	ADD R7,R7,R6
	STR R7,[R2]
	STR R5,[R2,#4]
    BX lr

main:
    LDR R0, =X
    LDR R1, =Y
    LDR R2, =result
    BL kara_mul
nop
L:
    B L
