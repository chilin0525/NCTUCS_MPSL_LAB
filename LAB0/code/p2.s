    .syntax unified
    .cpu cortex-m4
    .thumb
.data
	X: .word 100
    str: .asciz "Hello World!"
    Z: .word 1
.text
    .global main
    .equ AA, 0x55
main:
    ldr r1, =X
    ldr r0, [r1]
    ldr r5, =AA
    movs r2, #AA
    adds r2, r2, r0
    str r2, [r1]
    ldr r1, =str
    ldr r2, [r1]
    ldr r1, =X
    ldr r4, [r1]
    ldr r1, =Z
    mov r5,#3
    mul r5,r4,r5
	str r5,[r1]

L: B L
