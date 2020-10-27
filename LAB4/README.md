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

### 4-1 : Code B decode mode 並沒有 d 的符號。因此必需要自己手刻 pattern。說說 pattern 是如何決定的。即 D0~D7 要如何設定？


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

<br>

### 4-1 : live coding

<br>

### 4-2 請說明 code B decode mode 的 pattenr 是如何決定的？即 D0~D7 如何設置？

根據codebook的規定

![](https://i.imgur.com/B96RLa4.png)

<br>

### 4-2(Coding) 請說明是如何將沒用到的digits 設成空白？如果使用 Scan Limit 請改用 code B decode Mode 的 Blank。反之請換成 code b decode mode blank。其他方法請說明之。

scan limit: 僅開啟7個digit就好
code book : 對照 code book 中的樣式，並在七段顯示器的最左邊digit將其設為(F) [Code in Here](https://github.com/chilin0525/NCTUCS_MPSL_LAB/blob/master/LAB4/Code/p2_0711282_code_B.s)


```assembly
.data
	student_id: .byte 15,0,7,1,1,2,8,2
```

先把blank塞到student_id最左邊再配合原本的寫法: 

DIGIT7(value=8) <==>  ID[0],

DIGIT6(value=7) <==>  ID[1],

...... etc

![](https://i.imgur.com/310ZOVf.png)


<br>

### 4-3 請逐行說明 GPIO_init 做了哪些設定

### 4-3 請說明怎麼做到動態調整顯示的位數？ 即左邊空白的部分如何動態做調整？

### 4-3 如何將我們的結果轉換成 digits，並依序顯示在 7-seg LED 的不同位置上？
