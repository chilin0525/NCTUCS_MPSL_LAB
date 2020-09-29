# LAB0

## Spec Question

### Question 1-1: How many general purpose registers does the arm cortex m4 processor have? (Arm cortex m4 處理器有多少一般目的暫存器?)

purpose registers: 13個

[ARM Develop: Processor core register summary](https://developer.arm.com/documentation/ddi0439/b/Programmers-Model/Processor-core-register-summary)

### Question 1-2: What's the flash memory and SRAM size of NUCLEO-L476RG? (NUCLEO-L476RG 的快閃記憶體與靜態隨機存取記憶體大小為多少？)

![](https://i.imgur.com/nTXWmW7.png)

上圖說明各板子型號的意義

此次課程的```series: STM32L4```,``` Board: NUCLEO-L476RG```

因此**Flash memory size=1M bytes**

以及**128K SRAM**

[STM32 NUCLEO User Manual P.7](https://hackmd.io/@GrassLab/SycDfiD4v/https%3A%2F%2Fstorage.googleapis.com%2Fmpsl_general%2Freference%2FUM1724-STM32-NUCLEO-User-Manual.pdf?type=book&view)

[Microcontroller features](https://os.mbed.com/platforms/ST-Nucleo-L476RG/)

### Question 1-3: What’s the beginning address of SRAM? Find the memory map. 靜態隨機存取記憶體的起始位置為多少？找出記憶體映射表。

<br>

### 2.1 Please refer to the sample code below, and create a file named "main.s" under the project "Lab0", build the project and observe how the program runs through the debugger tool. 請參考下面的範例程式，並在專案 "Lab0" 底下創建一個名為“ main.s”的檔案，建置該專案並透過 Debugger 工具觀察程式如何運行。

```assembly=
    .syntax unified
    .cpu cortex-m4
    .thumb
    
    .text
        .equ X, 0x55
        .equ Y, 0x01234567
    .global main
    main:
        movs r0, #X
        ldr r1, =Y
        adds r2, r0, r1
    L: B L

```

### Require 2-1: Observe the value of registers in the register monitor window. 在暫存器監測視窗中觀察暫存器的變化。

首先常數轉換: ```0x55=D'85``` ```0x1234567=D'19088743```

第10行後 r0變為85

第11行後 r1變為19088743

最後第12行 r2變為19088828(即r0+r1)


### Require 2-2: Observe the compiled .elf file by external tools. 使用外部工具觀察編譯後的 .elf 檔。

![](https://i.imgur.com/Gp6d3L1.png)


### Question 2-1: Is there any difference between the code disassembled by external tools and our source code. 透過反組譯工具所得到的程式碼與我們的原始碼內容上有和不同？

![](https://i.imgur.com/yTbyRad.png)

<br>

### 2.3. Variable declaration and Memory observation 變數宣告與記憶體觀察 Please follow the sample code below to modify "main.s" and observe the change of the memory value through the memory browser. 請按照以下面範例程式修改“ main.s”，並通過記憶體瀏覽器觀察記憶體內存的變化。

```assembly
    .syntax unified
    .cpu cortex-m4
    .thumb
.data
    X: .word 100
    str: .asciz "Hello World!"
.text
    .global main
    .equ AA, 0x55
main:
    ldr r1, =X
    ldr r0, [r1]
    movs r2, #AA
    adds r2, r2, r0
    str r2, [r1]
    ldr r1, =str
    ldr r2, [r1]
L: B L
```

### Require 3-1: Show the memory content of variable "X" and "str" by memory browser.透過記憶體瀏覽器顯示變數 X 和 str 的記憶體内容。

初始狀態:

```assembly
.data
    X: .word 100
    str: .asciz "Hello World!"
```

![](https://i.imgur.com/cn1Dy1O.png)

---

```assembly
ldr r1, =X
```

把x的位置放到r1，因此r1=536870912=0x20000000

![](https://i.imgur.com/eOtWjTj.png)

這時候利用memory browser到0x20000000查看該記憶體內容為何，
目前這個記憶體內容為0x64=D'100，因此下個指令```ldr r0, [r1]```做完r0應該等於100，
(若圖片過小的話可以右鍵點選另開分頁查看)

![](https://i.imgur.com/FGbsJl8.png)



---

```assembly
ldr r0, [r1]
```

把x記憶體位置上的值放到r0內

![](https://i.imgur.com/bCNPg6W.png)

如我們上述所說r0變成100了

---

```assembly
movs r2, #AA
```

![](https://i.imgur.com/EjsXpXM.png)

由於AA=0x55，因此r2=85

---

![](https://i.imgur.com/XFXlIx8.png)

```assembly
adds r2, r2, r0
```

r2=r2+r0=100+85=185

---

![](https://i.imgur.com/oa0xJvB.png)

```assembly
str r2, [r1]
```

指令的意思是把r2的內容搬到r1的位址

實際上也確實符合

![](https://i.imgur.com/EvvuQuy.png)

![](https://i.imgur.com/nDB7sQE.png)

---

![](https://i.imgur.com/oLjDGqO.png)

```assembly
ldr r1, =str
```

r1應該會取得str的記憶體位址

![](https://i.imgur.com/LTiNgCi.png)

![](https://i.imgur.com/UXai8cF.png)

上圖的確顯示r1指向str的記憶體位址也就是0x20000004

該記憶體位址的內容是0x6c6c6548 

---

![](https://i.imgur.com/yenbMKA.png)

r2最後應該取得0x6c6c6548，而最後顯示的結果的確為0x6c6c6548= D'536870916

---

<br>

### Question 3-1: When did the memory content of variable "X" and "str" be initialized? Is it initialized during execution? 變數 X 和 str 的記憶體內容是何時被初始化的？是在程式執行過程中被初始化嘛的嘛？ 

### Question 3-2: What effect will the execution result have, if the variable X is declared in the text section? (Note: You can use external tools to verify your guess. ex: objdump, readelf, nm ...etc.)如果改將變量X宣告在 text section，對執行結果會產生什麼影響？(註：你可以使用外部工具驗證你的猜想。 例如：objdump，readelf，nm等。

### Question 3-3: What is the difference between the content of "r2" and the first 4 bytes of "str" in the memory after the program is executed? 程式執行完畢後"r2"的內容與 字串"str"在 memory 內的前4個 byte 內容有何差異？

### Question 3-4: Here we use the reserved word ".asciz" for string declaration. Is there any other way to declare the variable str, "Hello World!". If so, please explain one of them.這裡我們使用保留字 .asciz 進行字串宣告。還有什麼其他方法可以聲明變量str, “ Hello World！”。如果有，請解釋其中之一。

<br>

## DEMO Question

### live coding 2-1: In the sample code, we only read the first four bytes of “str”. Please modify the the code and read the next two bytes into r3. 在範例程式中，我們只讀出"str"前四個位元組，請修改程式將接下來的兩個位元組讀進 r3 暫存器。

### live coding 2-2: Please declare another variable Z in the bss section, it occupies 4 bytes . And do the following operation。 請在 data section 中再宣告一個變數 Z。該變數佔 4 bytes。並執行以下操作。Z ← X*3



### Demo: How did you known the memory address of the variable X? 你如何得知變數 X 的記憶體位址是多少？
