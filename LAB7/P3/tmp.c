#include "stm32l476xx.h"
#define ADD_PWM (uint32_t)200
#define MIN_PWM (uint32_t)400
#define MAX_PWM (uint32_t)3600

int keypad_value[4][4] = {
        {1, 2, 3, 10},
        {4, 5, 6, 11},
        {7, 8, 9, 12},
        {15, 0, 14, 13}
    };
int flag[4][4] = {0};

// pull-up: no:1 push:0
void keypad_init(){
    RCC -> AHB2ENR = 0x7;
    // 00 input mode
    // 01 output mode
    // 10 function mode
    // 11 analog

    // GPIOA5 as ouput mode
    GPIOA -> MODER = 0b010000000000;
	GPIOA -> ODR = 0;

	// set as PULL-DOWN
	//set PUPDR
	//00: no pull-up pull-down
	//01: pull-up
	//10: pull-down
	//11: reserved

    // GPIOB -> MODER = GPIOB -> MODER & 0x0;
    GPIOB -> MODER = 0x0;
    // GPIOB -> PUPDR = GPIOB -> PUPDR | 0b00000000111111;
    // clear
    GPIOB -> PUPDR = 0b10101010000000; // pull-dowm mode
	// default 0
	// Set 1
    GPIOB -> IDR = 0;
    /*
    //  pb3-6 : input
    //  X0 == pb6 == pin4 == col1
    //  X1 == pb5 == pin3 == col2
    //  X2 == pb4 == pin2 == col3
    //  X3 == pb3 == pin1 == col4
    */
   	// PB3456 as External Interrupt
	// EX3 4 5 6 

    GPIOC -> MODER = 0b000001010101;
    GPIOC -> ODR = 0;
    /*
    //  pc0-3 : output to test
    //  Y0 == pc0 == pin8 == row1
    //  Y1 == pc1 == pin7 == row2
    //  Y2 == pc2 == pin6 == row3
    //  Y3 == pc3 == pin5 == row4
    */
}

void EXTI_config(){
	RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN;
//  __IO uint32_t EXTICR[4];   /*!< SYSCFG external interrupt configuration registers, Address offset: 0x08-0x14 */
	//SYSCFG->EXTICR[0] &= ~SYSCFG_EXTICR1_EXTI3;
	SYSCFG->EXTICR[0] |= SYSCFG_EXTICR1_EXTI3_PB;
	//SYSCFG->EXTICR[1] &= ~SYSCFG_EXTICR2_EXTI4;
	SYSCFG->EXTICR[1] |= SYSCFG_EXTICR2_EXTI4_PB;
	SYSCFG->EXTICR[1] |= SYSCFG_EXTICR2_EXTI5_PB;
	SYSCFG->EXTICR[1] |= SYSCFG_EXTICR2_EXTI6_PB;
	// Choose PB3456 as External Internal 

	EXTI->RTSR1 |= EXTI_RTSR1_RT3;
	EXTI->RTSR1 |= EXTI_RTSR1_RT4;
	EXTI->RTSR1 |= EXTI_RTSR1_RT5;
	EXTI->RTSR1 |= EXTI_RTSR1_RT6;
	// Rising Trigger Selection Register
	// 0 : disable
	// 1 : disable

	EXTI->IMR1 |= EXTI_IMR1_IM3;
	EXTI->IMR1 |= EXTI_IMR1_IM4;
	EXTI->IMR1 |= EXTI_IMR1_IM5;
	EXTI->IMR1 |= EXTI_IMR1_IM6;
	// Interrupt Mask Register
	// 0 : marked 
	// 1 : not masked

	EXTI->PR1 |= EXTI_PR1_PIF3 | EXTI_PR1_PIF4 | EXTI_PR1_PIF5 | EXTI_PR1_PIF6;
}

void NVIC_config(){

	NVIC_EnableIRQ(EXTI9_5_IRQn);
	NVIC_EnableIRQ(EXTI3_IRQn);
	NVIC_EnableIRQ(EXTI4_IRQn);
	// enable EXTI5 to NVIC
	/*
	__STATIC_INLINE void NVIC_EnableIRQ(IRQn_Type IRQn)
	{
	NVIC->ISER[(((uint32_t)(int32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)(int32_t)IRQn) & 0x1FUL));
	}
	*/
}

void EXTI3_IRQHandler(void){
	WORK();
	EXTI->PR1 |= EXTI_PR1_PIF3;
}

void EXTI4_IRQHandler(void){
	WORK();
	EXTI->PR1 |= EXTI_PR1_PIF4;
}

void EXTI9_5_IRQHandler(void){
	WORK();
	EXTI->PR1 |= EXTI_PR1_PIF5 | EXTI_PR1_PIF6;
}

void DELAY(){
	int i=500000;
	while(i){i-=8;}
}

void WORK(){
	int i=0,j=0;
	int sum = 0;
	for(i=0;i<4;i++){
		for(j=0;j<4;j++){
			flag[i][j] = 0;
		}
	}
	
	for(i=0;i<4;i++){
		GPIOC -> ODR = (1 << i) ;
		for(j=0;j<4;j++){
			int tmp = GPIOB -> IDR & 0b1111000;
			if( (tmp >> (6-j)) & 0x1){
				sum += keypad_value[i][j];
				flag[i][j] = 1;
			}
		}
	}

	if(sum!=0){
        GPIOA->ODR ^= 0b100000;     // close LED

		Timer_start(100000*sum);
        while(!(TIM2->SR & 0x00000001)){}
        TIM2->SR &= 0xFFFFFFFE;

        GPIOA->ODR ^= 0b100000; 
	}
}

void SystemClock_Config(){
	RCC->CR |= 0x100;
	//turn on HSI16

	RCC->CFGR |= 1;
	// 01: HSI16 selected as system clock

	RCC->CFGR |= 0xB0;
	// prescaler 16
	// HENCE: 16M / 16 = 1M
	/*
	0xxx: SYSCLK not divided
	1000: SYSCLK divided by 2
	1001: SYSCLK divided by 4
	1010: SYSCLK divided by 8
	1011: SYSCLK divided by 16
	1100: SYSCLK divided by 64
	1101: SYSCLK divided by 128
	1110: SYSCLK divided by 256
	1111: SYSCLK divided by 512
	*/
}

int STATE = 0;
void SysTick_Handler(void) {
	//EXTI->IMR1 |= EXTI_PR1_PIF3 ;
	
    //EXTI->SWIER1 |= EXTI_PR1_PIF3 | EXTI_PR1_PIF4 | EXTI_PR1_PIF5 | EXTI_PR1_PIF6;
        
    if(STATE==0){
        GPIOC->ODR = 0b0001;
        ++STATE;
    } else if(STATE==1) {
        GPIOC->ODR = 0b0010;
        ++STATE;
    } else if(STATE==2) {
        GPIOC->ODR = 0b0100;
        ++STATE;
    } else {
        GPIOC->ODR = 0b1000;
        STATE = 0;
    }
}

void Timer_start(int TIME){
    TIM2->ARR = TIME;
    TIM2->EGR = 0x0001;         // re init cnt
    TIM2->SR &= 0xFFFFFFFE;     // set to 0
    TIM2->CR1 |= 0x00000001;    // enable counter
}

void Timer_init(){
    RCC->APB1ENR1 |= RCC_APB1ENR1_TIM2EN;   // enable TIM2
    TIM2->CR1 = 0;                          // upcounter, disable counter, enable UEV(update event)
    TIM2->CNT = 0;
    TIM2->PSC = (uint32_t)9;                // 1M == 1000000/10 = 100000
    TIM2->ARR = (uint32_t)99999;
}

int main(){
	EXTI_config();
	NVIC_config();
    keypad_init();
	SystemClock_Config();
	Timer_init();
    SysTick_Config(100000);
	
	GPIOA->ODR = 0b100000; 
    //while (1){}

    return 0;
}
