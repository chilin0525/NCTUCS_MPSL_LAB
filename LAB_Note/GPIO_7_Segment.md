# GPIO_7_Segment

## 7_Segment Introduction

如何解決要以少數pin腳做多個控制

![](https://i.imgur.com/5I6bT7n.png)

七段顯示器共八個燈(加右下角那個)，七段顯示器共兩個結構，一個是共陽極結構一個是共陰極結構，共陰極結構的COM(共同部分)接地；共陽極結構接5V另一端為0


![](https://i.imgur.com/0b9UTxo.png)


![](https://i.imgur.com/oB0KU40.png)

<br>

上述敘述為控制一個七段顯示器的部分，可以清楚看到為了控制一顆七段顯示器我們共花了8個接腳，那如果要控制八顆呢? 可能就需要64個接腳不可能這麼做，因此我們可以一次閃一顆後快速切換到下一顆，此時人眼無法跟上閃爍的速度，會看到兩科都是亮著的(欺騙人眼)

![](https://i.imgur.com/SaehLbx.png)

這邊四顆的做法是每顆LED燈有各自的編號(D0,D1,D2,D3)，然後一樣可以控制八顆LED燈泡，等於說一次選一顆然後再控制八個燈泡，用快速輪掃的方式點亮每個燈泡

然而我們實驗所用的共八個七段顯示器，實際上應該需要64 bit控管，但因為這個七段顯示器下面有顆小IC(Max7219)的可以方便我們管理(下圖)

![](https://i.imgur.com/ArFaXu5.png)

8 Segment: 選其中一個七段顯示器

8 Digits: 七段顯示器中的8 digit

共五個接腳: 

1. +5v 
2. GND(接地)
3. DIN(與 GPIO接腳連接 ) 
4. LOAD(與 GPIO接腳連接 )
5. CLK (與 GPIO接腳連接 )

如何做到僅以三個接腳就可以與多個燈溝通 : 原本的解法像是平行的給予值告訴她要步要亮，現在的做法是將原本平行的值改成序列式(series)地給予，例如原本要讓燈135亮，那現在就變成給予一個135的串列值讀取，那序列式給予的最大問題就是**什麼時間點應該要去讀取值的內容**，例如我們今天有兩個CLK分別是1跟0的訊號，但是如果我們在極小的時間點去查看可能就會變成100萬的1跟100萬的0，然CLK就是負責查看的時間點


![](https://i.imgur.com/OkjW4oU.png)

why 控制八個燈不是用8個bit就足夠了? 而需要給予16bit--> 因為還包含了一些控制命令，包含模式的選擇等等

- D0-D7: 直接秀在顯示器上
- D8-D11: 共四個bit，最多可以表達16種功能，可以用來控制(control digit):
    ADdress register decoder:
    - Shutdown register: 
    - Mode register:
    - Intensity register: 亮度
    - Scan-limit register: scan幾個接腳
    - Display-test register: 做一些測試

![](https://i.imgur.com/8Ob3Doc.png)

DIN: 如同上述所說的，data是要series的input進來非平行地

CS: 把輸入完data拿回去看

CLK: Rising edge時做取樣，data會移到internal shift register

![](https://i.imgur.com/7UAHiGv.png)

分別表示目前要對哪個segment或是要什麼模式

![](https://i.imgur.com/bIKbdjH.png)

進到shutdown後若data為0-->表示全部關掉

![](https://i.imgur.com/Fix9wQA.png)

decode mode : 方便快速秀0-9這幾個數字，或是秀出單一個數字例如:1或2之類的，不用特地再去做一些每個燈耀亮不亮的設定，有點類似使用他事先寫好的某些圖案，現在跟他說我要秀出他圖案手冊(Code B)裡面的哪些圖案

若選擇decode mode之後再選擇:
1. no decode : 表示所以燈要步要亮都由我自己決定:
2. code B decode for digit 0 no decode for digits 7-1: 第0 digit用code B的，7-1我自己設定
3. code B decode for digit 3-0 no decode for digits 7-4:第3-0 digit用code B的，7-4我自己設定
4. code B decode for digit 7-0:通通用code B

<br>

Code Book，也就是上面提到類似圖案手冊的部分:

![](https://i.imgur.com/Phy5T4Z.png)

<br>

如果要自己設定的話:

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
| 0x4D(C)  | 0   | 1   | 0   | 0   | 1   | 1   | 0   | 1   |
| 0x3D(D)  | 0   | 0   | 1   | 1   | 1   | 1   | 0   | 1   |
| 0x4F(E)  | 0   | 1   | 0   | 0   | 1   | 1   | 1   | 1   |
| 0x47(F)  | 0   | 1   | 0   | 0   | 0   | 1   | 1   | 1   |



![](https://i.imgur.com/gobbjGz.png)

![](https://i.imgur.com/mjGtXCJ.png)

![](https://i.imgur.com/LI7cDfq.png)


## 
