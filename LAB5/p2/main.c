#include "stm32l476xx.h"


int keypad_value[4][4] = {
        {1, 2, 3, 10},
        {4, 5, 6, 11},
        {7, 8, 9, 12},
        {15, 0, 14, 13}
    };

extern void max7219_init();
extern void max7219_send(int address,int data);

int display(int data){
    if(data<=9){
        max7219_send(1<<8,data);
        max7219_send(2<<8,0xF);
    } else {
        max7219_send(1<<8,data%10);
        max7219_send(2<<8,1);
    }
    return 0;
}

// pull-up: no:1 push:0

void keypad_init(){
    RCC -> AHB2ENR = RCC -> AHB2ENR | 0x7;

    GPIOA -> MODER = GPIOA -> MODER & 0b11111111111111110101011111111111;
    GPIOA -> MODER = GPIOA -> MODER | 0b11111111111111110101011111111111;
    GPIOA -> ODR   = 0;
    /*
    //  for max7219 
    */

    GPIOB -> MODER = GPIOB -> MODER & 0x0;
    GPIOB -> MODER = GPIOB -> MODER | 0x0;
    GPIOB -> PUPDR = GPIOB -> PUPDR | 0b00000000111111; // clear 
    GPIOB -> PUPDR = GPIOB -> PUPDR | 0b10101010000000; // pull-dowm mode
    GPIOB -> IDR = 0;
    /*
    //  pb3-6 : input
    //  X0 == pb6 == pin4 == col1
    //  X1 == pb5 == pin3 == col2
    //  X2 == pb4 == pin2 == col3
    //  X3 == pb3 == pin1 == col4
    */
   
    GPIOC -> MODER = GPIOC -> MODER & 0b01010101;
    GPIOC -> MODER = GPIOC -> MODER | 0b01010101;
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
	max7219_init();
	
    max7219_send(1<<8,0xf);
    max7219_send(2<<8,0xf);
    while (1){
        int i=0,j=0;
        int flag = 0;
        for(i=0;i<4;i++){
            for(j=0;j<4;j++){
                GPIOC -> ODR = (1 << i) ;
                if( (GPIOB -> IDR >> (6-j)) & 0x1 == 1){
                    display(keypad_value[i][j]);
                    flag = 1;
                    break;
                } 
                max7219_send(1<<8,0xf);
                max7219_send(2<<8,0xf);
            }
        }
    }
    return 0;
}
