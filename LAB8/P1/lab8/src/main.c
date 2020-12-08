#include "stm32l476xx.h"
#define ADD_PWM (uint32_t)200
#define MIN_PWM (uint32_t)400
#define MAX_PWM (uint32_t)3600

extern void max7219_init();
extern void MAX7219Send(int address,int data);
extern void MUTIDISPLAY();

void UART2_Transmit(char* data) {
	while(*data){
		UART2_Tra(*data++);
	} 
}

void UART2_Tra(char data){
	while(!(USART2->ISR & USART_ISR_TXE)){;}
	USART2->TDR = data;
}

void UART2_init() {
	RCC->APB1ENR1 |= RCC_APB1ENR1_USART2EN;

	// CR1
	USART2->CR1 &= ~(USART_CR1_M | USART_CR1_PS | USART_CR1_PCE | USART_CR1_TE | USART_CR1_OVER8);
	USART2->CR1 |= (USART_CR1_TE | USART_CR1_RE) ;

	// baud rate
	// 4M = 4000000
	USART2->BRR = 4000000/9600;

	// CR2
	// 1 stop bit
	USART2->CR2 = 0;
 	//USART2->CR2 = (USART2->CR2 & ~(USART_CR2_STOP_Msk)) | (0 /*1 stop bit*/);

	// Uart Enable 
	USART2->CR1 |= USART_CR1_UE;
}

void GPIO_init(){
	RCC->AHB2ENR |= 0x7;

	GPIOA->MODER = 0b10100000; 
	// change to AF mode

	GPIOA->AFR[0] = 0x00007700;

	GPIOC->MODER = 0b01;
	// pa2 , pa3
	// pc13 as btn
	
}

int DEBOUNCE(){
    int i = 1;
    int press_cnt = 0;
    int press_flag = 0;
    int press_loose_flag = 0;

    for(i=1;i<=1000;i++){
        int check_press = GPIOC -> IDR & 0b10000000000000;
        if(check_press != 0){   // not press?
            press_cnt = 0;
        } else {                // press?
            ++press_cnt;
        }

        if(press_cnt >= 300){
            press_flag = 1;
            break;
        }
    }

    if(press_flag){
        while(1){
            int check_press = GPIOC -> IDR & 0b10000000000000;
            if(check_press != 0){
                break;
            }
        }
    } else {
        return 0;   // not press
    }

    return 1;   // press
}

int main(){
	GPIO_init();
	UART2_init();

	char* Str = "\015Hello World!3\n\015";
	GPIOC->ODR = 0;

	while(1){
		// check pc13
		//if((GPIOC->IDR & 0b10000000000000) == 0){
		if(DEBOUNCE() == 1){
			GPIOC->ODR = GPIOC->ODR ^ 1;
			UART2_Transmit(Str);
		}
	}

    return 0;
}

