#include "stm32l476xx.h"
#define MAX_BUFFER_SIZE 128

int resistor;

char com[MAX_BUFFER_SIZE];
int ptr;
int shell_state = 0;
int vol;

void print(char *s) {
	for(int i=0; s[i]; i++) {
		USART1->TDR = s[i];
		while(!(USART1->ISR & USART_ISR_TXE));
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

void SysTick_Handler()
{
	ADC1->CR |= ADC_CR_ADSTART; // start adc conversion
}


void ADC1_2_IRQHandler() {
	while (!(ADC1->ISR & ADC_ISR_EOC)); // wait for conversion complete
	vol = (int) ADC1->DR;
    printInt(vol);
    print("\r\n");
}

void ADC1_init() {
	RCC->AHB2ENR |= RCC_AHB2ENR_GPIOCEN;
	RCC->AHB2ENR |= RCC_AHB2ENR_ADCEN;
	GPIOC->MODER |= 0b11; // analog mode
	GPIOC->ASCR |= 1; // connect analog switch to ADC input
	ADC1->CFGR &= ~ADC_CFGR_RES; // 12-bit resolution
	ADC1->CFGR &= ~ADC_CFGR_CONT; // disable continuous conversion
	ADC1->CFGR &= ~ADC_CFGR_ALIGN; // right align
	ADC123_COMMON->CCR &= ~ADC_CCR_DUAL; // independent mode
	ADC123_COMMON->CCR &= ~ADC_CCR_CKMODE; // clock mode: hclk / 1
	ADC123_COMMON->CCR |= 1 << 16;
	ADC123_COMMON->CCR &= ~ADC_CCR_PRESC; // prescaler: div 1
	ADC123_COMMON->CCR &= ~ADC_CCR_MDMA; // disable dma
	ADC123_COMMON->CCR &= ~ADC_CCR_DELAY; // delay: 5 adc clk cycle
	ADC123_COMMON->CCR |= 4 << 8;
	ADC1->SQR1 &= ~(ADC_SQR1_SQ1 << 6); // channel: 1, rank: 1
	ADC1->SQR1 |= (1 << 6);
	ADC1->SMPR1 &= ~(ADC_SMPR1_SMP0 << 3); // adc clock cycle: 12.5
	ADC1->SMPR1 |= (2 << 3);
	ADC1->CR &= ~ADC_CR_DEEPPWD; // turn off power
	ADC1->CR |= ADC_CR_ADVREGEN; // enable adc voltage regulator
	for (int i = 0; i <= 1000; ++i); // wait for regulator start up
	ADC1->IER |= ADC_IER_EOCIE; // enable end of conversion interrupt
	NVIC_EnableIRQ(ADC1_2_IRQn);
	ADC1->CR |= ADC_CR_ADEN; // enable adc
	while (!(ADC1->ISR & ADC_ISR_ADRDY)); // wait for adc start up
}

void GPIO_init()
{
	RCC->AHB2ENR |= RCC_AHB2ENR_GPIOAEN | RCC_AHB2ENR_GPIOCEN;
	GPIOA->MODER = (GPIOA->MODER & 0xFFC3FFFF) | 0x280000;
	GPIOA->AFR[1] = (GPIOA->AFR[1] & 0xFFFFF00F) | 0x770;
	GPIOA->MODER = (GPIOA->MODER & 0xFFFFF3FF) | 0x400;

    GPIOC->MODER = (GPIOC->MODER & ~(0x3 << (2 * 13))) | (0x0 << (2 * 13));   // PC13 input mode
    GPIOC->MODER = (GPIOC->MODER & 0xFFFFFFFC) | 0x3;
    GPIOC->PUPDR = 0xAA;
    GPIOC->ASCR |= 1;
}

void init_UART()
{
	RCC->APB2ENR |= RCC_APB2ENR_USART1EN;
	USART1->BRR = 0x1A0;
	USART1->CR1 |= USART_CR1_TE;
	USART1->CR1 |= USART_CR1_RE;
	USART1->CR1 |= USART_CR1_UE;
}


void run_command(){

		if(com[0]=='s'&&com[1]=='h'&&com[2]=='o'&&com[3]=='w'&&com[4]=='i'&&com[5]=='d'&&com[6]=='\0')
		{
			print("0711250\r\n");
		}
		else if(com[0]=='l'&&com[1]=='i'&&com[2]=='g'&&com[3]=='h'&&com[4]=='t'&&com[5]=='\0')
		{
			shell_state = 1;
			SysTick->CTRL=3;
			SysTick_Config(2000000);
			return;
		}
		else if(com[0]=='l'&&com[1]=='e'&&com[2]=='d'&&com[3]==32&&com[4]=='o'&&com[5]=='n'&&com[6]=='\0')
		{
            GPIOA->ODR |= (1<<5);
		}
		else if(com[0]=='l'&&com[1]=='e'&&com[2]=='d'&&com[3]==32&&com[4]=='o'&&com[5]=='f'&&com[6]=='f'&&com[7]=='\0')
		{
				GPIOA->ODR &= ~(1<<5);
		}
		else if(ptr==0)
		{
			//print("\r");
		}
		else
		{

            print("Unknown Command\r\n");
        }

    print(">");
    return;
}

int main()
{
	GPIO_init();
	init_UART();
	ADC1_init();
	ptr = 0;
	SysTick->CTRL=0;
	SysTick_Config(0);


	USART1->TDR=62;

	while(1)
	{

	if(USART1->ISR & USART_ISR_RXNE)
	{

	    char c = USART1->RDR;

		if(shell_state==0)
		{
				while(!(USART1->ISR & USART_ISR_TXE));

				if(c == '\n' || c == '\r')
			    {
					print("\r\n");
					run_command();
					ptr = 0;
					com[0]='\0';
				}
				else if (c == 0x7F)
				{
					if(ptr!=0)USART1->TDR = c;

					ptr=ptr==0?0:ptr-1;
					com[ptr]='\0';

                }
				else if(c!=0x7F)
				{
				USART1->TDR = c;
				com[ptr++] = c;
				com[ptr]='\0';
				}
	    }
		else if(shell_state==1&&c=='q')
		{
			        SysTick->CTRL=0;
			        SysTick_Config(0);
                    for (int i = 0 ; i < 10000 ; i++);
                    print(">");
					shell_state = 0;

		}
	}

	}
	return 0;
}
