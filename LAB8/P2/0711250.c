#include "stm32l476xx.h"

int voltage;
void SysTick_Handler() {
    ADC1->CR |= ADC_CR_ADSTART;                     
	// start adc conversion
}

void ADC1_2_IRQHandler() {
	while (!(ADC1->ISR & ADC_ISR_EOC));             
	// wait for conversion complete
	voltage = (int) ADC1->DR;
}

void GPIO_init() {
    RCC->AHB2ENR |= RCC_AHB2ENR_GPIOAEN;
    GPIOA->MODER = (GPIOA->MODER & 0xFFC3FFFF) | 0x280000;
    GPIOA->AFR[1] = (GPIOA->AFR[1] & 0xFFFFF00F) | 0x770;
	// pa9 pa10 

    RCC->AHB2ENR |= RCC_AHB2ENR_GPIOCEN;
    GPIOC->MODER = (GPIOC->MODER & ~(0x3 << (2 * 13))) | (0x0 << (2 * 13));   
	// PC13 input mode
    GPIOC->MODER = (GPIOC->MODER & 0xFFFFFFFC) | 0x3;	
	// pc0 as analog input
    GPIOC->PUPDR = 0xAA;
    GPIOC->ASCR |= 1;
}

void ADC1_init() {
	RCC->AHB2ENR |= RCC_AHB2ENR_GPIOCEN;
	RCC->AHB2ENR |= RCC_AHB2ENR_ADCEN;
	GPIOC->MODER |= 0b11; 					// set pc0 as analog mode
	GPIOC->ASCR |= 1; 						// pc0 connect analog switch to ADC input

	ADC1->CFGR &= ~ADC_CFGR_RES; 			// set 12-bit resolution
	ADC1->CFGR &= ~ADC_CFGR_CONT; 			// set disable continuous conversion
	ADC1->CFGR &= ~ADC_CFGR_ALIGN; 			// set right align

	ADC123_COMMON->CCR &= ~ADC_CCR_DUAL; 	// independent mode
	ADC123_COMMON->CCR &= ~ADC_CCR_CKMODE; 	// clock mode: hclk / 1
	ADC123_COMMON->CCR |= 1 << 16;
	ADC123_COMMON->CCR &= ~ADC_CCR_PRESC; 	// prescaler: div 1
	ADC123_COMMON->CCR &= ~ADC_CCR_MDMA; 	// disable dma
	ADC123_COMMON->CCR &= ~ADC_CCR_DELAY; 	// delay: 5 adc clk cycle
	ADC123_COMMON->CCR |= 4 << 8;

	ADC1->SQR1 &= ~(ADC_SQR1_SQ1 << 6); 	// channel: 1, rank: 1
	ADC1->SQR1 |= (1 << 6);
	ADC1->SMPR1 &= ~(ADC_SMPR1_SMP0 << 3); 	// adc clock cycle: 12.5
	ADC1->SMPR1 |= (2 << 3);

	ADC1->CR &= ~ADC_CR_DEEPPWD; 			// turn off power
	ADC1->CR |= ADC_CR_ADVREGEN; 			// enable adc voltage regulator

	for (int i = 0; i <= 1000; ++i); 		// wait for regulator start up
	
	ADC1->IER |= ADC_IER_EOCIE; 			// enable end of conversion interrupt
	NVIC_EnableIRQ(ADC1_2_IRQn);
	
	ADC1->CR |= ADC_CR_ADEN; 				// enable adc
	while (!(ADC1->ISR & ADC_ISR_ADRDY)); 	// wait for adc start up
}

void USART_init() {
    RCC->APB2ENR |= RCC_APB2ENR_USART1EN;
    USART1->BRR = 0x1A0;
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

void print(char *s) {
    for(int i=0; s[i]; i++) {
        while(!(USART1->ISR & USART_ISR_TXE));
        USART1->TDR = s[i];
    }
}

void printInt(int tar) {
    static char buf[100]; buf[0] = '\0'; int ptr = 0;
    while (tar)
        buf[ptr++] = (tar % 10) + '0', tar /= 10;
    if (ptr == 0)
        buf[ptr++] = '0';
    buf[ptr] = '\0';
    int L = 0, R = ptr - 1;
    while (L < R) {
        char tmp = buf[L]; buf[L] = buf[R]; buf[R] = tmp;
        L++; R--;
    }
    print(buf);
}

int main() {
    GPIO_init();
    ADC1_init();
    USART_init();
    SysTick_Config(4000000);	// SysTick every second
    while (1) {
        if (GPIOC->IDR==0){
            print("voltage: "), printInt(voltage);
            print("\r\n");
	        delay();
        }
    }
}
