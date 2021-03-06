a1 = 0x1234
a2 = 0x5678
b1 = 0xABCD
b2 = 0xEF00

z1 = a1*b1
z2 = a2*b2
z3 = (a1+a2)*(b1+b2)-z1-z2

print("Test Case1:")
print(0x12345678*0xABCDEF00)
print(hex(0x12345678*0xABCDEF00))
print(hex(a1*b1))
print(hex(a2*b2))
print(hex(z3))

print("\n")
print("Test Case2:")
print(0xffffffff)
print(pow(2,32)-1)
print(pow(2,64)-1)
print(0xffffffff*0xffffffff)
print(hex(0xffffffff*0xffffffff))
print(hex((0xffff*0xffff)))
print(hex((0xffff*0xffff+0xffff*0xffff))) # z1+z2
#print(0xffff*0xffff)
a=(0xffff+0xffff)*(0xffff+0xffff) # (a1+a2)*(b1+b2)
print(hex(0xffff+0xffff))
b=(0xffff+0xffff)*(0xffff+0xffff)-(0xffff*0xffff)*2 # z3
print(hex(a))
print(hex(b))

print("\n")

print(hex(0x46789214*0xBCDABADC))
