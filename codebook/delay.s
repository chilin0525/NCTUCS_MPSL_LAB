// remember delay_time should be define
DELAY:
	ldr R4,=DELAY_TIME
	DELAY_LOOP:
		sub R4,R4,#5
		cmp R4,#0
		BGT DELAY_LOOP
		bx lr