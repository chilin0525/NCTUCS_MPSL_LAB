# LAB3

## Spec Question

### P1 LED scroller

>Requirement: Please construct a circuit containing 4 active low LEDs. That is, the LED will be turned off when the corresponding GPIO pin outputs high potential
(VDD), and it will be turned on when the low potential (VSS) is received. Then, refer to the lecture slide, finish the initialization of peripheral bus (AHB2) and
GPIO pins.Then, complete the program below and use the variable "leds" to record the LEDs’ states. Using the function "DisplayLED" to set LEDs to the pattern corresponding to the variable .
請構建一個包含 4 個低態有效 LED 的電路。 也就是說，當相應的 GPIO 引腳輸出高電位（VDD）時，LED 將關閉，而當接收到低電位（VSS）時，LED 將被打開。接著，參考章節投影片，完成週邊裝置匯流排（AHB2）及 GPIO 接腳的初始化。接著，完成以下程式碼。利用 "leds" 這個變數紀錄目前位移數值，並使用 "DisplayLED" 函式將 LED 設置為與變數對應的圖案。

![](https://i.imgur.com/byE0nh4.png)

![](https://i.imgur.com/4PDOIXF.jpg)

![](https://i.imgur.com/ATCU1dR.jpg)

![](https://i.imgur.com/32NY4pE.jpg)

### P2
>Our development board provides a built-in blue user button which is connected to the I/O PC13 of the STM32 microcontroller. Please initialize GPIO PC13 as pull-up input and solve the mechanical bounce problem using software debounce tricks. Then, design a polling program to read the state of the user button on board, and use the button to control the scrolling of the LEDs (Require 2-1). Once we press the button, the LEDs will pause scrolling and it should resume scrolling when we press the button again.
我們的開發板提供了一個內建的藍色使用者按鈕，該按鈕連接到 STM32 微控制器的 I/O PC13。 請初始化 GPIO PC13 作為上拉輸入，並使用軟體解彈跳技巧來解決機械彈跳問題。接著，設計一個輪詢程式讀取使用者按鈕的狀態。然後利用這個按鈕控制LED 的滾動（Require 2-1）。 按下按鈕後，LED 將暫停滾動，當再次按下按鈕時，它將從繼續滾動。

<br>

### P3

<br>

## DEMO Cheetsheet

>Question 1-1: What is the memory-mapped I/O (MMIO)? What are its pros and cons?
什麼是 memory mapped I/O (MMIO)？ 它的優缺點是什麼？


| MMIO | 優  | 缺  |
|:---- | --- |:--- |
|      | 需要一段Physical memory address保留給IO<br>犧牲了可以使用的memory address    |     |

<br>

>Question 1-2: What is the port-mapped I/O (PMIO)? What are its pros and cons?
什麼是 port-mapped I/O (PMIO)？ 它的優缺點是什麼？

| PMIO | 優  | 缺  |
|:---- | --- |:--- |
|      | IO與memory分開<br>可以使用的memory address較多也較為安全    |     |

<br>

REF: [Memory mapped I/O vs Port mapped I/O](https://stackoverflow.com/questions/15371953/memory-mapped-i-o-vs-port-mapped-i-o)

>Question 1-3: When we set GPIO pin to the input mode, we also need to config the GPIOx_PUPDR register to pull-up, pull-down or floating (non-pull-up, non-pull-down). What's the effect of these settings?
當我們將 GPIO pin 設成 input mode 的時候，還需要將 GPIOx_PUPDR 設成上拉，下拉或浮動（非上拉、非下拉）。這些設置有什麼作用？
