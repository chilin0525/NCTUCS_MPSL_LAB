# P1

<br>

```SysTick_Config()``` in ```core_cm4.h```:

```c
__STATIC_INLINE uint32_t SysTick_Config(uint32_t ticks)
{
  if ((ticks - 1UL) > SysTick_LOAD_RELOAD_Msk)
  {
    return (1UL);                                                   /* Reload value impossible */
  }
  
  SysTick->LOAD  = (uint32_t)(ticks - 1UL);                         /* set reload register */
  NVIC_SetPriority (SysTick_IRQn, (1UL << __NVIC_PRIO_BITS) - 1UL); /* set Priority for Systick Interrupt */
  SysTick->VAL   = 0UL;                                             /* Load the SysTick Counter Value */
  SysTick->CTRL  = SysTick_CTRL_CLKSOURCE_Msk |
                   SysTick_CTRL_TICKINT_Msk   |
                   SysTick_CTRL_ENABLE_Msk;                         /* Enable SysTick IRQ and SysTick Timer */
  return (0UL);                                                     /* Function successful */
} 
```

```c
#define SysTick_LOAD_RELOAD_Msk            (0xFFFFFFUL /*<< SysTick_LOAD_RELOAD_Pos*/)    /*!< SysTick LOAD: RELOAD Mask */
```

對 ```SystTck```  類型的 interrupt, NVIC(nested vectored interrupt controller) 會執行相對應的 ISR(interrup service routine) : ```void SysTick_Handler(void)```


Ref: [Lecture 12: System Timer (SysTick)](https://www.youtube.com/watch?v=aLCUDv_fgoU&ab_channel=EmbeddedSystemswithARMCortex-MMicrocontrollersinAssemblyLanguageandC)

<br>

![](https://i.imgur.com/us2eom9.png)

<br>

SysTick 是 down counter, 所以當 count 為0時表示要發出 Interrupt

```COUNTFLAG```: 當 Counter 數到 0 設為1

```TICKINT```: 是否為有開啟 interrupt, 無的話 interrupt 不發出

```ENABLE```: 就 enable :smiley_cat: 

```CLOCK SOURCE```: 選擇 Clock source

interrupt condition : ```COUNTERFLAG``` and ```TICKINT```

<br>

## Ref:

RCC->CR:

![](https://i.imgur.com/hPhk0eh.png)

<br>

RCC->CFCG:

![](https://i.imgur.com/EmqlJj8.png)


<br>

Systick:

![](https://i.imgur.com/7EdPmde.png)

![](https://i.imgur.com/O4EjZZb.png)

![](https://i.imgur.com/l8jD3am.png)
