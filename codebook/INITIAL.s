INITIAL:
	push {LR}

	mov R1,0xF
	ldr R0,=DIGIT0
	BL MAX7219Send

	mov R1,0xF
	ldr R0,=DIGIT1
	BL MAX7219Send

	mov R1,0xF
	ldr R0,=DIGIT2
	BL MAX7219Send

	mov R1,0xF
	ldr R0,=DIGIT3
	BL MAX7219Send

	mov R1,0xF
	ldr R0,=DIGIT4
	BL MAX7219Send

	mov R1,0xF
	ldr R0,=DIGIT5
	BL MAX7219Send

	mov R1,0xF
	ldr R0,=DIGIT6
	BL MAX7219Send

	mov R1,0xF
	ldr R0,=DIGIT7
	BL MAX7219Send

	POP {LR}
	bx LR