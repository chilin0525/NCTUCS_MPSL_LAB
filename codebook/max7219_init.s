max7219_init:
    push {LR}

    // no decode for digit 7-0 :                        0x00
    // code b for digit 0   & decode for digit 7-1 :    0x1 (00000001)
    // code b for digit 3-0 & decode for digit 7-4 :    0xF (00001111)
    // code b decode for digit 7-0:                     0xFF(11111111)
    ldr r0,=#DECODE_MODE    // set Mode = No decode for digit 7-0
    ldr r1,=#0x0
    BL MAX7219Send


    // SHUTDOWN: 0x0C00
    // DATA:
    // 0 : Shutdown mode    0x00 (00000000)
    // 1 : Normal Operation 0x01 (00000001) 
    ldr r0,=#SHUTDOWN       // set ShutDown = Normal Operation
    ldr r1,=#0x1
    BL MAX7219Send

    // SCAN_LIMIT: 0x0B00
    // DATA:
    // display digit 0          000(0x00)
    // digplay digit 10         001(0x01)
    // display digit 210        010(0x02)
    // display digit 3210       011(0x03)
    // display digit 43210      100(0x04)
    // display digit 543210     101(0x05)
    // display digit 6543210    110(0x06)
    // display digit 76543210   111(0x07)
    ldr r0,=#SCAN_LIMIT     // Use only 1 DIGIT of 7-segment
    ldr r1,=0x0
    BL MAX7219Send

    // INTENSITY: 0x0A00
    // DATA:
    // more light: 0x00 ~ 0x0F
    ldr r0,=#INTENSITY      // set intensity range(0,15)
    ldr r1,=#0xA
    BL MAX7219Send

    // DISPLAY: 0x0F00
    // DATA:
    // 0: Normal Operation  0x00000000 
    // 1: Display Test Mode 0x00000001
    ldr r0,=#DISPLAY_TEST   // set TEST = Normal Operation
    ldr r1,=#0x0
    BL MAX7219Send

    pop {LR}
BX LR

