#include "stm32l476xx.h"

#define TIME_SEC 12.70

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

void DISPLAY_init(){
    int i=1;
    for(;i<=8;i++) MAX7219Send(i<<8,0xF);
    MAX7219Send(3<<8,1<<7);
    MAX7219Send(2<<8,0);
    MAX7219Send(1<<8,0);
}

void DISPLAY_FLOAT(double a){
    MUTIDISPLAY(666);

    //double float_num = (time - (int)time)*100;
    //MAX7219Send(2<<8,float_num/10);
    //MAX7219Send(1<<8,(int)float_num%10);
    MUTIDISPLAY(77);
    //MUTIDISPLAY((int)float_num);
    MUTIDISPLAY(56);
}

int main(){
    GPIO_init();
    max7219_init();
    //Timer_inti();
    //Timer_start();
    DISPLAY_init();

    MUTIDISPLAY(444444);
    DISPLAY_FLOAT(5);
    MUTIDISPLAY(5678);

    return 0;
}
