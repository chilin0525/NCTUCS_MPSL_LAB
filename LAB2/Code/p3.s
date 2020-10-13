  .syntax unified
  .cpu cortex-m4
  .thumb
.data
    result: .word 0
    max_size: .word 0
.text
    m: .word 3122712
    n: .word 46840680

GCD:
    cmp R0,#0 // a
    beq S1
    cmp R1,#0 // b
    beq S2

    and R4,R0,#1 // a mod 2
    and R5,R1,#1 // b mod 2
    orr R6,R4,R5 // logic or

    cmp R6,#0
    beq S3
    cmp R4,#0
    beq S4
    cmp R5,#0
    beq S5

    b S6 //else

S1:
    mov R3,R1
    BX LR
S2:
    mov R3,R0
    BX LR
S3:
    push {R0}
    push {R1}
    push {LR}
    mov R0,R0,LSR #1 // a>>1
    mov R1,R1,LSR #1 // b>>1
    BL GCD
    pop {LR}
    pop {R1}
    pop {R0}
    mov R7,#2
    mul R3,R3,R7
    BX LR
S4:
    push {R0}
    push {R1}
    push {LR}
    mov R0,R0,LSR #1 // a>>1
    BL GCD
    pop {LR}
    pop {R1}
    pop {R0}
    BX LR
S5:
    push {R0}
    push {R1}
    push {LR}
    mov R1,R1,LSR #1 // b>>1
    BL GCD
    pop {LR}
    pop {R1}
    pop {R0}
    BX LR
S6:             // else
    push {R0}
    push {R1}
    push {LR}
    cmp R0,R1
    blt ELSE    // R0<R1 a<b
    sub R0,R0,R1 //a>b abs(a-b)=a-b min(a,b)=b
    b DONE
ELSE: // for a<b
    mov R8,R0    // R8=a
    sub R0,R1,R0 // a=b-a
    mov R1,R8    // b=a
DONE:
    BL GCD
    pop {LR}
    pop {R1}
    pop {R0}
    BX LR

.global main

main:
    ldr R0,=m
    ldr R0,[R0]
    ldr R1,=n
    ldr R1,[R1]
    mov R3,#0
    BL GCD

ldr R7,=result
str R3,[R7]

nop
