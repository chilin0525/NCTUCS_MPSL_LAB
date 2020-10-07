  .syntax unified
  .cpu cortex-m4
.thumb
.data
   arr1: .word 0x19, 0x34, 0x14, 0x32, 0x52, 0x23, 0x61, 0x29
   arr2: .word 0x18, 0x17, 0x33, 0x16, 0xFA, 0x20, 0x55, 0xAC
.text
   .global main

do_sort:
    mov R1,#8 // i

    LOOP1:
        sub R1,R1,1
        mov R3,R1
        mov R2,#0
        mov R4,R0

        LOOP2:
            sub R3,R3,1

            ldr R5,[R4]
            ldr R6,[R4,#4]
            cmp R5,R6
            blt DONE    //  <
            mov R7,R5   //  R5>=R6
            mov R5,R6
            mov R6,R7

        DONE:
            str R5,[R4]
            str R6,[R4,#4]
            add R4,R4,#4
            cmp R3,#0
            beq EXIT1
            b LOOP2

    EXIT1:
        cmp R1,#1
        beq EXIT
        b LOOP1

EXIT:
    bx lr

main:
    ldr r0, =arr1
    bl do_sort

    ldr r0, =arr2
    bl do_sort
nop

L: b L
