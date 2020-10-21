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

### Question 1-1 
>Question 1-1: What is the memory-mapped I/O (MMIO)? What are its pros and cons?
什麼是 memory mapped I/O (MMIO)？ 它的優缺點是什麼？


|  | 優  | 缺  |
|:---- | --- |:--- |
| MMIO     | 可以直接透過memory對IO進行操作    | 需要一段Physical memory address保留給IO<br>犧牲了可以使用的memory address     |

<br>

### Question 1-2
>Question 1-2: What is the port-mapped I/O (PMIO)? What are its pros and cons?
什麼是 port-mapped I/O (PMIO)？ 它的優缺點是什麼？

| PMIO | 優  | 缺  |
|:---- | --- |:--- |
|      | IO與memory分開<br>可以使用的memory address較多也較為安全    |  需要特殊指令才能進行IO   |

<br>

REF: [Memory mapped I/O vs Port mapped I/O](https://stackoverflow.com/questions/15371953/memory-mapped-i-o-vs-port-mapped-i-o)

### Question 1-3
>Question 1-3: When we set GPIO pin to the input mode, we also need to config the GPIOx_PUPDR register to pull-up, pull-down or floating (non-pull-up, non-pull-down). What's the effect of these settings?
當我們將 GPIO pin 設成 input mode 的時候，還需要將 GPIOx_PUPDR 設成上拉，下拉或浮動（非上拉、非下拉）。這些設置有什麼作用？

- Floating input
(input為記憶體方接收來自設備的訊號源) 某個pin被設定為input mode會處於input impedance(輸入高阻抗狀態)，當input pin處於高阻抗的模式下，若沒有外部訊號源近來，此時是無法確定pin的狀態(不能確定現在處在高電位或低電位)，除非有外部訊號來驅動電路。總結，input電位狀態完全是由外部訊號來決定，沒有訊號驅動的話，就會呈現高阻抗狀態。

可能造成的影響: 造成設備發生誤動作
解法: Pull-up/Pull-down input

- l-up/Pull-down input
為什麼需要上拉電阻或是下拉電阻?

避免發生上述float狀態，無法判斷按鈕有按下或是沒有按下。

上述floating在沒有外部訊號驅動的情況下是呈現高阻抗狀態(無法確定電位狀態=>不能明確表示現在值是0或1)，如果我們需要這個pin有一個明確的預設狀態時，必須借助pull-up(pull-down)resistor來做調整，在pull-up resistor(**pull-up外接高電壓，也就是電阻一端連接Pin，一端連接+或VCC，按鈕一端接pin一端接GND，所以按鈕開關沒按下的時候讀取是HIGH，按下開關後會讀取到LOW**。pull-down通常會接地)讓pin的維持在明確的高電壓狀態 **pull-down則是讓pin維持在低電壓狀態，此時按鈕開關一端接到pin,另一端接到+ VCC，這樣在按鈕開關沒有按下時,讀取pin答案是LOW,當按下按鈕時,讀取pin則會得到HIGH**。 舉例來說，如果我們定電壓在3-4 V之間是1的狀態，0-1之間是0的狀態，高阻抗的時候，電壓是不明確的，有可能電壓值會落在1-3之間的不明確地帶，甚至是沒有在任何一個狀態維持一段時間，此時的狀態是未定的，但如果我們加入pull-up resistor的話，這個pin接受來自pull-up另一端的電壓供應，讓pin至少維持在3v以上時，我們就可以確定在沒有外部訊號驅動時，pin是維持在高電位狀態。

總結: Pull-up/Pull-down分別表示預設為High/Low。對應的外部設備動作，pull-up 隱含設備有動作時會拉 Low，pull-down 隱含設備動作時會拉 high

<br>

### 3.1 LED scroller
>Requirement
現場要能夠重現規格書中指定的跑馬燈樣式。必須要是 active low。透過 I/O register 面板觀察，亮燈時必須輸出訊號 0。

Question:

#### 請說明你是如何得到（或計算）每個時間點的 LED 圖案？

<br>

#### 說說在 active low 電路中 led 是如何被連接的？

![](https://i.imgur.com/AQbACfN.png)

Ref:
1. [聯發科Linkit 7688 （二）GPIO基本操作與C語言程式設計](https://itw01.com/2GIQSEN.html)
2. [低態動作 LED (Active Low LED)](http://coopermaa2nd.blogspot.com/2011/05/led-active-low-led.html)

<br>

#### (Coding) 請重新以 active high 的方式實作 3-1

1. 反轉01
2. LED燈反轉
3. 電路改接到GND

<br>

### 3.2 Push button switch
>Requirement
必須要可以暫停跟繼續。而不是 stop 或 reset。要能按壓按鈕使跑馬燈「暫停、繼續」三次，同學可以自己按按鈕。<br>
以下狀況出現超過三次則為未完成，將視情況扣分:<br>按下按鈕後沒有偵測到訊號，即按下按鈕後沒有暫停 / 繼續。<br>按下按鈕卻偵測到多次訊號。

Question

說說怎麽做到讓跑馬燈暫停再繼續的？

請說明是如何實作 debounce 的？

兩種方法: 
1. 先delay一段時間再看
2. 取多次1或0

### 3.3 combination lock
>Requirement
必須要使用網絡電阻(排阻)<br>
必須是 active low，即導通開關後收到的訊號為 0。<br>
助教隨機設定3組密碼且均能依照密碼正確性閃出對應的燈號。<br>

Question

說說排組如何使用及如何用一個網絡電阻接出電路圖上方的四個電阻？
