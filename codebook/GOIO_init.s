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
	ldr R1,=GPIOC_MODER
	str R0,[R1]

	// set output register
	mov R0,#0b0
	ldr R1,=GPIOC_ODR
	str R0,[R1]

	//set input register

	//set BSRR
	//0: No action on the corresponding ODx bit
	//1: Sets the corresponding ODx bit
	mov R0,#0b1111
	ldr R1,=GPIOC_BSRR
	str R0,[R1]

	//set BSR
	//0: No action on the corresponding ODx bit
	//1: Reset the corresponding ODx bit
	mov R0,#0b1110
	ldr R1,=GPIOC_BSR
	str R0,[R1]

	//set OSPEEDR
	//00: low speed
	//01: medium speed
	//10: high speed
	//11: very high speed

	//set PUPDR
	//00: no pull-up pull-down
	//01: pull-up
	//10: pull-down
	//11: reserved

	BX LR
