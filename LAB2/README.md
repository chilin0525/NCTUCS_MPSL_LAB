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

<br>

### P2

<br>

### P3

## Demo Cheat Sheet

