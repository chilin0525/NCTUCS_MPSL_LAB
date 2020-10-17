# GPIO

IO裝置的溝通是透過CPU，但對CPU而言只認記憶體，**透過記憶體**控制IO裝置，目前記憶體中有一塊是IO address，各自拉到相對應的IO裝置(網卡、音效卡等等)，並非拿來當作儲存data用的一般memory。ex:要點量某一顆燈-->只要知道他對應的address把其設為一即可

因此從memory store or load資料進來都是一樣的指令，只是會因為你讀取的memory位置有不同意義。

![](https://i.imgur.com/NVumdxM.png)

![](https://i.imgur.com/ruKdFDA.png)

一般而言共有port  A到port H可用，除了PH外皆為16 bit

## IO方式

### Port-Mapped I/O (PMIO)

CPU具有特殊的指令，這些指令下達input或是output時某些接腳就會動起來，所以只要接腳連到所需要的IO裝置上(燈或keyboard等等)，就可以透過input或是output跟IO裝置產生互動

### Memory Mapped I/O(MMIO)

多一塊記憶體當作control register用，所以不能隨便mov東西進去，因為一旦mov進去就代表你要與IO溝通，這塊記憶體是保留用來控制IO或是讀取用的記憶體
