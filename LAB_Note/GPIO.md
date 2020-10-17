# GPIO

IO裝置的溝通是透過CPU，但對CPU而言只認記憶體，**透過記憶體**控制IO裝置，目前記憶體中有一塊是IO address，各自拉到相對應的IO裝置(網卡、音效卡等等)，並非拿來當作儲存data用的一般memory。ex:要點量某一顆燈-->只要知道他對應的address把其設為一即可

因此從memory store or load資料進來都是一樣的指令，只是會因為你讀取的memory位置有不同意義。

![](https://i.imgur.com/NVumdxM.png)
