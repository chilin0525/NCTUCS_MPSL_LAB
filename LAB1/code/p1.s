        .syntax unified
	.cpu cortex-m4
	.thumb
.data
	result: .byte 0
.text
	.global main
	.equ X, 0x55AA00
	.equ Y, 0xAA5500
hamm:
    eor R4, R1, R2
    mov R6, 0
	LOOP:
        cmp R4,#0
		beq EXIT

        and R7,R4,#1
        cmp R7,#1
		beq ADD
        mov R4,R4, LSR #1
	b LOOP

    ADD:
    add R6,R6,#1
    mov R4,R4, LSR #1
    b LOOP

	EXIT:
	bx lr

main:
	ldr R1,=X
	ldr R2,=Y
	ldr R3, =result
	bl hamm
	str R6, [r3]

L: b L
