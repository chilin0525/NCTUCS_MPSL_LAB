# lab6

## P1

PC0 <==> LED

PC1 <==> DIN

PC2 <==> CS

PC3 <==> CLK

## P2

PC1 <==> DIN

PC2 <==> CS

PC3 <==> CLK


## P3

![](https://i.imgur.com/Vo6jEdH.png)

![](https://i.imgur.com/uQ0Cuud.png)

![](https://i.imgur.com/qB4yHSU.png)

![](https://i.imgur.com/MYP2nRf.png)

## Demo cheetsheet

### P1.1 說說你使用哪個 Clock source？說說切換的步驟？

### P1.2 怎麽得到 6MHz HCLK? 請參考下圖說明設了哪些暫存器？值要設為多少？

```c
void SET_CLK(int freq){

    // select MSI as sys clk
    RCC -> CFGR &= 0xFFFFFFF0;

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
        //                 f e PLLQ,R    PLLN  M   src
    }
```

| Freq | PLLR  | PLLN(14-8) | PLLM(4-6) | source(1-0) |
|:---- |:----- |:---------- |:--------- |:----------- |
| 1M   | 11(8) | 8          | 011(4)    | MSI(01)     |
| 6M   | 00(2) | 12         | 011(4)    | MSI(01)     |
| 10M  | 00(2) | 10         | 001(1)    | MSI(01)     |
| 16M  | 00(2) | 8          | 000(1)    | MSI(01)     |
| 40M  | 00(2) | 20         | 000(1)    | MSI(01)     |


```c
    // step4: set PLLON to 1 (enable)
    RCC -> CR |= 0x01000000;
    // wait until ready
    while(1){
        if((RCC -> CR & 0x02000000)!=0) break;
    }
    
    // step5: Enable desired PLL output by configuring PLLPEN PLLQEN PLLREN
    RCC -> PLLCFGR |= 0x01000000;

    // select PLL as sys clk
    RCC -> CFGR |= 0x00000003;
}
```

![](https://i.imgur.com/ftxTa2a.png)



ref:

RCC->CFCG

![](https://i.imgur.com/wHsN4o3.png)
![](https://i.imgur.com/IdLtBLS.png)
![](https://i.imgur.com/NJyp3Iw.png)
![](https://i.imgur.com/yyF9wXc.png)
![](https://i.imgur.com/2fLF4aE.png)
![](https://i.imgur.com/PpER5GE.png)
![](https://i.imgur.com/1hcJFm2.png)

<br>

### P2.1 請參考下圖說明 timer 運作流程，及程式中設定了哪些暫存器？

![](https://i.imgur.com/Br83hLl.png)

trigger controller: 要不要對下面的 counter 跟 timer 做動作(enable?)

PSC presalar: 幾個波要算成一個波(除頻器)

### P2.2 承上題，根據你所設定的 CK_INT, TIMx_ARR 及 TIMx_PSC。TIMx_CNT 數到多少的時候為 1 秒？



```c
void Timer_init(){
    RCC->APB1ENR1 |= RCC_APB1ENR1_TIM2EN;    
    // enable TIM2 clk
    
    TIM2->CR1 = 0;              
    // upcounter, disable counter, enable UEV(update event)
    
    TIM2->CNT = 0;
    TIM2->PSC = (uint32_t)999;  // 4M == 4000000/1000 = 4000
    TIM2->ARR = (uint32_t)3999; // Count from 0 to 3999
}
```

```c
void Timer_start(){
    TIM2->EGR = 0x0001;        // re init cnt
    TIM2->SR &= 0xFFFFFFFE;    // set to 0
    TIM2->CR1 |= 0x00000001;   // enable counter
}
```


ref:

![](https://i.imgur.com/CLGX5ic.png)

![](https://i.imgur.com/ocoXN0H.png)

![](https://i.imgur.com/XEIcuIc.png)
![](https://i.imgur.com/eRPNXUF.png)

TIM2->SR:

![](https://i.imgur.com/DneLu5W.png)

TIM2->EGR:

![](https://i.imgur.com/XYtpzHk.png)


<br>

### P3.1 (coding)請將 frequency 設為 333hz。

### P3.2 請說明你在 PWM_channel_init() 中做了哪些設定？並說明 TIMx_CCR 的功能為何？
