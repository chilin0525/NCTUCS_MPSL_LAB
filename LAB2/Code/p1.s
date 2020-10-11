    .syntax unified
    .cpu cortex-m4
    .thumb
.data
    result: .zero 8
.text
    .global main
    .equ X, 0x12345678
    .equ Y, 0x77654321

main:
    LDR R0, =X
    LDR R1, =Y
    LDR R2, =result
    BL kara_mul

L:
    B L

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
	ADD R9,R3,R4
	ADD R10,R5,R6
	ADD R12,R7,R8 //z1+z2
	MUL R11,R9,R10
	SUB R11,R11,R12 //z3=R11
	MOV R9,R11,LSR #16 //z3 1
	MOV R10,R11
	ROR R10, #16
	MOV R10,R10,LSR #16 //z3 2
	MOV R10,R10,LSL #16
	ADDS R3,R10,R8
	ADC R4,R9,R7
	STR R4,[R2]
	STR R3,[R2,#4]
    BX lr

