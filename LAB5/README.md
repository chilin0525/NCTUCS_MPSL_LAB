# LAB5

> Question 1: In Requirement 3-1, we used the function, "max7219_send" which is implemented in arm asm. How did we pass the arguments? That is, Where were the arguments "address" and "data" stored?在 Requirement 3-1 中我們使用了透過 arm 組合語言實做的 "max7219_send"。 請問這個函式的引數是如何被傳遞的？即 address 和 data 會被存在哪裡？



> Question 2: In stm32l476xx.h, variables are defined with the keyword "volatile"(__IO). Please describe its function? What problems can be avoided? 在 stm32l476xx.h 中，變量被使用關鍵字 "volatile" (__IO) 來定義。 請說明它的功能是什麼？可以避免甚麼問題？

考慮: 

```c=
int *p = /* ... */ ; 
int a, b; 
a = *p; 
b = *p;
```

在一般情況下， compiler 在做最佳化的時候會發現到 a 跟 b 都要讀同一值，為了最佳化原本需要讀取兩次的情況就會變成從 p 讀取一次後讀到 CPU register 後重複利用給 b，也就是```a = *p = b```

但如果考慮 MMIO , p 指向的是某個硬體設備, 那有可能會發生錯誤， 也就是 p 記憶體位置值改變的當下 b 還是給予原本的 a 值， 因此經果 compiler 優化的結果將不符合我們的預期

```c=
volatile  int *p = /* ... */ ; 
int a, b; 
a = *p; 
b = *p;
```

使用之後任何為 ```volatile``` 的變數， compiler 將不可以做任何假設與推理，皆必須從mem address 取值，也就是不允許上述 **重複使用register中的值**

<br>

## 3.1 Max7219 displayer
> Requirement
必須要呼叫 ARM Asm 實做的 GPIO_init, max7219_init, max7219_send 需要能用單步執行簡單確認，確實由 “xxx.c” 進入 “xxx.s” 中的 GPIO_init 等。

>Question
說說如何在 main.c 中呼叫 asm 實做的函式？需要做哪些的宣告，下哪些關鍵字、做哪些修改？

1. 在 asm 中將 function 宣告為 global
2. 將 asm 中的 main function 移除僅存 funtion
3. 在 C 中宣告 function 為 extern function


<br>

## 3.2 Keypad scanning

> Requirement
> 在按壓每一顆鍵時要能正確顯示結果(十進制表示或十六進制表示皆可)。
x0	x1	x2	x3
y0	1	2	3	10
y1	4	5	6	11
y2	7	8	9	12
y3	15	0	14	13
沒按時要顯示空白

> Question
說說 char keypad_scan() 如何進行按鍵偵測 說說你怎麼在 C 語言去初始化 keypad 用到的 GPIO register? 怎麽去存取 GPIO_Registers?

<br>

## 3.3 Multi buttons

> Requirement
在同時按下不大於兩個鍵時皆必須要能正確顯示結果。
需通斜角、同行、同列隨機三組測試。

> Question
(Coding) 同時按下兩個鍵時，改顯示 先按\<space\>後按\<space\>相加結果
EX: 先按 13 再按 4 則顯示 １３　４　１７

> 說說如何進行多按鍵偵測？

> 說說如何判斷先按後按？
