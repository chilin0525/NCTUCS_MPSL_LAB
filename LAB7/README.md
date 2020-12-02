# LAB7

p3 已涵蓋 live_coding 的內容

## DEMO Cheetsheet

### 說說 SysTick 有哪些特色？ 如: 它是上數還是下數？是幾位元的 Timer？

下數，24 bit

[詳見P1](https://github.com/chilin0525/NCTUCS_MPSL_LAB/blob/master/LAB7/P1/README.md)

### SysTick 時脈為多少？Counter 要數多少才是3秒？

P1 是以 Processor 作為 clock 來源，根據設定時脈為 1M ， 故counter 需要數 3*1M 達到三秒要求

[詳見P1](https://github.com/chilin0525/NCTUCS_MPSL_LAB/blob/master/LAB7/P1/README.md)

### 在不重新設定 SYSCFG 的情況下，可以同時使用 PB3 與 PC3 當作外部中斷 (EXTI) 嗎？請說明為什麼可以，或為什麼不可以？

不行(Mux擇一輸出)

[詳見P2]()

### 為什麼需要在 Handler 裡清除 EXTI pending register，及如何清除 pending bit？那 NVIC 是否也需要做清除 pending bit？

如果不清楚 EXTI pending register 將會發生不斷重複執行 interrupt Hanlder 的情況

清除方式以 P3 為例子

```c
void EXTI9_5_IRQHandler(void){
	WORK();
	EXTI->PR1 |= EXTI_PR1_PIF5 | EXTI_PR1_PIF6;
}
```
