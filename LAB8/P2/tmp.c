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

	GPIOA->MODER = 0b10100011;
	// change to AF mode
	// pa0 = 11

	GPIOA->AFR[0] = 0x00007700;

	GPIOC->MODER = 0b01;
	GPIOA->ASCR = 1;
	// pa0 : 11 analogin
	// pa2 , pa3 : 10 another function
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

void ADC_init(){
	// enable choose sys clock
	RCC->AHB2ENR |= RCC_AHB2ENR_ADCEN;
	RCC->CCIPR |= RCC_CCIPR_ADCSEL;

	/* !< ADC synchronous clock derived from AHB clock without prescaler */
	/* 21:18 --> 0000: input ADC clock not divided */
	ADC123_COMMON->CCR &= 0xffc3ffff;
	/* !< ADC dual mode disabled (ADC independent mode) */
	// 00000: Independent mode
	ADC123_COMMON->CCR &= 0xfffffff0;

	
	/*!< ADC oversampling disabled. */
	// 0000: No shift
	ADC1->CFGR2 = 0;
 	/*!< ADC resolution 12 bits */
	 // 00: 12-bit
	ADC1->CFGR  &= 0xffffffe7;
	/*!< Sampling time 6.5 ADC clock cycles */
	ADC1->SMPR1 &= 0xfffc7fff;
	ADC1->SMPR1 |= 0b001000000000000000;
	/*!< ADC conversion data alignment: right aligned (alignment on data register LSB bit 0)*/
	ADC1->CFGR |= 0b100000;

	
	// Disable deep power mode to start the voltage conversion
	ADC1->CR &= ~ADC_CFGR_ALIGN;

	
	// Enable related interrupt
  	NVIC_EnableIRQ(ADC1_2_IRQn);

	/*!< ADC conversions are performed in single mode: one conversion per trigger */
	/* v.s another 
	*/
	/*!< ADC conversions are performed in continuous mode: after the first trigger, following conversions launched successively automatically */
	ADC1->CFGR |= 0xffffdfff;
	/*!< ADC group regular conversion trigger internal: SW start. */
	ADC1->CFGR &= ~ADC_CFGR_CONT; 
	/*!< ADC group regular sequencer discontinuous mode disable */
	//ADC1->CFGR = 0;


	/*!< ADC group regular sequencer disable (equivalent to sequencer of 1 rank: ADC conversion on only 1 channel) */
	//ADC1->SQR1 = 0;
 	/*!< ADC group regular sequencer discontinuous mode disable */
	//ADC1->CFGR = 0;
	/*!< ADC group regular sequencer rank 1 */
	//ADC1->SQR1 = 0;
	/*!< ADC external channel (channel connected to GPIO pin) ADCx_IN5  */
	/*!< ADC group regular sequencer rank 1 */
	
	// LL_ADC_EnableInternalRegulator
	ADC1->IER |= ADC_IER_EOCIE;
	// LL_ADC_IsInternalRegulatorEnabled


	//enable
	ADC1->CR |= ADC_CR_ADEN;
	while(!(ADC1->ISR & ADC_ISR_ADRDY));
}

int main(){
	GPIO_init();
	UART2_init();
	ADC_init();
	
	char* Str[50];
	GPIOC->ODR = 1;
	int ans = 0;
	while(1){
		// check pc13
		//if((GPIOC->IDR & 0b10000000000000) == 0){
		if(DEBOUNCE() == 1){
			GPIOC->ODR = GPIOC->ODR ^ 1;
			ADC1->CR |= ADC_CR_ADSTART;
    		while(!(ADC1->ISR & ADC_ISR_EOC)); //Polling until the ADC conversion of light resistor is done
    		ans = ADC1->DR;
			sprintf(Str, "Data: %d", ans);
			UART2_Transmit(Str);
		}
	}

    return 0;
}
