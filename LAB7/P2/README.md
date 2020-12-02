# P2

## Setup

### GPIO_setup

set as input mode

### EXTI

因為選擇 pb3,pb4,pb5,pb6

故需要設定 EXTI3 EXTI4 EXTI5 EXTI6

```c
EXTI->RTSR1 |= EXTI_RTSR1_RT3;
EXTI->RTSR1 |= EXTI_RTSR1_RT4;
EXTI->RTSR1 |= EXTI_RTSR1_RT5;
EXTI->RTSR1 |= EXTI_RTSR1_RT6;
// Rising Trigger Selection Register
// 0 : disable
// 1 : disable

EXTI->IMR1 |= EXTI_IMR1_IM3;
EXTI->IMR1 |= EXTI_IMR1_IM4;
EXTI->IMR1 |= EXTI_IMR1_IM5;
EXTI->IMR1 |= EXTI_IMR1_IM6;
// Interrupt Mask Register
// 0 : marked 
// 1 : not masked
```

因為 pb 被設定為 pull-down 所以 ```EXTI->RTSR``` 需要設定為1，表示值為1時產生 interrupt

```EXTI->IMR1``` 用來開啟 interrupt (mask 表不產生)

## GPIO
<br>

pb3-6 : input

X0 == pb6 == pin4 == col1

X1 == pb5 == pin3 == col2

X2 == pb4 == pin2 == col3

X3 == pb3 == pin1 == col4
    
pc0-3 : output to test

Y0 == pc0 == pin8 == row1

Y1 == pc1 == pin7 == row2

Y2 == pc2 == pin6 == row3

Y3 == pc3 == pin5 == row4

<br>

## EXTI


![](https://i.imgur.com/ntCTIoV.png)

注意不能同時使用 PA3 又同時使用 PB3 等等(MUX)

![](https://i.imgur.com/70YKSiI.png)

```FTSR``` : 下緣觸發

```RTSR``` : 上緣觸發

![](https://i.imgur.com/OiN3eLt.png)


```SWIER``` : 可以直接產生 interrupt

```IMR``` : mask interrupt?

<br>

## Ref

[Lecture 11: External interrupts (EXTI)](https://www.youtube.com/watch?v=uKwD3JuRWeA&ab_channel=EmbeddedSystemswithARMCortex-MMicrocontrollersinAssemblyLanguageandC)

RCC->APB2ENR:

![](https://i.imgur.com/RiUnW47.png)


