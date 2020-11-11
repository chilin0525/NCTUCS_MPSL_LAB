# LAB5

> Question 1: In Requirement 3-1, we used the function, "max7219_send" which is implemented in arm asm. How did we pass the arguments? That is, Where were the arguments "address" and "data" stored?在 Requirement 3-1 中我們使用了透過 arm 組合語言實做的 "max7219_send"。 請問這個函式的引數是如何被傳遞的？即 address 和 data 會被存在哪裡？



> Question 2: In stm32l476xx.h, variables are defined with the keyword "volatile"(__IO). Please describe its function? What problems can be avoided? 在 stm32l476xx.h 中，變量被使用關鍵字 "volatile" (__IO) 來定義。 請說明它的功能是什麼？可以避免甚麼問題？

<br>

## 3.1 Max7219 displayer
> Requirement
必須要呼叫 ARM Asm 實做的 GPIO_init, max7219_init, max7219_send 需要能用單步執行簡單確認，確實由 “xxx.c” 進入 “xxx.s” 中的 GPIO_init 等。

>Question
說說如何在 main.c 中呼叫 asm 實做的函式？需要做哪些的宣告，下哪些關鍵字、做哪些修改？

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
說說如何進行多按鍵偵測？
說說如何判斷先按後按？
