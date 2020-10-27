    .syntax unified
	.cpu cortex-m4
	.thumb
.data
	arr: .byte 0x7E, 0x30, 0x6D, 0x79, 0x33, 0x5B, 0x5F, 0x72, 0x7F, 0x7B, 0x77, 0x1F, 0x4E, 0x3D, 0x4F, 0x47
.text
	.global main
	.equ RCC_AHB2ENR,0x4002104C
	.equ GPIOA_MODER,0x48000000
	.equ GPIOA_OSPEEDR,0x48000008
	.equ GPIOA_ODR,0x48000014
    .equ GPIOA_BSRR,0x48000018
	.equ GPIOA_BRR,0x48000028

	.equ DIN,0b00100000 // DIN <===> pa5
	.equ CS,0b01000000  // CS  <===> pa6
	.equ CLK,0b10000000 // CLK <===> pa7
	
    .equ DECODE_MODE,0b100100000000
	.equ INTENSITY,0b101000000000
	.equ SCAN_LIMIT,0b101100000000
	.equ SHUTDOWN,0b110000000000
	.equ DISPLAY_TEST,0b111100000000
	.equ delay,3999995

main:
    BL GPIO_init
    BL max7219_init
    mov r11,0           // r11 : Index for display

loop:                   // Display Loop
    BL DisplayDigit
    BL Delay
    B loop

GPIO_init:
    mov r0,1                    // Open BUS for port A
    ldr r1,=RCC_AHB2ENR
    str r0,[r1]

    ldr r0,=0b11111111111111110101011111111111
    ldr r1,=GPIOA_MODER         // set pa5 pa6 pa7 = 01 (output mode)
    str r0,[r1]

    mov r0,0b1010100000000000   // set speed = medium speed
    ldr r1,=GPIOA_OSPEEDR
    str r0,[r1]

    mov r0,0                    // set output register = 0
    ldr r1,=GPIOA_ODR
    str r0,[r1]

    BX LR


DisplayDigit:
    push {LR}

    ldr r1,=arr             // set r1 -> arr[0]
    ldrb r1, [r1,r11]       // load r1[r11] to r1

    mov r0, 0b000100000000  // set r0 = Digit 0 (r8-r15:1 r0-r7:0)
    BL MAX7219Send      

    add r11,r11,1   // if(r11>=16) reset
    cmp r11,16
    it eq
    moveq r11,0

    pop {LR}
BX LR


MAX7219Send:
    add r0,r0,r1
    mov r12,16
    mov r7,0b1000000000000000 //bitmask

    ldr r2,=DIN
    ldr r3,=CS
    ldr r4,=CLK
    ldr r5,=GPIOA_BSRR
    ldr r6,=GPIOA_BRR

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
BX LR

max7219_init:
    push {LR}

    ldr r0,=#DECODE_MODE    // set Mode = No decode for digit 7-0
    ldr r1,=#0x0
    BL MAX7219Send

    ldr r0,=#DISPLAY_TEST   // set TEST = Normal Operation
    ldr r1,=#0x0
    BL MAX7219Send

    ldr r0,=#SCAN_LIMIT     // Use only 1 DIGIT of 7-segment
    ldr r1,=0x0
    BL MAX7219Send

    ldr r0,=#INTENSITY      // set intensity range(0,15)
    ldr r1,=#0xA
    BL MAX7219Send

    ldr r0,=#SHUTDOWN       // set ShutDown = Normal Operation
    ldr r1,=#0x1
    BL MAX7219Send

    pop {LR}
BX LR

Delay:              // Busy waiting
    ldr r12,=delay

    LOOP2:
        sub r12,r12,5
        cmp r12,0
        bgt LOOP2
BX LR
