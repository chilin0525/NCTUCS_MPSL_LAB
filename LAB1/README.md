# LAB1

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
result 變數中。
[Reference](https://en.wikipedia.org/wiki/Hamming_distance#Algorithm_example)


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

<br>
