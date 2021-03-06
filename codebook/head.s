.syntax unified
.cpu cortex-m4
.thumb
.data
	// arr declare
	// arr: .byte 0x7E, 0x30, 0x6D, 0x79, 0x33, 0x5B, 0x5F, 0x70, 0x7F, 0x73, 0x77, 0x1F, 0x4D, 0x3D, 0x4F, 0x47
.text
	.equ RCC_AHB2ENR, 	0x4002104C

	.equ GPIOA_MODER, 	0x48000000
	.equ GOIOA_OTYPER,	0x48000004
	.equ GPIOA_OPSEEDER,0x48000008
	.equ GPIOA_PUPDR,	0x4800000C
	.equ GPIOA_IDR,		0x48000010
	.equ GPIOA_ODR,		0x48000014
	.equ GPIOA_BSRR,	0x48000018
	.equ GPIOA_BRR,		0x48000028

	.equ GPIOB_MODER, 	0x48000400
	.equ GPIOB_OTYPER, 	0x48000404
	.equ GPIOB_OSPEEDR, 0x48000408
	.equ GPIOB_PUPDR, 	0x4800040C
	.equ GPIOB_IDR,		0x48000410
	.equ GPIOB_ODR, 	0x48000414
	.equ GPIOB_BSRR,	0x48000418
	.equ GPIOB_BRR,		0x48000428

	.equ GPIOC_MODER, 	0x48000800
	.equ GPIOC_OTYPER, 	0x48000804
	.equ GPIOC_OSPEEDR,	0x48000808
	.equ GPIOC_PUPDR, 	0x4800080C
	.equ GPIOC_IDR,		0x48000810
	.equ GPIOC_ODR, 	0x48000814
	.equ GPIOC_BSRR,	0x48000818
	.equ GPIOC_BRR,		0x48000828

	// 1s : nearly 4000000 1 cycle = 0.25 us
	.equ DELAY_TIME, 	4000000

	.equ DIN,0b00000001 // DIN <===> pc0
	.equ CS,0b00000010  // CS  <===> pc1
	.equ CLK,0b00000100 // CLK <===> pc2
	
	// 7-segment
	.equ DIGIT0, 	 	0x00000100
	.equ DIGIT1, 	 	0x00000200
	.equ DIGIT2, 	 	0x00000300
	.equ DIGIT3, 	 	0x00000400
	.equ DIGIT4, 	 	0x00000500
	.equ DIGIT5, 	 	0x00000600
	.equ DIGIT6, 	 	0x00000700
	.equ DIGIT7, 	 	0x00000800
	.equ DECODE_MODE,   0x00000900
	.equ INTENSITY,     0x00000A00
	.equ SCAN_LIMIT,    0x00000B00
	.equ SHUTDOWN,      0x00000C00
	.equ DISPLAY_TEST,  0x00000F00
	
.global main
