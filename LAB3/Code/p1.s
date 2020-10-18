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
	.equ delay, 3999995

main:
	BL GPIO_init
	MOVS R1,#0b1000
	LDR R0, =leds //r0 = LED state
	STR R1, [R0]
	mov r11,#0

Loop:
	BL Delay
	BL DisplayLED
	B Loop

GPIO_init:
	// open port enable clock of GPIO bus
	mov r0,#0x2
	ldr r1,=RCC_AHB2ENR
	str r0,[r1]

	//set PB[6-3] mode
	mov r0,#0b1010101000000
	ldr r1,=GPIOB_MODER
	str r0,[r1]

	//ACTIVE LOW PB[4-6]=1 PB[3]=0
	mov r0,#0b1110000
	ldr r1,=GPIOB_ODR
	str r0,[r1]

	BX LR

DisplayLED:
	ldr r0,=leds	  //R0: LED state address
	ldr r1,=GPIOB_ODR //R1: ODR address
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
	eor r3,r2,0b1111111 //Bitwise XOR
	str r3,[r1] //0011000 XOR 1111111 = 1100111
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
	ldr r12,=delay // 2

LOOP1:
    sub r12,r12,#5 // 1
    cmp r12,#0 //  1
    bgt LOOP1 //3 >

   	BX LR // 3
