# LAB2

## Note

### P1 
Requirement: Please implement the Karatsuba algorithm which accepts two 32-bit unsigned integers "X, Y", and stores the result of X times Y into the variable “result”.請實現 Karatsuba 算法，該算法接受兩個32位元無號整數 "X, Y"，並將 X乘以 Y 的結果存儲到變量 "result" 中。
(Hint: The output can be a 64-bits integer. You may need these instructions,
ADC, STRD.提示：輸出可能為 64 位元整數。 您可會用到 ADC, STRD 這些指令。只要拆成 16-bits 後直接計算就可以)

#### Algorithm

![](https://i.imgur.com/DA0KxW5.png)

Z1需要shift 32bit，Z2需要shift 16bit，最終做法是把R3切半，後半段補0後與Z2相加，Z1再與Z3前半段相加即可

REF:[[算法系列之九]Karatsuba快速相乘算法](https://blog.csdn.net/SunnyYoona/article/details/43234889)

#### ADD Multiword in ARM

```assembly
ADDS    r4, r0, r2    ; adding the least significant words
ADC     r5, r1, r3    ; adding the most significant words
```

REF:
1. [Multiword arithmetic example](https://www.keil.com/support/man/docs/armasm/armasm_dom1361289861367.htm)
2. [stackoverflow : How to get the low 16-bit half-word most efficiently on ARM (ARM7TDMI)?](https://stackoverflow.com/questions/40899113/how-to-get-the-low-16-bit-half-word-most-efficiently-on-arm-arm7tdmi)
3. [Assembly Language Programming Arithmetic Shift Operations](http://www-mdp.eng.cam.ac.uk/web/library/enginfo/mdp_micro/lecture4/lecture4-3-3.html) 
4. [Assembly Language Programming Rotate Operations](http://www-mdp.eng.cam.ac.uk/web/library/enginfo/mdp_micro/lecture4/lecture4-3-4.html)


#### STRD

store double word 其實等價於str [r?] str [r?,#4] 可以參考[這篇](https://www.zhihu.com/question/55122474)

<br>

### P2

#### Init stack pointer

在LAB當中助教要求一塊空間並且讓stack pointer指向此塊記憶體空間，首先，```sp```內部存放的應該為一個memory address，之後push或pop時都會以此address做為基準。stack pointer在ARM中的行為較為特別，為**full-descending stack model**，也就是stack pointer在放完資料後是往下減4byte的，非往上加(另一種模式是用加，不同架構不同方式)，因此在取得該塊記憶體空間後，還要先往上加該記憶體空間的大小後再丟進sp裡面才算完成

#### STM LDM

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

### P3


## Demo Cheat Sheet

