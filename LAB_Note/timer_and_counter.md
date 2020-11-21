# Timer_and_Counter

## Introduction

timer 跟 counter 差別是屬固定的數字或不固定的數字

<br>

![](https://i.imgur.com/ZQXyJ6M.png)

basic timer: 最基本的 counter 跟 timer 做最基本的 counter 與 timing 的動作 

general purpose timer: 比 basic timer 更複雜一點可以產生波行讓使用者使用

advanced control timer: 目的是為了處理某些裝置(PWM,馬達等等)

system clock: 開機後本身產生的 clock

![](https://i.imgur.com/sQIDuVC.png)

Counter type: 往上count或是往下count

prescalar factor(32bit register): 把 counter 或是 timer 進來的數字先除以某數(除頻)

DMA: 

capture/compare channel: 一個timer出去之後產生另一個event(像碼表可以暫停後記下來再繼續)

complementary output: 波行反向輸出

<br>

![](https://i.imgur.com/ekoeJQU.png)

System Clock主要由下列四者決定:

1. HSI(high speed inernal)16 
2. MSI(default)
3. HSE
4. PLL clock

<br>

![](https://i.imgur.com/TXkZGPc.png)

最簡單的

有 auto-reload 爆掉可以重來

![](https://i.imgur.com/sekf6Nh.png)

trigger controller: 要不要對下面的counter跟timer做動作(enable?)

PSC presalar: 等等幾個波要算成一個波

詳細過程:

![](https://i.imgur.com/zf70gAL.png)


![](https://i.imgur.com/KgNChOs.png)

兩次event之間差了多久(t event):

Tevent = (PSC+1)*(ARR+1)*Tck_int

其中 PSC+1 與當初設定有關

## Set up

![](https://i.imgur.com/0enAwU0.png)

CEN: conter enable 要步要打開 counter

UDIS: update disable 要步要產生 update 訊息

URS: update request source 選擇對 event 產生 update(default:所有皆會產生update)

OPM: one-pulse mode 只算一次 counter 就不算了

ARPE: auto-reload preload enable 適用於假如原本 ```ARR``` 已經設定為 100，現在 counter 從 0 count 到 20 了，現在把 ```ARR```改成 50，那這次的```ARR```要認定為100還是50，若```ARPE```被enable，那這次```ARR```就算50

UIFREMAP: UIF status bit remapping 

![](https://i.imgur.com/qdxJGfX.png)

![](https://i.imgur.com/Kfm4UuY.png)

![](https://i.imgur.com/venzFb0.png)

![](https://i.imgur.com/En0QRt7.png)

**注意是 ```/(PSC[15:0]+1)```**

![](https://i.imgur.com/wJmrJNO.png)

## advanced counter

timer 的來源通常是 clock，而 counter 的來源通常是 event

![](https://i.imgur.com/WZmrYs0.png)

剛剛上述的 basic 皆為 single channel，advanced 則有多個

![](https://i.imgur.com/QSCJue7.png)

4個 channel 的用意是分別可以獨立產生出 4 個 event

advanced counter 可以跟 basic counter 最大的差別是:

1. Input Capture: 一個波型下去又上來的時間
2. Output capare: 可以把 counter 的值跟某個數字做比較，例如與500做比較，依相同就發生 event
3. PWM genreation: 儘管 basic 也可以做到但是 advanced 來做將會更有彈性
4. One-Pulse mode: 僅用於算一個event

![](https://i.imgur.com/M0HIZdn.png)
