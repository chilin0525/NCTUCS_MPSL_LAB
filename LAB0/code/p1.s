.syntax unified
.cpu cortex-m4
.thumb
.data
	  X: .word 100
    str: .asciz "Hello World!"
.text
  .global main
  .equ AA, 0x55
main:
ldr r1, =X
ldr r0, [r1]
movs r2, #AA
adds r2, r2, r0
str r2, [r1]
ldr r1, =str
ldr r2, [r1]
ldrsh r3,[r1,#4]
L: B L
