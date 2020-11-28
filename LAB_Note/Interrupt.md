# Interrupt

![](https://i.imgur.com/i9tGWKQ.png)

NVIC : 具有 nested interrupt 功能(某些控制器不具備此能力)

Interrupt masking : 可以針對特定的 interrupt 不做任何事情(與 interrupt disable 不同意思)

![](https://i.imgur.com/FMYFKP6.png)

```SETENA``` : 可以針對某 interrupt 做 set (與 BSRR/BRR 差不多意思)

<br>

![](https://i.imgur.com/PoQqYe0.png)

```SETPEND``` : 如果同時有兩個 interrupt 進來了，先處理先進來的那個後面那個需要等待(pending)，或是你故意讓他 pending

<br>

![](https://i.imgur.com/YmW8VwY.png)

1. GPIO module: 可以當作外部 interrupt 來源
2. SYSCFG: 用來設定哪些 pin 會成為 interrupt 的來源
3. EXTI: 設定上源或是下源當作觸發
4. NVIC: 
5. CPU: 接到 CPU IRQ

<br>

![](https://i.imgur.com/X9ZAV4S.png)

把 ```EXTI``` 展開:

![](https://i.imgur.com/HaNk5g0.png)

