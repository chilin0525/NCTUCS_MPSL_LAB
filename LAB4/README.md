# LAB4

## 3.1. Practice of Max7219 and 7-Seg LED with no-decode mode

![](https://i.imgur.com/msyG0Zr.png)

<br>

## 3.2. Practice of Max7219 and 7-Seg LED with code B decode mode

![](https://i.imgur.com/2B0D2yw.png)

<br>


## 3.3. Show the Fibonacci number

![](https://i.imgur.com/ipjseZy.png)


<br>

## DEMO cheat_sheet

### Question 1: What’s the functions of DIN, CLK, CS pins on MAX7219 7-Seg LED?
MAX7219 7-Seg LED 上的 DIN, CLK, CS 腳位分別有什麼作用？

<br>

### Question 2: Each time we send a command to MAX7219, we need to encode our command into 2-bytes, Address, and Data. What are the functions of Address(D8~D15) and Data(D0~D7)?
每次向MAX7219發送命令時，都需要將命令編碼為2個字節，地址和數據。 地址（D8〜D15）和數據（D0〜D7）的功能是什麼？

<br>

![](https://i.imgur.com/PMoWg8L.png)

| HEX(DEC) | D7  | D6  | D5  | D4  | D3  | D2  | D1  | D0  |
|:-------- |:--- |:--- |:--- | --- |:--- | --- | --- |:--- |
| 0x7E(0)  | 0   | 1   | 1   | 1   | 1   | 1   | 1   | 0   |
| 0x30(1)  | 0   | 0   | 1   | 1   | 0   | 0   | 0   | 0   |
| 0x6D(2)  | 0   | 1   | 1   | 0   | 1   | 1   | 0   | 1   |
| 0x79(3)  | 0   | 1   | 1   | 1   | 1   | 0   | 0   | 1   |
| 0x33(4)  | 0   | 0   | 1   | 1   | 0   | 0   | 1   | 1   |
| 0x5B(5)  | 0   | 1   | 0   | 1   | 1   | 0   | 1   | 1   |
| 0x5F(6)  | 0   | 1   | 0   | 1   | 1   | 1   | 1   | 1   |
| 0x70(7)  | 0   | 1   | 1   | 1   | 0   | 0   | 0   | 0   |
| 0x7F(8)  | 0   | 1   | 1   | 1   | 1   | 1   | 1   | 1   |
| 0x73(9)  | 0   | 1   | 1   | 1   | 0   | 0   | 1   | 1   |
| 0x77(A)  | 0   | 1   | 1   | 1   | 0   | 1   | 1   | 1   |
| 0x1F(B)  | 0   | 0   | 0   | 1   | 1   | 1   | 1   | 1   |
| 0x4E(C)  | 0   | 1   | 0   | 0   | 1   | 1   | 1   | 0   |
| 0x3D(D)  | 0   | 0   | 1   | 1   | 1   | 1   | 0   | 1   |
| 0x4F(E)  | 0   | 1   | 0   | 0   | 1   | 1   | 1   | 1   |
| 0x47(F)  | 0   | 1   | 0   | 0   | 0   | 1   | 1   | 1   |
