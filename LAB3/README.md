# LAB3

## DEMO Cheetsheet

>Question 1-1: What is the memory-mapped I/O (MMIO)? What are its pros and cons?
什麼是 memory mapped I/O (MMIO)？ 它的優缺點是什麼？


| MMIO | 優  | 缺  |
|:---- | --- |:--- |
|      | 需要一段Physical memory address保留給IO<br>犧牲了可以使用的memory address    |     |

<br>

>Question 1-2: What is the port-mapped I/O (PMIO)? What are its pros and cons?
什麼是 port-mapped I/O (PMIO)？ 它的優缺點是什麼？

| PMIO | 優  | 缺  |
|:---- | --- |:--- |
|      | IO與memory分開<br>可以使用的memory address較多也較為安全    |     |

<br>

REF: [Memory mapped I/O vs Port mapped I/O](https://stackoverflow.com/questions/15371953/memory-mapped-i-o-vs-port-mapped-i-o)

>Question 1-3: When we set GPIO pin to the input mode, we also need to config the GPIOx_PUPDR register to pull-up, pull-down or floating (non-pull-up, non-pull-down). What's the effect of these settings?
當我們將 GPIO pin 設成 input mode 的時候，還需要將 GPIOx_PUPDR 設成上拉，下拉或浮動（非上拉、非下拉）。這些設置有什麼作用？
