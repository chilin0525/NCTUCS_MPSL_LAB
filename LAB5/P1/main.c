//These functions inside the asm file
extern void GPIO_init();
extern void max7219_init();
extern void max7219_send(int address, int data);

/**
* TODO: Show data on 7-seg via max7219_send
* Input:
* data: decimal value
* num_digs: number of digits will show on 7-seg
* Return:
* 0: success
* -1: illegal data range(out of 8 digits range)
*/

// r0 : address  r1 : data
int display(int data, int num_digs){
    if(num_digs>8 || num_digs<0 || data>99999999) return -1;
	int i=1;
    for(;i<num_digs;i++){
        if(i==7){
            int address_num_dig = i << 8;
            max7219_send(address_num_dig,0);
        } else {
            int address_num_dig = i << 8;
            int single_digit = data % 10 ;
            data = data / 10;
            max7219_send(address_num_dig,single_digit);
        }
    }
    return 0;
}

void main(){
	int student_id = 711282;
	GPIO_init();
	max7219_init();
	display(student_id, 8);
}
