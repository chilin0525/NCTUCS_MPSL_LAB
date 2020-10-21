	.syntax unified
	.cpu cortex-m4
	.thumb
.data
	password: .byte 0b0001
.text
	.global main
	.equ RCC_AHB2ENR,0x4002104C
	.equ GPIOA_MODER,0x48000000
	.equ GPIOA_OTYPER,0x48000004
	.equ GPIOA_OSPEEDR,0x48000008
	.equ GPIOA_PUPDR,0x4800000C
	.equ GPIOA_ODR,0x48000014
	.equ GPIOC_MODER,0x48000800
	.equ GPIOC_PUPDR,0x4800080c
	.equ GPIOC_IDR,0x48000810
	.equ delay,4000000
main:
BL GPIO_init

LOOP:
	BL POLL
	BL PRESS
	B LOOP

POLL:
	ldr r0,=GPIOC_IDR
	ldr r1,[r0]
	and r1,r1,#0b10000000000000
	cmp r1,#0b10000000000000
	beq POLL

BX LR

PRESS:
	ldr r0,=GPIOC_IDR
	ldr r1,[r0]
	and r1,r1,#0b1111
	eor r1,r1,#0b1111

	mov r3,0b100000
	ldr r2,=GPIOA_ODR
	str r3,[r2]

	mov r12,#1

	ldr r4,=password
	ldr r4,[r4]
	cmp r1,r4
	it eq
	moveq r12,#3

L1:
	sub r12,r12,#1
	ldr r11,=delay
	b L2
OK:
	cmp r12,#0
	beq DONE
	mov r3,0b000000
	ldr r2,=GPIOA_ODR
	str r3,[r2]
	ldr r11,=delay
	b L3
OK1:
	mov r3,0b100000
	ldr r2,=GPIOA_ODR
	str r3,[r2]
	b L1

L2:
	sub r11,r11,#10
	cmp r11,#0
	bgt L2
	b OK

L3:
	sub r11,r11,#10
	cmp r11,#0
	bgt L3
	b OK1


DONE:
	mov r3,0b000000
	ldr r2,=GPIOA_ODR
	str r3,[r2]

BX LR

GPIO_init:
	mov r0,0b101
	ldr r1,=RCC_AHB2ENR
	str r0,[r1]

	ldr r0,=#0xF3FFFF00
	ldr r1,=GPIOC_MODER
	str r0,[r1]

	mov r0,0b01010101
	ldr r1,=GPIOC_PUPDR
	str r0,[r1]

	mov r0,0b10000000000000
	ldr r1,=GPIOC_IDR
	str r0,[r1]

	mov r0,0b010000000000
	ldr r1,=GPIOA_MODER
	str r0,[r1]

	mov r0,0
	ldr r1,=GPIOA_ODR
	str r0,[r1]

BX LR
