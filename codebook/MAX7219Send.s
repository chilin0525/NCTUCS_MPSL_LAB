// parameter : r0(address)(should shift <<8), r1(data)
// DIN <===> pa5    // ############ NEED CHANGE #############
// CS  <===> pa6    // ############ NEED CHANGE #############
// CLK <===> pa7    // ############ NEED CHANGE #############
// * pa5 pa6 pa7 should be output mode in GPIO_init
MAX7219Send:
    add r0,r0,r1
    mov r12,16
    mov r7,0b1000000000000000 //bitmask

    ldr r2,=DIN
    ldr r3,=CS
    ldr r4,=CLK
    ldr r5,=GPIOA_BSRR  // ############ NEED CHANGE #############
    ldr r6,=GPIOA_BRR   // ############ NEED CHANGE #############

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