DEBOUNCE:
	// pre set R7，R8，R9 as 0
	ldr R6,=GPIOC_IDR
	ldr R6,[R6]
	and R6,R6,#0b10000000000000

	cmp R6,#0b10000000000000
	IT eq
	moveq R7,0

	cmp R6,0
	IT eq
	addeq R7,1

	cmp R7,#1000
	IT eq
	moveq R8,1

	cmp R8,#0 
	IT eq
	bxeq lr

	cmp R6,#0b10000000000000
	IT eq
	moveq R9,#1

	cmp R9,#1
	ITTTT EQ
	moveq R7,#0
	moveq R8,#0
	moveq R9,#0
	bxeq lr

	B DEBOUNCE

// 	read_input
//    	input==0:
//        	input_1=0;
//		input==1:
//			input_1++;
//		if(input>1000 && input==0){
//			input_1 = 0
//		} else {
//			return 
//		}