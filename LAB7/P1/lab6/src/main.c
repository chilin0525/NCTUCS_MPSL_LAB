#include "stm32l476xx.h"

void GPIO_init(){

	RCC->AHB2ENR = 0b1;

	GPIOA->MODER = 0b010000000000;

	GPIOA->ODR = 0;
	// set output register to 1

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

void SysTick_Handler(void) {
	GPIOA->ODR ^= 0b100000;
}

int main(){
	GPIO_init();
	SystemClock_Config();
	SysTick_Config(3*1000000);
	// 3s = 1M/1M *3
	
	while (1);

}

