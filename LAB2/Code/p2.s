    .syntax unified
    .cpu cortex-m4
.thumb
.data
    infix_expr: .asciz "{[]}"
    user_stack_bottom: .zero 128
.text
.global main
//move infix_expr here. Please refer to the question below.

main:
    BL stack_init
    BL str_length
    LDR R0, =infix_expr
    mov R3,#0
    BL check
    BL pare_check

L: B L

str_length:
    LDR R0, =infix_expr
	LDR R1, =user_stack_bottom
	SUB R1,R1,R0
	SUB R1,R1,#1 // R1 = string length
	BX LR

stack_init:
//TODO: Setup the stack pointer(sp) to user_stack.
    LDR R1, =user_stack_bottom
    ADD R1,R1,#128
    MOV sp, R1
    MOV R2, sp // R2: check for init sp
    BX LR

check:
	CMP R3,R1
	IT	EQ
	BXEQ LR
	LDRB R5,[R0,R3]
	CMP R5,#0x5B
	IT EQ
	PUSHEQ {R5}
	CMP R5,#0x7B
	IT EQ
	PUSHEQ {R5}
	CMP R5,0x5D
	IT EQ
	POPEQ {R5}
	CMP R5,#0x7D
	IT EQ
	POPEQ {R5}
	ADD R3,#1
	B check

pare_check:
//TODO: check parentheses balance, and set the error code to R0.
	MOV R3,sp
	CMP R2,R3
	ITE EQ
	MOVEQ R0,#0
	MOVNE R0,#-1
    BX LR
