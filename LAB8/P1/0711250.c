#include "stm32l476xx.h"

char str[] = "Hello World!";

void GPIO_init(){
	RCC->AHB2ENR |= RCC_AHB2ENR_GPIOAEN | RCC_AHB2ENR_GPIOCEN;
	// Enable PA PC clock
	GPIOA->MODER = (GPIOA->MODER & 0xFFC3FFFF) | 0x280000;
	// 

	GPIOA->AFR[1] = (GPIOA->AFR[1] & 0xFFFFF00F) | 0x770;
	// config PA AFR[1] as anoher function mode 
	// pa9 pa10 set as USART mode

	GPIOC->MODER = (GPIOC->MODER & 0xF3FFFFFF);
	// pc13 as input
	GPIOC->OSPEEDR = 0x800; 
	GPIOC->PUPDR = 0xAA;
}

void init_UART(){
	RCC->APB2ENR |= RCC_APB2ENR_USART1EN;
	USART1->BRR = 26<<4;
	USART1->CR1 |= USART_CR1_TE;
	USART1->CR1 |= USART_CR1_UE;
}

void delay(){
	int count=0;
	while(1){
	  if(GPIOC->IDR==0){count=0;}
	  else {count++;}

	  if(count>=500){return;}
	}
}

int main(){
	GPIO_init();
	init_UART();
	int i;

	while(1){
		if(GPIOC->IDR==0){
			for(i=0;str[i];i++){
				USART1->TDR = str[i];
				while(!(USART1->ISR & USART_ISR_TXE));
		    }
			delay();
		}
	}
	return 0;
}
