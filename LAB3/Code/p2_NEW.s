	.syntax unified
	.cpu cortex-m4
	.thumb
.data
	leds: .byte 0
.text
	.global main
	.equ RCC_AHB2ENR, 0x4002104C
	.equ GPIOB_MODER, 0x48000400
	.equ GPIOB_OTYPER, 0x48000404
	.equ GPIOB_OSPEEDR, 0x48000408
	.equ GPIOB_PUPDR, 0x4800040C
	.equ GPIOB_ODR, 0x48000414
	.equ GPIOC_MODER, 0x48000800
	.equ GPIOC_ODR, 0x48000810
	.equ delay, 4000000
main:
BL GPIO_init
MOVS R1, #0b1000
LDR R0, =leds
STR R1, [R0]
mov r11,#0

Loop:
ldr r12,=delay
BL Delay
BL DisplayLED
B Loop

GPIO_init:
mov r0,#0x6
ldr r1,=RCC_AHB2ENR
str r0,[r1]

mov r0,#0b1010101000000
ldr r1,=GPIOB_MODER
str r0,[r1]

mov r0,#0b1110000
ldr r1,=GPIOB_ODR
str r0,[r1]

mov r0,#0xF3FFFFFF
ldr r1,=GPIOC_MODER
str r0,[r1]

mov r0,#0b10000000000000
ldr r1,=GPIOC_ODR
str r0,[r1]

BX LR

DisplayLED:
ldr r0,=leds
ldr r1,=GPIOB_ODR
ldr r2,[r0]
add r4,r2,r11

cmp r4,#0b1000
beq S1
cmp r4,#0b11000
beq S2
cmp r4,#0b110000
beq S3
cmp r4,#0b1100000
beq S4
cmp r4,#0b1000000
beq S5
cmp r4,#0b1100001
beq S6
cmp r4,#0b110001
beq S7
cmp r4,#0b11001
beq S8

S1:
mov r2,#0b11000
str r2,[r0]
eor r3,r2,0b1111111
str r3,[r1]
BX LR
S2:
mov r2,#0b110000
str r2,[r0]
eor r3,r2,0b1111111
str r3,[r1]
BX LR
S3:
mov r2,#0b1100000
str r2,[r0]
eor r3,r2,0b1111111
str r3,[r1]
BX LR
S4:
mov r2,#0b1000000
str r2,[r0]
eor r3,r2,0b1111111
str r3,[r1]
BX LR
S5:
mov r2,#0b1100000
str r2,[r0]
eor r3,r2,0b1111111
str r3,[r1]
mov r11,#1
BX LR
S6:
mov r2,#0b110000
str r2,[r0]
eor r3,r2,0b1111111
str r3,[r1]
BX LR
S7:
mov r2,#0b11000
str r2,[r0]
eor r3,r2,0b1111111
str r3,[r1]
BX LR
S8:
mov r2,#0b1000
str r2,[r0]
eor r3,r2,0b1111111
str r3,[r1]
mov r11,#0
BX LR

Delay:
cmp r7,1
beq LONG

mov r8,#0
mov r9,#0
mov r7,#0
LOOP1:
   ldr r10,=GPIOC_ODR
   ldr r10,[r10]

   cmp r10,#0
   IT EQ
   addeq r8,r8,#1

   cmp r10,#0b10000000000000
   ITT EQ
   moveq r8,#0
   moveq r7,#0

   cmp r7,#1
   beq SKIP

   cmp r8,#1000
   ITTT gt
   eorgt r9,#1
   movgt r8,#0
   movgt R7,#1

SKIP:
   cmp r9,#0
   IT EQ
   subeq r12,r12,#23

   cmp r12,#0
   bge LOOP1

   b DONE
LONG:
   ldr r10,=GPIOC_ODR
   ldr r10,[r10]
   cmp r10,#0b10000000000000
   IT EQ
   moveq r7,0

   sub r12,r12,#15

   cmp r12,0
   ble DONE

   b Delay
DONE:

BX LR
