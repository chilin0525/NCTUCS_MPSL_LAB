	.syntax unified
	.cpu cortex-m4
	.thumb
.text
	.global main
	.equ RCC_AHB2ENR,0x4002104C
	.equ GPIOA_MODER,0x48000000
	.equ GPIOA_OSPEEDR,0x48000008
	.equ GPIOA_ODR,0x48000014
	.equ DIN,0b00100000
	.equ CS,0b01000000
	.equ CLK,0b10000000
	.equ DECODE_MODE,0b100100000000
	.equ INTENSITY,0b101000000000
	.equ SCAN_LIMIT,0b101100000000
	.equ SHUTDOWN,0b110000000000
	.equ DISPLAY_TEST,0b111100000000
	.equ GPIOA_BSRR,0x48000018
	.equ GPIOA_BRR,0x48000028
	.equ delay,3999995
	.equ GPIOC_MODER,0x48000800
	.equ GPIOC_ODR,0x48000810

main:
    BL GPIO_init
    BL max7219_init
    mov r12,0   //r12:index,the answer now is (r12)'th fibonacci

LOOP:
    BL POLL
    BL PRESS
    B LOOP

PRESS:
    push {LR}

    mov r9,0    //count when button is pressed,set to zero if button isn't pressed
    mov r8,0    //count when button isn't pressed,set to zero if button is pressed
    ldr r7,=200000  //r7:delay time period(if>200000,reset occurs)
    mov r6,0    //flag , set to 1 if button is pressed more than 1 sec , hence it is a reset flag
    LOOP1:

    ldr r10,=GPIOC_ODR
    ldr r10,[r10]
    and r10,r10,0b10000000000000

    cmp r10,0   //see if the button is pressed
    itt eq
    addeq r9,r9,#1
    moveq r8,0

    cmp r10,0b10000000000000    // see if the button isn't pressed
    itt eq
    addeq r8,r8,#1
    moveq r9,0

    //line 48-56 can solve ocsillating problems

    cmp r6,1//if flag=1,it is no need to do the following instructions because reset is dominating
    beq JUMP

    cmp r9,r7//to test whether the button has been pressed for more than 1 sec
    it eq
    moveq r6,1//set the flag to 1 if the button has been pressed for more than 1 sec

    cmp r6,0
    beq JUMP//don't reset if the flag=0
    //reset start
    ldr r0,=0b000100000000//set digit zero to number 0
    mov r1,0
    BL MAX7219Send

    mov r2,2//r2:counter
    LOOP_SET_ALL_DIGIT_TO_BLANK_EXCEPT_DIGIT1_1://set digit 1~7 to blank
    mov r0,r2
    lsl r0,#8
    mov r1,0x0F
    BL MAX7219Send
    add r2,r2,1
    cmp r2,9
    bne LOOP_SET_ALL_DIGIT_TO_BLANK_EXCEPT_DIGIT1_1

    mov r12,0//set index to 0
    //reset done

JUMP:
    cmp r8,1000
    ble LOOP1

    //end of loop1

    cmp r6,1
    beq OK1//reset mode no need for fib

    add r12,r12,1//add index

    cmp r12,40//over flow when index > 39
    it ge
    movge r12,40

    BL fib

    cmp r12,40
    it ge
    ldrge r4,=99999999//if index > 39,set answer to 99999999

    mov r7,10
    mov r3,0//r3:number of digit that is setting

    L1:
    udiv r8,r4,r7//r8=r4/10
    mul  r6,r8,r7//r6=r8*10
    sub  r8,r4,r6//r9:remainder

    add r3,r3,1
    mov r6,r3,lsl #8
    mov r0,r6   //r0:address
    mov r1,r8   //r1:data
    BL MAX7219Send


    udiv r4,r4,r7   //answer=answer/10
    cmp r4,0
    beq OK1

b L1

OK1:
    pop {LR}
    BX LR

POLL://copy from lab3

P1:
    ldr r0,=GPIOC_ODR
    ldr r1,[r0]
    and r1,r1,#0b10000000000000
    cmp r1,#0b10000000000000
    beq P1
    BX LR

fib:    //copy from lab1
    mov r0,r12//r0:counter,r12:index
    mov r4,0//r4:answer
    mov r2,0//r2,r3 are registers storing former results
    mov r3,1
    LOOPF:
    cmp r0,0
    beq ZERO1//branch if index=0
    cmp R0,#1
    beq ONE//branch if index=1

    sub R0,R0,1
    add R4,R3,R2
    mov R2,R3
    mov R3,R4
    cmp R0,#1
    beq EXIT
    b LOOPF
ONE:
    mov R4,1
    b EXIT
ZERO1:
    mov r4,0
EXIT:
    BX LR

GPIO_init:  //you should know what the following instrctions are doing
    mov r0,7
    ldr r1,=RCC_AHB2ENR
    str r0,[r1]

    ldr r0,=0b11111111111111110101011111111111
    ldr r1,=GPIOA_MODER
    str r0,[r1]

    mov r0,0b1010100000000000
    ldr r1,=GPIOA_OSPEEDR
    str r0,[r1]

    mov r0,0
    ldr r1,=GPIOA_ODR
    str r0,[r1]


    mov r0,#0xF3FFFFFF
    ldr r1,=GPIOC_MODER
    str r0,[r1]

    mov r0,#0b10000000000000
    ldr r1,=GPIOC_ODR
    str r0,[r1]

BX LR

MAX7219Send://send serial input to max7219

    push {r0,r1,r2,r3,r4,r5,r6,r7,r12}
    add r0,r0,r1//r0:address,r1:data,after adding,r0 will be serial input
    mov r12,16//r12:counter
    mov r7,0b1000000000000000//r7:used to compare whether n'th bit is 1 or not

    ldr r2,=DIN
    ldr r3,=CS
    ldr r4,=CLK
    ldr r5,=GPIOA_BSRR//set something to one
    ldr r6,=GPIOA_BRR//set somthing to zero

    LOOPS:

    str r4,[r6]//set clk to 0

    and r1,r0,r7//r1:n'th bit
    cmp r1,0//compare n'th bit is 1 or not
    beq BIT_IS_ZERO//branch if n'th bit is zero

    str r2,[r5]//set serial input to one
    b DONE
    BIT_IS_ZERO:
    str r2,[r6]//set serial input to zero
    DONE:

    str r4,[r5]//set clk to one , since max7219 reads input on positive edges

    lsr r7,r7,1
    sub r12,r12,1
    cmp r12,0
    bne LOOPS

    str r3,[r6]//set cs to one (to tell max7219 that serial input has completed)
    str r3,[r5]//set cs to zero

    pop {r12,r7,r6,r5,r4,r3,r2,r1,r0}

BX LR

max7219_init:
//r0:address,r1:data
    push {LR}

    ldr r0,=#DECODE_MODE
    ldr r1,=#0b11111111
    BL MAX7219Send

    ldr r0,=#DISPLAY_TEST
    ldr r1,=#0x0
    BL MAX7219Send

    ldr r0,=#SCAN_LIMIT
    ldr r1,=#0x7
    BL MAX7219Send

    ldr r0,=#INTENSITY
    ldr r1,=#0xA
    BL MAX7219Send

    ldr r0,=#SHUTDOWN
    ldr r1,=#0x1
    BL MAX7219Send

    mov r2,2//r2:counter
    LOOP_SET_ALL_DIGIT_TO_BLANK_EXCEPT_DIGIT1_2://set digit 1~7 to blank
    mov r0,r2
    lsl r0,#8
    mov r1,0x0F//0x0F implies all seven segments won't work
    BL MAX7219Send

    add r2,r2,1
    cmp r2,9
    bne LOOP_SET_ALL_DIGIT_TO_BLANK_EXCEPT_DIGIT1_2

    ldr r0,=0b000100000000//set digit zero to zero
    ldr r1,=0
    BL MAX7219Send

    pop {LR}

BX LR
