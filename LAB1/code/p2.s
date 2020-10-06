  .syntax unified
  .cpu cortex-m4
.thumb
.text
.global main
.equ N, 20

fib:
    cmp R0,#100
    bgt OVER //>
    cmp R0,#0
    blt OVER //<
LOOP:
     cmp R0,#0
     beq EXIT
     cmp R0,#1
     beq ONE

     sub R0,R0,1
     add R4,R2,R1
     cmp R4,#0
     ble FLOW //<=
     mov R1,R2
     mov R2,R4

     cmp R0,#1 //r0=1 return
     beq EXIT
     b LOOP
FLOW:
    mov R4,(-2)
    b EXIT
OVER:
    mov R4,(-1)
    b EXIT
ONE:
    mov R4,1
    b EXIT
EXIT:
    bx lr

main:
    movs R0,#N
    movs R1,#0
    movs R2,#1
    movs R4,#0
    bl fib

nop
L: b L
