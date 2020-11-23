#include "stm32l476xx.h"
#include <math.h>
#include <assert.h>
#define TIME_SEC 1.03

extern void GPIO_init();
extern void max7219_init();
extern void MAX7219Send(int address,int data);
extern void MUTIDISPLAY();
extern void DELAY();

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

int tmpt=0;

void Timer_init(){
    RCC->APB1ENR1 |= RCC_APB1ENR1_TIM2EN;    // enable TIM2
    TIM2->CR1 = 0;              // upcounter, disable counter, enable UEV(update event)
    TIM2->CNT = 0;
    TIM2->PSC = (uint32_t)999;  // 4M == 4000000/1000 = 4000
    TIM2->ARR = (uint32_t)3999;
}

void Timer_start(){
    TIM2->EGR = 0x0001;    // re init cnt
    TIM2->SR &= 0xFFFFFFFE;     // set to 0
    TIM2->CR1 |= 0x00000001;    // enable counter
}

void DISPLAY_init(){
    int i=1;
    for(;i<=8;i++) MAX7219Send(i<<8,0xF);
    MAX7219Send(3<<8,1<<7);
    MAX7219Send(2<<8,0);
    MAX7219Send(1<<8,0);
}

void DISPLAY_TIME(int TIM_INT,int TIM_FLO){
    int len = 0;
    while(TIM_INT != 0){
        if(len==0) MAX7219Send((len+3)<<8,(1<<7) + TIM_INT%10);
        else MAX7219Send((len+3)<<8,TIM_INT%10);
        TIM_INT /= 10;
        ++len;
    }
    MAX7219Send(2<<8,TIM_FLO/10);
    MAX7219Send(1<<8,TIM_FLO%10);
}

void CNT_DONE(){while(1){}}

int fractional_part_as_int(float number, int number_of_decimal_places) {
    float dummy;
    MUTIDISPLAY(568);

    float frac = modf(number,&dummy);
    return round(frac*pow(10,number_of_decimal_places));
}

long double round_f(long double number, int decimal_places){
     assert(decimal_places > 0);

     double power = pow(10, decimal_places-1);
     number *= power;

     return (number >= 0) ? ((long long)(number + 0.5))/power : ((long long)(number - 0.5))/power;
}

int main(){
    GPIO_init();
    max7219_init();
    DISPLAY_init();

    double dummy;
    double frac = modf(TIME_SEC,&dummy);
    int TIME_INT = (int)TIME_SEC;

    //int TIME_FLOAT = round(frac*pow(10,2));

    assert(2 > 0);
    double number = frac*pow(10,2);
    double power = pow(10, 2-1);
    number *= power;
    int TIME_FLOAT = (number >= 0) ? ((long long)(number + 0.5))/power : ((long long)(number - 0.5))/power;

    //int TIME_INT = (int)TIME_SEC;
    //MUTIDISPLAY(1234);
    //int TIME_FLOAT = fractional_part_as_int(TIME_SEC,2);
    //MUTIDISPLAY(568);

    int SUM_INT = 0;
    Timer_init();
    Timer_start();

    while(1){
        if(TIME_INT == SUM_INT && TIME_FLOAT == TIM2->CNT/40){
            DISPLAY_TIME(SUM_INT,TIM2->CNT/40);
            CNT_DONE();
        } else if(TIM2->SR & 0x00000001){
            TIM2->SR &= 0xFFFFFFFE;     // set to 0
            SUM_INT = SUM_INT + 1;
            DISPLAY_TIME(SUM_INT,TIM2->CNT/40);
        } else {
            DISPLAY_TIME(SUM_INT,TIM2->CNT/40);
        }
    }

    return 0;
}
