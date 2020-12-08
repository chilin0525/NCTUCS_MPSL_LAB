#include "stm32l476xx.h"
#define ADD_PWM (uint32_t)200
#define MIN_PWM (uint32_t)400
#define MAX_PWM (uint32_t)3600

extern void max7219_init();
extern void MAX7219Send(int address,int data);
extern void MUTIDISPLAY();

int UART1_Transmit(uint8_t *arr, uint32_t size) {
//TODO: Send str to UART and return how many bytes are successfully
//transmitted.
}

void UART1_init() {
	RCC->APB2ENR |= RCC_APB2ENR_USART1EN;

	// CR1
	USART1->CR1 = (USART_CR1_TE | USART_CR1_RE);

	// baud rate
	// 4M = 4000000
	USART1->BRR = 4000000;

	// CR2
	// 1 stop bit
	USART1->CR2 = 0;

	// CR3
	

	// Uart Enable 
	USART1->CR1 |= USART_CR1_UE;
}

void GPIO_init(){
	RCC->AHB2ENR |= 0x7;

	GPIOA->MODER = 0b1111;  	
	// PC0 , PC1
	// pc13 as btn

	GPIOA->AFR[0] |= 0x00100000;
}

int main(){
	GPIO_init();
	UART1_init();

	while(1){
		if((GPIOC->IDR | 0b10000000000000) == 0){
			UART1_Transmit();
		}
	}

    return 0;
}
