# P1

(支援 user btn debounce)

[垃圾 Driver 問題解法](https://annhanmovienight.wordpress.com/2016/07/29/prolific-usb-to-serial-comm-port-%E8%A3%9D%E7%BD%AE%E7%84%A1%E6%B3%95%E5%95%9F%E5%8B%95-win10-driver/)

## GPIO

PA2 <===> UART TX 綠線

PA3 <===> RX 白線

GND <===> 黑線

**紅線為 5V 供電線此次不需要接也不可以亂接 有機率燒壞板子**

## Intro

```c
char* Str = "\015Hello World!3\n\015";
```

(字串這邊 ascii:```\015``` 為 carriage return 讓游標移到最左邊)

## Ref

![](https://i.imgur.com/Vdjc99G.png)

![](https://i.imgur.com/ccBd0gi.png)

![](https://i.imgur.com/1WfhiWt.png)

![](https://i.imgur.com/WpkCjnw.png)
