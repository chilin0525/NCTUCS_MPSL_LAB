# GPIO

IO裝置的溝通是透過CPU，但對CPU而言只認記憶體，**透過記憶體**控制IO裝置，目前記憶體中有一塊是IO address，各自拉到相對應的IO裝置(網卡、音效卡等等)，並非拿來當作儲存data用的一般memory。ex:要點量某一顆燈-->只要知道他對應的address把其設為一即可

因此從memory store or load資料進來都是一樣的指令，只是會因為你讀取的memory位置有不同意義。

![](https://i.imgur.com/NVumdxM.png)

![](https://i.imgur.com/ruKdFDA.png)

一般而言共有port  A到port H可用，除了PH外皆為16 bit

<br>

## Port Address

![](https://i.imgur.com/AUmeHsh.png)


## IO方式

### Port-Mapped I/O (PMIO)

CPU具有特殊的指令，這些指令下達input或是output時某些接腳就會動起來，所以只要接腳連到所需要的IO裝置上(燈或keyboard等等)，就可以透過input或是output跟IO裝置產生互動

### Memory Mapped I/O(MMIO)

多一塊記憶體當作control register用，所以不能隨便mov東西進去，因為一旦mov進去就代表你要與IO溝通，這塊記憶體是保留用來控制IO或是讀取用的記憶體

<br>

![](https://i.imgur.com/D5VkQGo.png)

在上圖中我們可以看到Port A從0x48000000開始到0x480007FF，明明Port A只有16bit卻需要那麼多空間-->因為Port是General Purpose的，根據不同情況你會希望Port做到相對應的事情，因此設計者留下彈性讓使用者決定，因此可以設定成不同模式，所以有許多設定工作需要先做好

<br>

## Port前置設定

![](https://i.imgur.com/q7gQyJb.png)

- GPIO port **mode** register : 這個bit要當input還是output用?
    - input/output方向: input為記憶體方接收來自設備的訊號源，output指記憶體送訊號給設備
- GPIO port output **type** register :  Push-Pull 或 Open-Drain Output
- GPIO port output **speed** register : setting output speed
- GPIO port pull-up/pull-down register :  

需要先打開port A -> 再config port A -> 再input output port A

![](https://i.imgur.com/l9kCA1I.png)
![](https://i.imgur.com/w7hXcRN.png)
![](https://i.imgur.com/pTX1qHI.png)
![](https://i.imgur.com/BJkhHdo.png)
![](https://i.imgur.com/mdKGqAs.png)
![](https://i.imgur.com/XXM5pak.png)
![](https://i.imgur.com/OrI51UP.png)


<br>

## Floating input v.s Pull-up/Pull-down input

### Floating input

(input為記憶體方接收來自設備的訊號源)
某個pin被設定為input mode會處於input impedance(輸入高阻抗狀態)，當input pin處於高阻抗的模式下，若沒有外部訊號源近來，此時是無法確定pin的狀態(不能確定現在處在高電位或低電位)，除非有外部訊號來驅動電路。總結，**input電位狀態完全是由外部訊號來決定，沒有訊號驅動的話，就會呈現高阻抗狀態。**

* 可能造成的影響: 造成設備發生誤動作
    * 解法: Pull-up/Pull-down input

### Pull-up/Pull-down input

為什麼需要上拉電阻或是下拉電阻?

避免發生上述float狀態，無法判斷按鈕有按下或是沒有按下。

上述floating在沒有外部訊號驅動的情況下是呈現高阻抗狀態(無法確定電位狀態=>不能明確表示現在值是0或1)，如果我們需要這個pin有一個明確的預設狀態時，必須借助pull-up(pull-down)resistor來做調整，**在pull-up resistor(pull-up外接高電壓，也就是電阻一端連接Pin，一端連接+或VCC，按鈕一端接pin一端接GND，所以按鈕開關沒按下的時候讀取是HIGH，按下開關後會讀取到LOW。pull-down通常會接地)讓pin的維持在明確的高電壓狀態
pull-down則是讓pin維持在低電壓狀態，此時按鈕開關一端接到pin,另一端接到+ VCC，這樣在按鈕開關沒有按下時,讀取pin答案是LOW,當按下按鈕時,讀取pin則會得到HIGH**。
舉例來說，如果我們定電壓在3-4 V之間是1的狀態，0-1之間是0的狀態，高阻抗的時候，電壓是不明確的，有可能電壓值會落在1-3之間的不明確地帶，甚至是沒有在任何一個狀態維持一段時間，此時的狀態是未定的，但如果我們加入pull-up resistor的話，這個pin接受來自pull-up另一端的電壓供應，讓pin至少維持在3v以上時，我們就可以確定在沒有外部訊號驅動時，pin是維持在高電位狀態。

總結: Pull-up/Pull-down分別表示預設為High/Low。對應的外部設備動作，pull-up 隱含設備有動作時會拉 Low，pull-down 隱含設備動作時會拉 high

Ref: 
1. [為什麼 GPIO input 要用 pull-up/pull-down，output 要用 push-pull 或 open-drain?](https://tfing.blogspot.com/2019/10/gpio-input-pull-uppull-downoutput-push.html)
2. [浮接 Floating 是甚麼? 電路的不確定因素](https://www.strongpilab.com/input-high-z-floating/)
3. [【小常識】從按鈕開關看上拉pull-up電阻下拉電阻是蝦密碗糕](https://www.arduino.cn/thread-13186-1-1.html)
4. [成大資工General Purpose Input/Output (GPIO)](http://wiki.csie.ncku.edu.tw/embedded/GPIO)


## Push-Pull v.s Open-Drain Output
 
有兩種output模式 分別為Push-Pull與Open-Drain Output

### Push-Pull

利用 P-MOS 或是 N-MOS 來動作

內部驅動電力，速度較快

### Open-Drain

外界提供電壓


<br>

## GPIO config

![](https://i.imgur.com/H0WhlbW.png)

PUPO: 上拉電阻或是下拉電阻

以Mode=00與PUPD=00為例: mode為input，且input為floating


![](https://i.imgur.com/Ruem7TC.png)

<br>

```assembly
    .syntax unified
    .cpu cortex-m4
.thumb
.data
.text
.global main
//move infix_expr here. Please refer to the question below.

.equ RCC_AHB2ENR, 0x4002104C
.equ GPIOA_MODER, 0x48000000
.equ GPIOA_OYTPER,0x48000004
.equ GPIOA_OSPEEDR, 0x48000008
.equ GPIOA_PUPDR, 0x4800000C
.equ GPIOA_ODR, 0x48000014

main:
	mov r0,#0x1
	ldr r1, =RCC_AHB2ENR
	str r0, [r1]
	
	movs r0, #0x400
	ldr  r1, =GPIOA_MODER
	ldr  r2, [r1]
	and  r2, #0xFFFFF3FF
	orrs r2, r2, r0
	str  r2, [r1]

	movs r0, #0x800
	ldr  r1, =GPIOA_OSPEEDR
	strh r0, [r1]

	ldr r1,=GPIOA_ODR
L1:
	movs r0, #(1<<5)
	strh r0,[r1]

	B L1
```

點亮Port A第5 Bit的LED燈(Build All -> Run)

注意設定Output Register時的設定方法，不可以去影響到其他人

外接LED燈實驗:

藍線接地，橘色則是接到板子Pin角PC8的位置

![](https://i.imgur.com/IAiks1I.jpg)

程式碼如下:

```assembly
	.syntax unified
	.cpu cortex-m4
	.thumb
.data
	leds: .byte 0
.text
	.global main
	.equ RCC_AHB2ENR, 0x4002104C
	.equ GPIOB_MODER, 0x48000400
	.equ GPIOB_OTYPER, 0x48000404
	.equ GPIOB_OSPEEDR, 0x48000408
	.equ GPIOB_PUPDR, 0x4800040C
	.equ GPIOB_ODR, 0x48000414
	.equ GPIOC_MODER, 0x48000800
	.equ GPIOC_ODR, 0x48000814
	.equ delay_time, 4000000

main:
    BL GPIO_init

Loop:
    B Loop

GPIO_init:
   mov R0,#4
   ldr r1,=RCC_AHB2ENR
   str r0,[r1]

   mov r0,0x00010000
   ldr r1,=GPIOC_MODER
   str r0,[r1]

   ldr r1,=GPIOC_ODR
   mov r0,0x00000100
   str r0,[r1]

   bx lr

```

<br>

## 設定GPIO output Register

如上述，在設定GPIO output register時可以使用特定方法避免直接mov資料進去ODR裏頭

### BSSR

![](https://i.imgur.com/GulHRpx.png)

<font color="orange" size=5>講義的語法有問題</font>
