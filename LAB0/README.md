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

### 2.1 Please refer to the sample code below, and create a file named "main.s" under the project "Lab0", build the project and observe how the program runs through the debugger tool. 請參考下面的範例程式，並在專案 "Lab0" 底下創建一個名為“ main.s”的檔案，建置該專案並透過 Debugger 工具觀察程式如何運行。

```assembly
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

### Require 2-2: Observe the compiled .elf file by external tools. 使用外部工具觀察編譯後的 .elf 檔。

### Question 2-1: Is there any difference between the code disassembled by external tools and our source code. 透過反組譯工具所得到的程式碼與我們的原始碼內容上有和不同？

<br>

## DEMO Question

### live coding 2-1: In the sample code, we only read the first four bytes of “str”. Please modify the the code and read the next two bytes into r3. 在範例程式中，我們只讀出"str"前四個位元組，請修改程式將接下來的兩個位元組讀進 r3 暫存器。

### live coding 2-2: Please declare another variable Z in the bss section, it occupies 4 bytes . And do the following operation。 請在 data section 中再宣告一個變數 Z。該變數佔 4 bytes。並執行以下操作。Z ← X*3



### Demo: How did you known the memory address of the variable X? 你如何得知變數 X 的記憶體位址是多少？
