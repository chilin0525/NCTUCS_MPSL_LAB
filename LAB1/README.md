# LAB1

================Table of Content================

* [LAB1](#lab1)
    * [P1. Hamming distance 漢明距離](#p1-hamming-distance-漢明距離)
    * [3.2. Fibonacci serial 斐波那契數列](#32-fibonacci-serial-斐波那契數列)
    * [3.3. Bubble sort 氣泡排序](#33-bubble-sort-氣泡排序)

[Created By README_Table_of_Content_Generator By Chilin😎️😎️😎️](https://github.com/chilin0525/README_Table_of_Content_Generator)

<br>

## P1. Hamming distance 漢明距離

>The Hamming distance between two integers is the number of positions
at which the corresponding bits are different. Take 0xAB and 0xCD as
an instance. Since 0xAB = 0b1010 1011, 0xCD = 0b1100 1101, and
they have 4 different bits. The hamming distance between 0xAB and
0xCD is 4. 

>兩個整數之間的漢明距離是相應位不同的位置數。 以 0xAB 和 0xCD 為
例。由於 0xAB = 0b1010 1011，0xCD = 0b1100 1101，它們具有 4 個
不同的位元。 0xAB 和 0xCD 之間的漢明距離為 4。

> Requirement: Please modify the code provided below, calculate the
Hamming distance between two constants, and store the result in the
variable "result".
請修改下面提供的範例碼，計算兩個常數間的漢明距離，並將結果存放至
result 變數中。[Reference](https://en.wikipedia.org/wiki/Hamming_distance#Algorithm_example)


```assembly
.data
    result: .byte 0
.text
.global main
.equ X, 0x55AA00
.equ Y, 0xAA5500

main:
    movs R0, #X //This line will cause an error. Why?
    movs R1, #Y
    ldr R2, =result
    bl hamm
L: b L
hamm:
//TODO
bx lr
```

<br>

**Q: Test case**


|         |   X    |   Y    | ANSWER |
| ------- |:------:|:------:|:------ |
| input 1 | 0x55AA | 0xAA55 | 16     |
| input 2 | 0xAA55 | 0xAA55 | 0      |
| input 3 | 0x1234 | 0x5678 | 5      |
| input 4 | 0xABCD | 0xEFAB | 6      |

<br>

**Q :  What is the IT-block for ARM Assembly? What
are the condition code suffixes of ARM instruction? What is the difference between instruction ADD and ADDS?ARM 組合語言中的 IT-block 指的是甚麽？ARM 指令的條件碼後綴是什麼？指令 ADD 與 ADDS 之間有何差別？**

IT BLOCK是THUMB instruction set中尉了解決THUMB指令不能條件執行的缺點(原因應該是THUMB僅有16bit空間)。
THUMB-2 instruction並沒有如ARM instruction set那樣擁有4bit的condition code空間，因此THUMB-2提供了```IT``` instrution，其最多可以可以提供四條instruction進行condition control，而這些instrution我們稱它位於**IT BLOCK**內。


IT表示IF-THEN，如果condition code 被偵測為TRUE，那麼condition code的下一條instruction將會執行。最多可以有**3**個額外的T(THEN)或E(ELSE)接在指令後

```assembly
cmp     r0, #10
ite     lo        @ if r0 is lower than 10 ...
addlo   r0, #1    @ ... then r0 = r0 + 1
movhs   r0, #0    @ ... else r0 = 0
```

需要注意的是在IT BLOCK內的instruction必須包含condition code，Assemblers會檢查你給IT的狀態，如果滿足狀態執行該condition code的指令，否的話執行相反狀態的指令，所以IT block中僅能含有與IT相同狀態的instruction或是相反狀態的instruction

![](https://i.imgur.com/BqobVXz.png)


```assembly
main:
	mov 	r0, #11
        cmp     r0, #10
	itee    lo            @ if r0 is lower than 10 ...
	addlo   r0, #1       @then
	movhs   r0, #0       @else ,will exec
	movhs 	R1,#2        @else , will exec
```

<BR>

Conditione code 修飾instrution，並由condition code與condition flag決定此條instruction在一定狀態下才會執行

condition flag:

N - Negative 是否為負 第31 Bit Set to 1 when the result of the operation is negative, cleared to 0 otherwise.

Z - Zero 是否為零 第30 Bit Set to 1 when the result of the operation is zero, cleared to 0 otherwise.

C - Carry Unsighed 溢位 第29 Bit Set to 1 when the operation results in a carry, or when a subtraction results in no borrow, cleared to 0 otherwise.

V - Overflow sighed 溢位 第28 Bit Set to 1 when the operation causes overflow, cleared to 0 otherwise.

這些flags資訊都存在於APSR (Application Processor Status Register), or the CPSR (Current Processor Status Register)

![](https://i.imgur.com/yp90uUw.png)


ADD 與 ADDS 之間的差異在於前者做完運算之後不會更新condition flag(status register)，後者會做運算且更新

<br>

**Q : 請說明如何計算變數 X, Y 之間的漢明距離，如何統計有幾個相異的 bits**

```assembly
eor R4, R1, R2
```
將會先對R1，R2做Bitwise的exclusive or，並將結果傳入R4，所以R4中有多少個1就是多少漢銘距離

```assembly
LOOP:
    cmp R4,#0
    beq EXIT
    and R7,R4,#1 //AND{S}{cond} Rd, Rn, Operand2
    cmp R7,#1
    beq ADD
    mov R4,R4, LSR #1 // for 0 in r4
b LOOP
```
接著先對R4和0做Compare，如果R4中沒有任何一個0可以直接結束不用特別再去數有多少個1在R4裡面; 如果compare的結果為不同，那往下進行AND，並把結果存到R7之中，如果R7是1的話表示R4最右邊的bit也是1，此時需要呼叫ADD對負責在進行累加的R6加1，並且同時利用邏輯右移把R4最右邊的Bit擠掉，一直到R4都為0沒有任何1了就可以結束檢查流程並且把答案回給Result

<br>

Q : 請說明程式是如何從 hamm 函數跳回到 main 函數中

```assembly
bx lr
```

<br>

<br>


## 3.2. Fibonacci serial 斐波那契數列

>The original problem that Fibonacci investigated (in the year 1202) was about how fast rabbits could breed in ideal circumstances. Let Fn denote the number of newborn rabbit(s) at the n th month under the ideal condition. Fn can be modeled as the following formula.
斐波那契調查的最初問題（在1202年）是關於兔子在理想情況下的繁殖速
度。 令 Fn 表示理想條件下第 n 個月新生兔的數量。 Fn 可以按以下公式
建模。

>F0 = 0, 
F1 = 1,
Fn = Fn-1 + Fn-2 , n>2

>Reference: https://it.wikipedia.org/wiki/Successione_di_Fibonacci
Requirement: Please modify the code provided below, and implement a
subroutine "fib" which accepts a parameter N("r0") where 0 ≤ N ≤ 100
and it will store the the n
th Fibonacci Number into "r4". The value of "r4"
should be interpreted as a signed integer. If the result of Fn overflows,
set "r4" to "-2". If the value of N exceeds the boundary, set "r4" to "-1".

>請修改下面提供的程式，並實現子程序 "fib"，該程序接受一個參數 N(r0)
，其中 0≤N≤100，並將第 n 個斐波那契數 Fn 存儲到 "r4" 中。其中，" r4"的值應解讀為有號整數。如果 Fn 的結果溢位，則將 "r4" 設為 " -2"。 如果N 的值超出範圍，則將 " r4" 設置為 " -1"。

```assembly
.text
.global main
.equ N, 20

fib:
//TODO
bx lr
main:
    movs R0, #N
    bl fib
L: b L
```

<br>

Q: How to detect overflow by software? That is,
using an algorithm or logical operation to detect overflow.
如何通過軟體檢測溢位？即使用演算法或是邏輯判斷的方式偵測溢位。

若累積超過導致overflow發生的話累積的register將會變為負數，因此只要檢查r4是否變成負數即可

<br>

Q: Does ARMv7-M provide any hardware support on overflow detection?ARMv7-M 是否在溢出檢測方面提供任何硬體支持？

**Program Status Registers**中的condition flag

可以替instruction加上s後透過condition flag查看是否有overflow


<br>

Q: 請說明程式是如何計算 Fn

Q: 請說明如何判斷 N 值是否超出範圍 (100<N or N<0)

```assembly
main:
    movs R0,#N
    movs R1,#0
    movs R2,#1
    movs R4,#0
    bl fib
```

初始化n=0與n=1的情況並且呼叫fib開始並開始計算fib

```assembly
fib:
    cmp R0,#100
    bgt OVER //>
    cmp R0,#0
    blt OVER //<
```

先判斷N是否超出範圍 式的話branch到```OVER```並將-1傳入R4

```assembly
LOOP:
     cmp R0,#0
     beq EXIT
     cmp R0,#1
     beq ONE

     sub R0,R0,1
     add R4,R2,R1
     cmp R4,#0
     ble FLOW //<=
     mov R1,R2
     mov R2,R4

     cmp R0,#1 //r0=1 return
     beq EXIT
     b LOOP
```

如果r0等於0或1的話需要特判，分別呼叫```EXIT```跟```ONE```將正確結果傳入R4

如果非0或1的話，共需要進行N-1次計算，因此```R4=R1+R2```，可以算出N=2的答案，再將答案傳回R1或R2重複利用，直到做完N-1次計算得到答案才跳離

<br>

## 3.3. Bubble sort 氣泡排序
>Bubble sort is a simple sorting algorithm that repeatedly steps through the list, compares adjacent elements and swaps them if they are in the
wrong order.
冒泡排序是一種簡單的排序算法，透過反覆遍歷串列，比較相鄰元素並對
排序錯誤的元素進行置換。

>Requirement: Please modify the code provided below and implement a subroutine "do_sort" that accepts a parameter "arr", which points to a list containing 8 unsigned characters (each occupy 1 byte), and it will do the
in-place sorting (in descending order). Note that it is required to use "R0" passing the argument and show the sorting process step by step in the
memory browser (or memory viewer).
請修改下面提供的代碼，並實現一個子程序 "do_sort" ，該程序接受一個
參數 "arr" 其指向包含 8 個無號字符（每個字符佔 1 個位元組）的列表，
並將進行 in-place 排序（降序）。請注意必須使用 "R0" 傳遞引數，並在
內存瀏覽器（或內存查看器）中逐步顯示排序過程。

```assembly
.data
arr1: .byte 0x19, 0x34, 0x14, 0x32, 0x52, 0x23, 0x61, 0x29
arr2: .byte 0x18, 0x17, 0x33, 0x16, 0xFA, 0x20, 0x55, 0xAC
.text
.global main
do_sort:
//TODO
bx lr
main:
ldr r0, =arr1
bl do_sort
ldr r0, =arr2
bl do_sort
L: b L
```

>Hint: The memory access may require the instructions that support
byte-alignment, such as STRB, LDRB.
提示：記憶體存取需使用 byte alignment 指令，例如：STRB, LDRB。

Q: live coding 1 請將 Require 3-3 從遞減排序改為遞增排序。

Q: 在 Require 3-3 我們以 .byte 為單位宣告 arr1, arr2，請將 .byte 改為 .word，重新實作 Require 3-3。
