	.syntax unified
	.cpu cortex-m4
	.thumb
.data
	student_id: .byte 0,7,1,1,2,5,0
.text
	.global main
	.equ RCC_AHB2ENR,0x4002104C
	.equ GPIOA_MODER,0x48000000
	.equ GPIOA_OSPEEDR,0x48000008
	.equ GPIOA_ODR,0x48000014
    .equ GPIOA_BSRR,0x48000018
	.equ GPIOA_BRR,0x48000028
	.equ DIN,0b00100000
	.equ CS,0b01000000
	.equ CLK,0b10000000
	.equ DECODE_MODE,0b100100000000
	.equ INTENSITY,0b101000000000
	.equ SCAN_LIMIT,0b101100000000
	.equ SHUTDOWN,0b110000000000
	.equ DISPLAY_TEST,0b111100000000
	.equ delay,3999995

main:
    BL GPIO_init
    BL max7219_init
    mov r11,0
    mov r10,7

LOOP:
    ldr r1,=student_id
    ldrb r1, [r1,r11]
    mov r0,r10,lsl #8
    BL MAX7219Send

    add r11,r11,1
    sub r10,r10,1
    cmp r11,7
    bne LOOP

    ldr r0,=0b100000000000
    mov r1,15
    BL MAX7219Send
Program_end:
    B Program_end

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

MAX7219Send:

    add r0,r0,r1
    mov r12,16
    mov r7,0b1000000000000000

    ldr r2,=DIN
    ldr r3,=CS
    ldr r4,=CLK
    ldr r5,=GPIOA_BSRR
    ldr r6,=GPIOA_BRR

    LOOP1:
        str r4,[r6]

        and r1,r0,r7
        cmp r1,0
        beq ZERO
        str r2,[r5]
        b DONE
    ZERO:
        str r2,[r6]
    DONE:

        str r4,[r5]

        lsr r7,r7,1
        sub r12,r12,1
        cmp r12,0
        bne LOOP1

        str r3,[r6]
        str r3,[r5]
BX LR

max7219_init:

push {LR}

    ldr r0,=#DECODE_MODE    // set Mode = No decode for digit 7-0
    ldr r1,=#0b11111111
    BL MAX7219Send

    ldr r0,=#DISPLAY_TEST   // set TEST = Normal Operation
    ldr r1,=#0x0
    BL MAX7219Send

    ldr r0,=#SCAN_LIMIT     // Use only 6 DIGIT of 7-segment
    ldr r1,=#0x7
    BL MAX7219Send

    ldr r0,=#INTENSITY      // set intensity range(0,15)
    ldr r1,=#0xA
    BL MAX7219Send

    ldr r0,=#SHUTDOWN       // set ShutDown = Normal Operation
    ldr r1,=#0x1
    BL MAX7219Send

pop {LR}

BX LR
