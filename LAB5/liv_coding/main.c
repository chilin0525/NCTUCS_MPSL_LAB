#include "stm32l476xx.h"


int keypad_value[4][4] = {
        {1, 2, 3, 10},
        {4, 5, 6, 11},
        {7, 8, 9, 12},
        {15, 0, 14, 13}
    };
int flag[4][4] = {0};
extern void max7219_init();
extern void max7219_send(int address,int data);

int display(int data){
    if(data<=9){
        max7219_send(1<<8,data);
        max7219_send(2<<8,0xF);
    } else {
        max7219_send(1<<8,data%10);
        max7219_send(2<<8,data/10);
    }
    return 0;
}

// pull-up: no:1 push:0


void keypad_init(){
    RCC -> AHB2ENR = RCC -> AHB2ENR | 0x7;

    //GPIOA -> MODER = GPIOA -> MODER & 0b11111111111111110101011111111111;
    GPIOA -> MODER = 0b11111111111111110101011111111111;
    GPIOA -> ODR   = 0;
    /*
    //  for max7219 
    */

    //GPIOB -> MODER = GPIOB -> MODER & 0x0;
    GPIOB -> MODER = 0x0;
    //GPIOB -> PUPDR = GPIOB -> PUPDR | 0b00000000111111; // clear 
    GPIOB -> PUPDR = 0b10101010000000; // pull-dowm mode
    GPIOB -> IDR = 0;
    /*
    //  pb3-6 : input
    //  X0 == pb6 == pin4 == col1
    //  X1 == pb5 == pin3 == col2
    //  X2 == pb4 == pin2 == col3
    //  X3 == pb3 == pin1 == col4
    */

    GPIOC -> MODER = 0b01010101;
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
    int first_num = -1;
	
    while (1){
        GPIOB -> MODER = 0x0;
        GPIOB -> PUPDR = 0b10101010000000; // pull-dowm mode
        GPIOB -> IDR = 0;
        GPIOC -> MODER = 0b01010101;
        GPIOC -> ODR = 0;
        int sum = 0;
        int sum2 = 0;
        int first = -1;
        int second = -1;
        int i=0,j=0;

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
                    if(first==-1){
                        sum = (keypad_value[i][j]);
                        first = 0;
                    } else if(second==-1) {
                        sum2 = (keypad_value[i][j]);
                        second = 0;
                    }
                    flag[i][j] = 1;
                } 
            }
        }

        GPIOB -> MODER = 0b01010101000000;
        GPIOB -> ODR   = 0;
        GPIOC -> MODER = 0;
        GPIOC -> PUPDR = 0b10101010;
        GPIOC -> IDR   = 0;
    
        for(i=0;i<4;i++){
            GPIOB -> ODR = (1 << (6-i) ) ;
            for(j=0;j<4;j++){
                int tmp = GPIOC -> IDR & 0b1111;
                if( (tmp >> j) & 0x1){
                    if(!flag[j][i]){
                        if(first==-1){
                            sum = (keypad_value[j][i]);
                            first = 0;
                        } else if(second==-1) {
                            sum2 = (keypad_value[j][i]);
                            second = 0;
                        }
                        flag[j][i] = 1;
                    }   
                } 
            }
        }

        if(first_num==-1) first_num=sum;
        if(first==-1 && second==-1){
            first_num = -1;
        }else if(first==0 && second==-1){
            first_num = sum ;
        }else if(first==0 && second ==0){
            if(first_num!=sum){
                int tmp = sum;
                sum = first_num;
                sum2 = tmp;
            }
        }

        int ans = sum + sum2;
        
        if(ans>=10){
            max7219_send(1<<8,ans%10);
            max7219_send(2<<8,ans/10);
            max7219_send(3<<8,0xf); 
            if(second==-1){     // if sum = x sum2 = x then all space
                max7219_send(4<<8,0xf); 
                max7219_send(5<<8,0xf);
                max7219_send(6<<8,0xf); 
                max7219_send(7<<8,0xf);
                max7219_send(8<<8,0xf);
            } else {
                if(sum2>=10){    
                max7219_send(4<<8,sum2%10);
                max7219_send(5<<8,sum2/10);
                max7219_send(6<<8,0xf); // space
                    if(sum>=10){
                        max7219_send(7<<8,sum%10);
                        max7219_send(8<<8,sum/10);
                    }else{
                        max7219_send(7<<8,sum%10);
                        max7219_send(8<<8,0xf);
                    }
                } else {
                    max7219_send(4<<8,sum2%10);
                    max7219_send(5<<8,0xf); // space
                    if(sum>=10){
                        max7219_send(6<<8,sum%10);
                        max7219_send(7<<8,sum/10);
                        max7219_send(8<<8,0xf);
                    }else{
                        max7219_send(6<<8,sum%10);
                        max7219_send(7<<8,0xf);
                        max7219_send(8<<8,0xf);
                    }
                }
            }
        } else if(ans == 0){        // if sum = x sum2 = x then all space
            if(second==-1 && first!=-1){    
                max7219_send(1<<8,0);
                max7219_send(2<<8,0xf); 
                max7219_send(3<<8,0xf);
                max7219_send(4<<8,0xf); 
                max7219_send(5<<8,0xf);
                max7219_send(6<<8,0xf); 
                max7219_send(7<<8,0xf);
                max7219_send(8<<8,0xf);
            } else {
                max7219_send(1<<8,0xf);
                max7219_send(2<<8,0xf); 
                max7219_send(3<<8,0xf);
                max7219_send(4<<8,0xf); 
                max7219_send(5<<8,0xf);
                max7219_send(6<<8,0xf); 
                max7219_send(7<<8,0xf);
                max7219_send(8<<8,0xf);
            }
        } else {                    // if ans <9
            max7219_send(1<<8,ans%10);
            max7219_send(2<<8,0xf); 
            if(second==-1){         // if second==-1 : only pressed one 
                max7219_send(3<<8,0xf);
                max7219_send(4<<8,0xf); 
                max7219_send(5<<8,0xf);
                max7219_send(6<<8,0xf); 
                max7219_send(7<<8,0xf);
                max7219_send(8<<8,0xf);
            } else {                // if second!=-1 : pressed two
                max7219_send(3<<8,sum2%10);
                max7219_send(4<<8,0xf); // space
                max7219_send(5<<8,sum%10);
                max7219_send(6<<8,0xf); // space
                max7219_send(7<<8,0xf);
                max7219_send(8<<8,0xf);
            }
        }
    }
    return 0;
}
