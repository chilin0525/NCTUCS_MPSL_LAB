# GPIO

IO裝置的溝通是透過CPU，但對CPU而言只認記憶體，**透過記憶體**控制IO裝置，目前記憶體中有一塊是IO address，各自拉到相對應的IO裝置(網卡、音效卡等等)，並非拿來當作儲存data用的一般memory。ex:要點量某一顆燈-->只要知道他對應的address把其設為一即可

因此從memory store or load資料進來都是一樣的指令，只是會因為你讀取的memory位置有不同意義。

![](https://i.imgur.com/NVumdxM.png)

![](https://i.imgur.com/ruKdFDA.png)

一般而言共有port  A到port H可用，除了PH外皆為16 bit

<br>

## IO方式

### Port-Mapped I/O (PMIO)

CPU具有特殊的指令，這些指令下達input或是output時某些接腳就會動起來，所以只要接腳連到所需要的IO裝置上(燈或keyboard等等)，就可以透過input或是output跟IO裝置產生互動

### Memory Mapped I/O(MMIO)

多一塊記憶體當作control register用，所以不能隨便mov東西進去，因為一旦mov進去就代表你要與IO溝通，這塊記憶體是保留用來控制IO或是讀取用的記憶體

<br>

![](https://i.imgur.com/D5VkQGo.png)

在上圖中我們可以看到Port A從0x48000000開始到0x480007FF，明明Port A只有16bit卻需要那麼多空間-->因為Port是General Purpose的，根據不同情況你會希望Port做到相對應的事情，因此設計者留下彈性讓使用者決定，因此可以設定成不同模式，所以有許多設定工作需要先做好

<br>

## Port前置設定

![](https://i.imgur.com/q7gQyJb.png)

- GPIO port **mode** register : 這個bit要當input還是output用?
- GPIO port output **type** register :  Push-Pull 或 Open-Drain Output
- GPIO port output **speed** register : setting output speed
- GPIO port pull-up/pull-down register :  

需要先打開port A -> 再config port A -> 再input output port A

<br>

 ## Push-Pull v.s Open-Drain Output
 
 有兩種output模式 分別為Push-Pull與Open-Drain Output
 
 ### Push-Pull
 
利用 P-MOS 或是 N-MOS 來動作

內部驅動電力，速度較快

 ### Open-Drain
 
 外界提供電壓
 
 <br>
 
 ## Pull-up v.s Pull-down
 
 上拉電阻或是下拉電阻
 
 ### Pull-up
 
 
 ### Pull-down
 
 <br>
 
 ## GPIO config
 
 ![](https://i.imgur.com/H0WhlbW.png)

PUPO: 上拉電阻或是下拉電阻

![](https://i.imgur.com/Ruem7TC.png)
