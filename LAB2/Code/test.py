a1 = 30000
a2 = 40000
b1 = 21456
b2 = 65487

z1 = a1*b1
z2 = a2*b2
z3 = (a1+a2)*(b1+b2)-z1-z2

ans = z1*pow(10,10)+z3*pow(10,5)+z2

print(ans)
