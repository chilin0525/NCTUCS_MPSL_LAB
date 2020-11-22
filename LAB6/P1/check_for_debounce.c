#include "stm32l476xx.h"

extern void GPIO_init();
extern void max7219_init();
extern void MAX7219Send(int address,int data);
extern void MUTIDISPLAY();

int tmp=1234;

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
    int freqency[] = {1,6};
    GPIO_init();
    max7219_init();

    int idx = 0;
    GPIOC -> BSRR = 1;  // open LED


    while(1){
        tmp = tmp +1;
        MUTIDISPLAY(tmp);
        if(DEBOUNCE()){
            idx = !idx;
            if(idx==1){
                GPIOC -> BRR = 1;  // open LED
            } else {
                GPIOC -> BSRR = 1;  // open LED
            }
        }
    }

    return 0;
}
