a1 = 0x1234
a2 = 0x5678
b1 = 0x7765
b2 = 0x4321

z1 = a1*b1
z2 = a2*b2
z3 = (a1+a2)*(b1+b2)-z1-z2

ans = z1*pow(10,10)+z3*pow(10,5)+z2

print(0x12345678*0x77654321)
print(hex(0x12345678*0x77654321))
print(hex(a1*b1))
print(hex(a2*b2))
print(hex(z3))

print("\n")

tmp1 = 0x16ac8d78
tmp2 = 0xda0c0000

t1 = tmp1 + tmp2
print(hex(t1))
