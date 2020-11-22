#include "stm32l476xx.h"

extern void GPIO_init();
extern void max7219_init();
extern void MAX7219Send(int address,int data);
extern void MUTIDISPLAY();
extern void DELAY();

int tmp=1234;

int DEBOUNCE(){
        ++tmp;

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

void SET_CLK(int freq){

	RCC -> CFGR = 0x00000000;

    // step1: set PLLON to 0 (disable)
    RCC -> CR &= 0xFEFFFFFF; 
    
    // step2: wait until PLLRDY cleared
    // PLLRDY :  1 locked  ;  0 unloced
    while(1){
        if((RCC -> CR & 0x02000000)==0) break;
    }

    // step3: change desirable PLL parameter
    if(freq == 1){
        RCC -> PLLCFGR = 0b110000000000000100000110001;
    } else if(freq == 6){
        RCC -> PLLCFGR = 0b000000000000000110000110001;
    } else if(freq == 10){
        RCC -> PLLCFGR = 0b000000000000000101000010001;
    } else if(freq == 16){
        RCC -> PLLCFGR = 0b000000000000000100000000001;
    } else {
        RCC -> PLLCFGR = 0b000000000000001010000000001;
    }

    // step4: set PLLON to 1 (enable)
    RCC -> CR |= 0x01000000;
    // wait
    while(1){
        if((RCC -> CR & 0x02000000)!=0) break;
    }
    
    // step5: Enable desired PLL output by configuring PLLPEN PLLQEN PLLREN
    RCC -> PLLCFGR |= 0x01000000;

    // enable PLL
    RCC -> CFGR |= 0x00000003;
}

int main(){
    int freq[] = {1, 6, 10, 16, 40};
    GPIO_init();
    max7219_init();

    int idx = 0;
    while(1){
        if(DEBOUNCE()){
            if(idx>=4)idx=0;
            else idx=idx+1;
        }
        SET_CLK(freq[idx]);
        MUTIDISPLAY(freq[idx]);
        GPIOC -> BRR = 1;  // open LED
        DELAY();
        GPIOC -> BSRR = 1;  // open LED
        DELAY();
    }

    return 0;
}
