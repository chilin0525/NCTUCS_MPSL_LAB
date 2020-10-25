.syntax unified
.cpu cortex-m4
.thumb
.data
//TODO: put 0 to F 7-Seg LED pattern here
	arr: .byte 0x7E, 0x30, 0x6D, 0x79, 0x33, 0x5B, 0x5F, 0x70, 0x7F, 0x73, 0x77, 0x1F, 0x4D, 0x3D, 0x4F, 0x47
.text
	.equ RCC_AHB2ENR, 0x4002104C
	.equ GPIOC_MODER, 0x48000800
	.equ GPIOC_OTYPER, 0x48000804
	.equ GPIOC_OSPEEDR, 0x48000808
	.equ GPIOC_PUPDR, 0x4800080C
	.equ GPIOC_ODR, 0x48000814
	.equ GPIOC_BSRR,0x48000818
	.equ GPIOC_BSR,0x48000828

	.equ DELAY_TIME, 4000000

	.equ DECODE_MODE,   0x00000900
	.equ INTENSITY,     0x00000A00
	.equ SCAN_LIMIT,    0x00000B00
	.equ SHUTDOWN,      0x00000C00
	.equ DISPLAY_TEST,  0x00000F00
	.equ DIGIT0, 	 	0x00000100
.global main

main:
	mov R12,#0 // counter of LED pattern
	BL GPIO_init
	BL max7219_init

loop:
	BL DisplayDigit
	BL Delay
	B loop


GPIO_init:
//TODO: Initialize GPIO pins for max7219 DIN, CS and CLK

	// open clk
	mov R0,#4 	// 100
	ldr R1,=RCC_AHB2ENR
	str R0,[R1]

	// set output mode 01
	mov R0,#0b010101
	ldr R1,=GPIOC_MODER
	str R0,[R1]

	// set pc0 pc1 pc2 output = 0
	// pc0 <---> DIN
	// pc1 <---> CS
	// pc2 <---> CLK

	mov R0,#0
	ldr R1,=GPIOC_ODR
	str R0,[R1]

BX LR


DisplayDigit:
//TODO: Display 0 to F at first digit on 7-SEG LED.
	PUSH {LR}

	ldr R0,=DIGIT0
	ldr R1,=arr
	ldr R1,[R1,R12]
	BL MAX7219Send

	add R12,R12,#1
	cmp R12,#16
	IT eq
	moveq R12,#0 // clear when access 16

	POP {LR}
BX LR


MAX7219Send: //(ADDRESS,DISPLAY_DATA)
//input parameter: r0 is ADDRESS , r1 is DATA
//TODO: Use this function to send a message to max7219

	// r0 is control bit and r1 is input data --> concate r0 and r1
	ADD R0,R0,R1
	LSL R0,R0,#16

	mov R2,#1 		// set R2 as CLK
	mov R3,#16 		// if R3 == 16 , set CS(load DIN to max7219)
	mov R4,#0x80000000 // BitMask
	ldr R5,=GPIOC_BSRR
	ldr R6,=GPIOC_BSR
	mov R7,#0b100 	// Set CLK  pc2 <---> CLK
	mov R8,#0b10 	// Set CS   pc1 <---> CS
	mov R9,#0b1 	// Set DIN  pc0 <---> DIN

	SET_DIN:
		eor R2,#1 		// R2 = CLK
		cmp R2,#0
		ITET eq
		streq R7,[R6] 	// reset
		strne R7,[R5] 	// set
		beq SET_DIN 	// if CLK==0 go back to SET_DIN

		AND R1,R0,R4
		ROR R1,R1,#31  // R1 is MSB of AND(R4,R0)
		LSL R0,R0,#1

		cmp R1,#0
		ITE EQ
		streq R9,[R6] // if 0 reset
		strne R9,[R5] // if 1 set

		SUB R3,R3,#1
		CMP R3,#0
		bne SET_DIN

	//str R7,[R6]
	str R8,[R5]
	//str R8,[R6]

BX LR


max7219_init:
//TODO: Initialize max7219 registers
	PUSH {LR}

	mov R1,#0			// normal op
	ldr R0,=DISPLAY_TEST
	BL MAX7219Send

	mov R1,#1			// normal op
	ldr R0,=SHUTDOWN 	
	BL MAX7219Send

	mov R1,#0			//set only DIGIT-0
	ldr R0,=SCAN_LIMIT 	
	BL MAX7219Send

	mov R1,#0xA			// brightness
	ldr R0,=INTENSITY
	BL MAX7219Send

	mov R1,#0 			// all 7 digit decode self
	ldr R0,=DECODE_MODE // control bit
	BL MAX7219Send

	POP {LR}
BX LR


Delay:
//TODO: Write a delay 1sec function
	ldr R0,=DELAY_TIME
	MINUS:
		sub R0,R0,1
		cmp R0,#0
		bgt MINUS
BX LR
