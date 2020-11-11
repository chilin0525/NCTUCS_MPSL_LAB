	.syntax unified
	.cpu cortex-m4
	.thumb
.text
    .global max7219_send
    .global max7219_init
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

max7219_send:                    // r0:address r1:data
    push {r0,r1,r2,r3,r4,r5,r6,r7,r12,lr}
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
        str r2,[r5]             // if DIN = 1
        b DONE
    ZERO:                       // if DIN = 0
        str r2,[r6]
    DONE:
        str r4,[r5]

        lsr r7,r7,1
        sub r12,r12,1
        cmp r12,0
        bne LOOP1

        str r3,[r6]
        str r3,[r5]
    pop {r0,r1,r2,r3,r4,r5,r6,r7,r12,lr}
BX LR

// DIN <==> PA5
// CS  <==> PA6 
// CLK <==> PA7

max7219_init:
    push {r0,r1,LR}

    ldr r0,=#DECODE_MODE    // set Mode = No decode for digit 7-0
    ldr r1,=#0b11111111     // all code B
    BL max7219_send

    ldr r0,=#DISPLAY_TEST   // set TEST = Normal Operation
    ldr r1,=#0x0
    BL max7219_send

    ldr r0,=#SCAN_LIMIT     // Use only 6 DIGIT of 7-segment
    ldr r1,=#0x1
    BL max7219_send

    ldr r0,=#INTENSITY      // set intensity range(0,15)
    ldr r1,=#0xA
    BL max7219_send

    ldr r0,=#SHUTDOWN       // set ShutDown = Normal Operation
    ldr r1,=#0x1
    BL max7219_send

    pop {r0,r1,LR}
BX LR
