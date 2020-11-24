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
    // GPIOA -> MODER = GPIOA -> MODER & 0b11111111111111110101011111111111;
    GPIOA -> MODER = 0b100000000000;
    GPIOA -> AFR[0] = 0x00100000;
    /*
    //  for max7219
    */

    // GPIOB -> MODER = GPIOB -> MODER & 0x0;
    GPIOB -> MODER = 0x0;
    // GPIOB -> PUPDR = GPIOB -> PUPDR | 0b00000000111111;
    // clear
    GPIOB -> PUPDR = 0b10101010000000; // pull-dowm mode
    GPIOB -> IDR = 0;
    /*
    //  pb3-6 : input
    //  X0 == pb6 == pin4 == col1
    //  X1 == pb5 == pin3 == col2
    //  X2 == pb4 == pin2 == col3
    //  X3 == pb3 == pin1 == col4
    */

    GPIOC -> MODER = 0b010001010101;
    GPIOC -> ODR = 0;
    /*
    //  pc0-3 : output to test
    //  Y0 == pc0 == pin8 == row1
    //  Y1 == pc1 == pin7 == row2
    //  Y2 == pc2 == pin6 == row3
    //  Y3 == pc3 == pin5 == row4
    */
}

int main(){
    keypad_init();

    int flag_add = 1;
    int flag_sub = 1;

    /* set up */
    RCC->APB1ENR1 |= RCC_APB1ENR1_TIM2EN;  // enable TIM2 clock
    TIM2->CR1 = 0;
    TIM2->CNT = 0;
    //TIM2->PSC = (uint32_t)999;
    //TIM2->ARR = (uint32_t)3999; // 4M = 4000000/1000 = 4000;

    TIM2->CCER = 1;
    TIM2->CCMR1 = 0x0060;
    //TIM2->CCR1 = 400;           // 10%

    TIM2->ARR = 99;
    TIM2->CCR1 = 49;

    // PWM mode 1 -
    // upcounting, channel 1 is active as long as TIMx_CNT<TIMx_CCR1, else inactive.
    TIM2->EGR = 0x0001;         // re init

    TIM2->CR1 = 1;              // TIM2 start !
    while (1){
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
            if(sum == 15 && flag_add){
                //TIM2->CCR1 = (TIM2->CCR1==MAX_PWM)?MAX_PWM:TIM2->CCR1+ADD_PWM;
                TIM2->CCR1 = (TIM2->CCR1==90)?90:TIM2->CCR1+5;
                flag_add = 0;
                flag_sub = 1;
            }
            else if(sum == 14 && flag_sub){
                //TIM2->CCR1 = (TIM2->CCR1==MIN_PWM)?MIN_PWM:TIM2->CCR1-ADD_PWM;
                TIM2->CCR1 = (TIM2->CCR1==10)?10:TIM2->CCR1-5;
                flag_sub = 0;
                flag_add = 1;
            }
        } else {
            flag_add = 1;
            flag_sub = 1;
        }
    }
    return 0;
}
