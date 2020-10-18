# GPIO

IO裝置的溝通是透過CPU，但對CPU而言只認記憶體，**透過記憶體**控制IO裝置，目前記憶體中有一塊是IO address，各自拉到相對應的IO裝置(網卡、音效卡等等)，並非拿來當作儲存data用的一般memory。ex:要點量某一顆燈-->只要知道他對應的address把其設為一即可

因此從memory store or load資料進來都是一樣的指令，只是會因為你讀取的memory位置有不同意義。

![](https://i.imgur.com/NVumdxM.png)

![](https://i.imgur.com/ruKdFDA.png)

一般而言共有port  A到port H可用，除了PH外皆為16 bit

<br>

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

<br>

## Floating input v.s Pull-up/Pull-down input

### Floating input

(input為記憶體方接收來自設備的訊號源)
當input pin處於高阻抗的模式下，若沒有外部訊號源近來，此時是無法確定pin的狀態(不能確定現在處在高電位或低電位)，除非有外部訊號來驅動電路。總結，**input電位狀態完全是由外部訊號來決定，沒有訊號驅動的話，就會呈現高阻抗狀態。**

* 可能造成的影響: 造成設備發生誤動作
    * 解法: Pull-up/Pull-down input

### Pull-up/Pull-down input

上述floating在沒有外部訊號驅動的情況下是呈現高阻抗狀態(無法確定電位狀態=>不能明確表示現在值是0或1)，如果我們需要這個pin有一個明確的預設狀態時，必須借助pull-up(pull-down)resistor來做調整，**在pull-up resistor(pull-up外接高電壓，pull-down通常會接地)讓pin的維持在明確的高電壓狀態(pull-down則是讓pin維持在低電壓狀態)**。舉例來說，如果我們定電壓在3-4 V之間是1的狀態，0-1之間是0的狀態，高阻抗的時候，電壓是不明確的，有可能電壓值會落在1-3之間的不明確地帶，甚至是沒有在任何一個狀態維持一段時間，此時的狀態是未定的，但如果我們加入pull-up resistor的話，這個pin接受來自pull-up另一端的電壓供應，讓pin至少維持在3v以上時，我們就可以確定在沒有外部訊號驅動時，pin是維持在高電位狀態。

總結: Pull-up/Pull-down分別表示預設為High/Low。對應的外部設備動作，pull-up 隱含設備有動作時會拉 Low，pull-down 隱含設備動作時會拉 high

Ref: 
1. [為什麼 GPIO input 要用 pull-up/pull-down，output 要用 push-pull 或 open-drain?](https://tfing.blogspot.com/2019/10/gpio-input-pull-uppull-downoutput-push.html)
2. [浮接 Floating 是甚麼? 電路的不確定因素](https://www.strongpilab.com/input-high-z-floating/)


## Push-Pull v.s Open-Drain Output
 
有兩種output模式 分別為Push-Pull與Open-Drain Output

### Push-Pull

利用 P-MOS 或是 N-MOS 來動作

內部驅動電力，速度較快

### Open-Drain

外界提供電壓

<br>

## Pull-up v.s Pull-down

上拉電阻或是下拉電阻

### Pull-up


### Pull-down

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

點亮Port A LED燈
