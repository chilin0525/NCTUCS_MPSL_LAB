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
	.equ delay_time, 4000000

main:
    BL GPIO_init
    MOVS R1, #1
    LDR R0, =leds
    STRB R1, [R0]

Loop:
    /* TODO: Write the display pattern into leds variable */
    BL DisplayLED
    BL Delay
    B Loop

GPIO_init:
    /* TODO: Initialize LED GPIO pins as output */
    // Enable AHB2 clock
    mov r0,#0x2
	ldr r1, =RCC_AHB2ENR
	str r0, [r1]

    // Set pins (Ex. PB3-6) as output mode
    mov r0,#0x00001540
    ldr r1,=GPIOB_MODER
    str r0,[r1]

    // Keep PUPDR as the default value(pull-up).
    mov r0,#0x00003F60
    ldr r1,=GPIOB_PUPDR
    str r0,[r1]

    // Set output speed register
    // medium speed 01
    mov r0,#0x00003F60
    ldr r1,=GPIOB_OSPEEDR
    str r0,[r1]

    BX LR

DisplayLED :
    ldr r6,=leds
    ldr r3,=GPIOB_ODR
    ldr r2,[r6]
    cmp r2,#1
    beq state1
    cmp r2,#2
    beq state2
    cmp r2,#3
    beq state3
    cmp r2,#4
    beq state4
    cmp r2,#5
    beq state5
    cmp r2,#6
    beq state6
    cmp r2,#7
    beq state7
    cmp r2,#8
    beq state8

state1:
    mov r4,0x000000F7
    str r4,[r3]
    mov r5,#2
    str r5,[r6]
    bx lr
state2:
    mov r4,0x000000E7
    str r4,[r3]
    mov r5,#3
    str r5,[r6]
    bx lr
state3:
    mov r4,0x000000CF
    str r4,[r3]
    mov r5,#4
    str r5,[r6]
    bx lr
state4:
    mov r4,0x0000009F
    str r4,[r3]
    mov r5,#5
    str r5,[r6]
    bx lr
state5:
    mov r4,0x000000BF
    str r4,[r3]
    mov r5,#6
    str r5,[r6]
    bx lr
state6:
    mov r4,0x0000009F
    str r4,[r3]
    mov r5,#7
    str r5,[r6]
    bx lr
state7:
    mov r4,0x000000CF
    str r4,[r3]
    mov r5,#8
    str r5,[r6]
    bx lr
state8:
    mov r4,0x000000E7
    str r4,[r3]
    mov r5,#1
    str r5,[r6]
    bx lr

Delay:
/* TODO: Write a delay 1 sec function */
// You can implement this part by busy waiting.
// Timer and Interrupt will be introduced in later lectures.
    ldr r12,=delay_time
busy_waiting:
    sub r12,r12,#5
    cmp r12,#0
    bgt busy_waiting
    bx lr
