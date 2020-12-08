# codebook

## debounce.c

to check the btn(pc13,change if need) whether pressed or not

example:

```c
if(DEBOUNCE()){
    if(idx>=4)idx=0;
    else idx=idx+1;
}
```
