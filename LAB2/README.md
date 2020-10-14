# LAB2

================Table of Content================

* [LAB2](#lab2)
    * [P1](#p1)
        * [Algorithm](#algorithm)
        * [ADD Multiword in ARM](#add-multiword-in-ar)
        * [SUB Multiword in ARM](#sub-multiword-in-arm)
        * [MUL Multiword in ARM](#mul-multiword-in-arm)
        * [0xffff*0xffff](#0xffff*0xffff)
        * [(0xffff+0xffff)*(0xffff+0xffff)](#0xffff+0xffff*0xffff+0xffff)
        * [STRD](#strd)
    * [P2](#p2)
        * [Init stack pointer](#init-stack-pointer)
        * [STM LDM](#stm-ldm)
    * [P3](#p3)
    * [Demo CheetSheet](#demo-cheetsheet)
        * [Spec_Qustion](#spec_qustion)
        * [P1_TestCase](#p1_testcase)
        * [Q1-1](#q1-1)
        * [Q1-2](#q1-2)
        * [P2_TestCase](#p2_testcase)
        * [Q2-1 ](#q2-1-)
        * [P3_TestCase](#p3_testcase)
        * [Q3-1](#q3-1)
        * [live coding Q3](#live-coding-q3)

[Created By README_Table_of_Content_Generator By Chilin😎️😎️😎️](https://github.com/chilin0525/README_Table_of_Content_Generator)

<br>

## P1
>Requirement: Please implement the Karatsuba algorithm which accepts two 32-bit unsigned integers "X, Y", and stores the result of X times Y into the variable “result”.請實現 Karatsuba 算法，該算法接受兩個32位元無號整數 "X, Y"，並將 X乘以 Y 的結果存儲到變量 "result" 中。
(Hint: The output can be a 64-bits integer. You may need these instructions,
ADC, STRD.提示：輸出可能為 64 位元整數。 您可會用到 ADC, STRD 這些指令。只要拆成 16-bits 後直接計算就可以)

<br>

### Algorithm

![](https://i.imgur.com/bmfpCHw.png)


Z1需要shift 32bit，Z2需要shift 16bit，最終做法是把R3切半，後半段補0後與Z2相加，Z1再與Z3前半段相加即可

REF:[[算法系列之九]Karatsuba快速相乘算法](https://blog.csdn.net/SunnyYoona/article/details/43234889)

### ADD Multiword in ARM

```assembly
ADDS    r4, r0, r2    ; adding the least significant words
ADC     r5, r1, r3    ; adding the most significant words
```

### SUB Multiword in ARM

```assembly
SUBS    r3, r6, r9
SBCS    r4, r7, r10
SBC     r5, r8, r11
```

### MUL Multiword in ARM

```Op{cond}{S} RdLo, RdHi, Rm, Rs```

The ```UMULL``` instruction interprets the values from Rm and Rs as **unsigned integers**. It multiplies these integers and places the least significant 32 bits of the result in RdLo, and the most significant 32 bits of the result in RdHi.

The ```UMLAL``` instruction interprets the values from Rm and Rs as **unsigned integers**. It multiplies these integers, and adds the 64-bit result to the 64-bit unsigned integer contained in RdHi and RdLo.

The ```SMULL``` instruction interprets the values from Rm and Rs as **two's complement signed integers**. It multiplies these integers and places the least significant 32 bits of the result in RdLo, and the most significant 32 bits of the result in RdHi.

The ```SMLAL``` instruction interprets the values from Rm and Rs as **two's complement signed integers**. It multiplies these integers, and adds the 64-bit result to the 64-bit signed integer contained in RdHi and RdLo.

```assembly
UMULL       r0,r4,r5,r6
UMLALS      r4,r5,r3,r8
SMLALLES    r8,r9,r7,r6
SMULLNE     r0,r1,r9,r0 ; Rs can be the same as other
                        ; registers
```

### 0xffff*0xffff

```assembly
main:
    LDR R5, =t	// 0xffff
    mov R6,R5	// 0xffff	
    mul R7,R5,R6 //0xfffe0001
    mov R8,R7	//0xfffe0001
    adds R9,R7,R8 //0xfffc0002
    adc R10,#0
    LDR R2, =result
nop
```

### (0xffff+0xffff)*(0xffff+0xffff)

```assembly
main:
    LDR R5, =t //0xffff
    mov R6,R5  //0xffff
    add R7,R5,R6 //0x1fffe
    mov r6,r7	 //0x1fffe
    UMULL r3,r4,r7,r6 // 0x3fff80004(R3=Rdlo R4=RDhi)
    LDR R2, =result
```

REF:
1. [Multiword arithmetic example ADD](https://www.keil.com/support/man/docs/armasm/armasm_dom1361289861367.htm)
2. [Multiword arithmetic examples SUB](https://www.keil.com/support/man/docs/armasm/armasm_dom1361289908389.htm)
3. [Arm Developer : UMULL, UMLAL, SMULL and SMLAL](https://developer.arm.com/documentation/dui0068/b/arm-instruction-reference/arm-multiply-instructions/umull--umlal--smull-and-smlal?lang=en)
4. [stackoverflow : How to get the low 16-bit half-word most efficiently on ARM (ARM7TDMI)?](https://stackoverflow.com/questions/40899113/how-to-get-the-low-16-bit-half-word-most-efficiently-on-arm-arm7tdmi)
5. [Assembly Language Programming Arithmetic Shift Operations](http://www-mdp.eng.cam.ac.uk/web/library/enginfo/mdp_micro/lecture4/lecture4-3-3.html) 
6. [Assembly Language Programming Rotate Operations](http://www-mdp.eng.cam.ac.uk/web/library/enginfo/mdp_micro/lecture4/lecture4-3-4.html)


### STRD
spec中提到因為相乘後可能為64bit，因此可能需要STRD存答案，而STRD(store double word) 其實等價於str [r?] str [r?,#4] 可以參考[這篇](https://www.zhihu.com/question/55122474)

<br>


---

## P2



### Init stack pointer

在LAB當中助教要求一塊空間並且讓stack pointer指向此塊記憶體空間，首先，```sp```內部存放的應該為一個memory address，之後push或pop時都會以此address做為基準。stack pointer在ARM中的行為較為特別，為**full-descending stack model**，也就是stack pointer在放完資料後是往下減4byte的，非往上加(另一種模式是用加，不同架構不同方式)，因此在取得該塊記憶體空間後，還要先往上加該記憶體空間的大小後再丟進sp裡面才算完成

### STM LDM

上述提到的full-descending stack model為default狀態，我們可以透過```STM```與```LDM```去implement stack pointer的操作，這樣就不限至於full-descending stack model的狀態，可以調整stack pointer是增加不是減少，或是stack pointer是指向下一個空資料的memory address或是最後一筆資料處:

***Descending or ascending*** 也就是控制stack pointer是做完事情之後是增加也是減少

***Full or empty*** 操作完stack pointer是指向stack中的last item還是指向下一個stack中的free space(即下一個位置)

**Default**的PUSH與POP為full-descending stack model

<br>

![](https://i.imgur.com/DDk9wDs.png)

![](https://i.imgur.com/1kCpiUv.png)

![](https://i.imgur.com/r6EGXkF.png)

Nice Ref:
1. [stackoverflow : Push and Pop in arm](https://stackoverflow.com/questions/27095099/push-and-pop-in-arm/27095517)
2. [Cortex M0+ : Stack Memory](https://www.sciencedirect.com/topics/engineering/stack-memory) 
3. [4.15 Stack implementation using LDM and STM](https://www.keil.com/support/man/docs/armasm/armasm_dom1359731152499.htm)
4. [STACK AND FUNCTIONS](https://azeria-labs.com/functions-and-the-stack-part-7/) 

<br>

---


## P3


<br>

---


## Demo CheetSheet

### Spec_Qustion

>Question 1: What is "caller-save register"? What is "callee-save register"? What
are their pros and cons?
甚麼是 caller-save register? 甚麽是 "callee-save register"? 各有甚麽優缺點？



|  | caller-save register | callee-save register |
|:-------- | -------------------- | -------------------- |
| 優       | callee可以任意使用register 不需要事先存起來，會有更好的perfermence                     |    僅需存callee要使用的register                  |
| 缺       | caller需要存所有register，但callee可能不用用到那麼多register                 |  不可以任意使用register 需要事先存起來               |


>Question 3: When recursive functions are executing the self-calling. Which
registers should be backed up to stack?
當遞迴函數在執行自調用時。哪些暫存器應該要被備份到記憶體堆疊？

需要備份function所用到的register與lr

>Question4: If we want to use STM, LDM instructions to replace POP, PUSH
instructions. Which suffix should be added?
如果我們想用 STM, LDM 指令來取代 POP, PUSH 指令。分別該加上哪種
後綴？

![](https://i.imgur.com/1kCpiUv.png)

![](https://i.imgur.com/r6EGXkF.png)

Example:

```assembly
main:
   	mov r0,#12
	mov r1,#16
   	STMDB sp!,{r0}
	//push {r1}
	LDMIA sp!,{r2}
```

<br>


### P1_TestCase

- [x] 0x12345678 * 0xABCDEF00 = 0xc379aaa42d20800
- [x] 0xFFFFFFFF * 0xFFFFFFFF = 0XFFFFFFFE00000001
    - [x] 0xFFFF*0xFFFF=0xFFFE0001
    - [x] 0xFFFF+0xFFFF=0x1FFFE
    - [x] 0xffff*0xffff+0xffff*0xffff=0x1fffc0002
    - [x] (0xFFFF+0xFFFF)*(0xFFFF+0xFFFF)=0x3FFF80004
- [x] 0x46789214*0xBCDABADC = 0x33fcc1633ec81130

### Q1-1

>32-bits 無號整數相乘的最大結果為 64-bits 無號整數，因此需要使用兩個暫存器來儲存。在公式中 $2^{n/2} * [(X_L + X_R)(Y_L + Y_R) - (X_LY_L + X_RX_R)]$ 項的結果並不屬於任何一個暫存器。同學這部份如何解決？

![](https://i.imgur.com/bmfpCHw.png)

這題也就是問中間跨越兩個register是如何解決，我們的解決方式就是拆成前後兩塊，前塊與shift n bit的相加 ; 後半補0後與不用shift的相加就是答案

### Q1-2

> 我們使用低 32 位元的暫存器來存 result，但有時候可能需要進位到高 32 位元。這部份如何處理？

處理ADD Multiword in ARM的技巧，後半相加後記得更新condition flag，前半段做相加時就會利用```ADC```就有辦法加到carry了

```assembly
ADDS    r4, r0, r2    ; adding the least significant words
ADC     r5, r1, r3    ; adding the most significant words
```

<br>


### P2_TestCase

- [x] { -99+ [ 10 + 20 - 0] } 
- [x] { -99+ [ 10 + 20 - 10 }
- [x] {[{}]}
- [x] {[{[{{{{[]}}}}]}]}
- [x] {[{[{{2{{[123]}}3}}123]}1]2}
- [x] {[] 
- [x] {
- [x] [
- [x] {[
- [x] }
- [x] ]
- [x] }]}]

### Q2-1 

>請說明如何初始化 sp (應該要把 sp 指向哪裡)？

```assembly
stack_init:
    LDR R1, =user_stack_bottom
    ADD R1,R1,#128
    MOV sp, R1
    MOV R2, sp // R2: check for init sp
    BX LR
```

先把```user_stack_bottom```的addess拿到後，因為ARM default的mode是full-descending stack model，因此每push一次sp會減4byte，所以要先從```user_stack_bottom```的addess往上加128byte擴充stack空間，最後在move給sp即可

<br>


### P3_TestCase

[REF:GCD calculator](http://www.alcula.com/calculators/math/gcd/#gsc.tab=0)

- [x] GCD(94(0x5E),96(0x60)) = 2
- [x] GCD(39(0x27),65(0x41)) = 13
- [x] GCD(1,1) = 1
- [x] GCD(1,2) = 1
- [x] GCD(23,100) = 1
- [x] GCD(25,100) = 25
- [x] GCD(1,0) = 1
- [x] GCD(0,1) = 1
- [x] GCD(0,0) = 0
- [x] GCD(2,2) = 2
- [x] GCD(1234587,54525) = 3
- [x] GCD(1234587,5452554) = 3
- [x] GCD(5421354,58313562) = 6 
- [x] GCD(3122712,46840680) = 3122712

### Q3-1

> 請說明為何在遞迴呼叫的時候，我們需要備份 LR？請問同學是在甚麽時候備份 LR 的？備份時機有甚麼特別的要求嗎？

因為LR使用BL時自動把memory中的next instruction儲存起來的地方，但是多次的呼叫將會導致BL中的address被蓋過去，若沒有將LR PUSH到stack中的話那麼可能會沒辦法return到正確的位置上
在再次呼叫自己前PUSH即可

### live coding Q3

>請修改 Require 3-3。計算在 recursion 過程中，記錄最多用了多少 stack size (以 byte 為單位)，並將它存進 max_size 這個變數中。

[live coding Q3 PICK ME](https://github.com/chilin0525/NCTUCS_MPSL_LAB/blob/master/LAB2/README.md)
