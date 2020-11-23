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

	.equ DIN,0b000000010 // DIN <===> pc1
	.equ CS,0b000000100  // CS  <===> pc2
	.equ CLK,0b000001000 // CLK <===> pc3

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

.global GPIO_init
.global MAX7219Send
.global max7219_init
.global MUTIDISPLAY
.global DELAY

GPIO_init:

	// open BUS
	mov R0,#0b100 	// 100
	ldr R1,=RCC_AHB2ENR
	str R0,[R1]

	// set mode
	// 00: input 	mode
	// 01: output 	mode
	// 10: function mode
	// 11: analog 	mode
	mov R0,#0b01010101
	ldr R1,=GPIOC_MODER     // PC0  as output mode
	str R0,[R1]				// PC13 as input  mode

	// set output register
	mov R0,#0b0
	ldr R1,=GPIOC_ODR
	str R0,[R1]

	//set input register
	mov R0,#0b0
	ldr R1,=GPIOC_IDR
	str R0,[R1]

	//set BSRR
	//0: No action on the corresponding ODx bit
	//1: Sets the corresponding ODx bit


	//set BSR
	//0: No action on the corresponding ODx bit
	//1: Reset the corresponding ODx bit

	//set OSPEEDR
	//00: low speed
	//01: medium speed
	//10: high speed
	//11: very high speed

	//set PUPDR
	//00: no pull-up pull-down
	//01: pull-up	default:1 press:0
	//10: pull-down default:0 press:1
	//11: reserved
	mov R0,#0b0100000000000000000000000000
	ldr R1,=GPIOC_PUPDR
	str R0,[R1]

	BX LR

max7219_init:
    push {LR}

    // no decode for digit 7-0 :                        0x00
    // code b for digit 0   & decode for digit 7-1 :    0x1 (00000001)
    // code b for digit 3-0 & decode for digit 7-4 :    0xF (00001111)
    // code b decode for digit 7-0:                     0xFF(11111111)
    ldr r0,=#DECODE_MODE    // set Mode = No decode for digit 7-0
    ldr r1,=#0xFF
    BL MAX7219Send


    // SHUTDOWN: 0x0C00
    // DATA:
    // 0 : Shutdown mode    0x00 (00000000)
    // 1 : Normal Operation 0x01 (00000001)
    ldr r0,=#SHUTDOWN       // set ShutDown = Normal Operation
    ldr r1,=#0x1
    BL MAX7219Send

    // SCAN_LIMIT: 0x0B00
    // DATA:
    // display digit 0          000(0x00)
    // digplay digit 10         001(0x01)
    // display digit 210        010(0x02)
    // display digit 3210       011(0x03)
    // display digit 43210      100(0x04)
    // display digit 543210     101(0x05)
    // display digit 6543210    110(0x06)
    // display digit 76543210   111(0x07)
    ldr r0,=#SCAN_LIMIT     // Use only 1 DIGIT of 7-segment
    ldr r1,=0x7
    BL MAX7219Send

    // INTENSITY: 0x0A00
    // DATA:
    // more light: 0x00 ~ 0x0F
    ldr r0,=#INTENSITY      // set intensity range(0,15)
    ldr r1,=#0xA
    BL MAX7219Send

    // DISPLAY: 0x0F00
    // DATA:
    // 0: Normal Operation  0x00000000
    // 1: Display Test Mode 0x00000001
    ldr r0,=#DISPLAY_TEST   // set TEST = Normal Operation
    ldr r1,=#0x0
    BL MAX7219Send

    pop {LR}
BX LR

// parameter : r0(address)(should shift <<8), r1(data)
// DIN <===> pc1    // ############ NEED CHANGE #############
// CS  <===> pc2    // ############ NEED CHANGE #############
// CLK <===> pc3    // ############ NEED CHANGE #############
// * pa5 pa6 pa7 should be output mode in GPIO_init
MAX7219Send:
	push {r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,lr}
    add r0,r0,r1
    mov r12,16
    mov r7,0b1000000000000000 //bitmask

    ldr r2,=DIN
    ldr r3,=CS
    ldr r4,=CLK
    ldr r5,=GPIOC_BSRR  // ############ NEED CHANGE #############
    ldr r6,=GPIOC_BRR   // ############ NEED CHANGE #############

    LOOP1:
        str r4,[r6]     // set clk = 0

        and r1,r0,r7
        cmp r1,0
        beq ZERO
        str r2,[r5]     // set DIN as 1
        b DONE
    ZERO:
        str r2,[r6]     // set DIN as 0
    DONE:
        str r4,[r5]     // set clk = 1

        lsr r7,r7,1
        sub r12,r12,1
        cmp r12,0
        bne LOOP1

        str r3,[r6]     // set CS as 0
        str r3,[r5]     // set CS as 1
	pop {r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,lr}
	BX LR

MUTIDISPLAY:
	push {r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,lr}
	mov r3,0
	mov r12,r0

	MUTLISTART:
	mov r4,10
	udiv r8,r12,r4  // r8=r4/10
	mul  r6,r8,r4  	// r6=r8*10
	sub  r9,r12,r6  // r8:remainder

	add r3,r3,1
	mov r6,r3,lsl #8
	mov r0,r6       // r0:address
	mov r1,r9       // r1:data
	BL MAX7219Send
	
	cmp R8,0
	IT ne
	movne r12,r8
	bne MUTLISTART

	NOT_DONE:
	cmp R3,#8
	beq DONE2
	
	add r3,r3,1
	mov r6,r3,lsl #8
	mov r0,r6
	mov r1,0xf
	BL MAX7219Send
	B NOT_DONE

	DONE2:
	pop {r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,lr}
	bx lr

// remember delay_time should be define
DELAY:
	ldr R4,=DELAY_TIME
	DELAY_LOOP:
		sub R4,R4,#5
		cmp R4,#0
		BGT DELAY_LOOP
		bx lr