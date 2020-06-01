anomalous_curves = eval(open('anomalous_curves','r').read())

print("Curves of the form y^2=x^3+(a+mp)x+(b+np) over Q_p that are Smart-proof")

for p,a,b in anomalous_curves[:100]:
    if a==0:continue
    print(f"p = {p:02}, a = {a:02}, b = {b:02}:")
    E = EllipticCurve(GF(p),[a,b])
    P = E.gen(0)
    nls=[]
    for m in range(p):
        for n in range(p):
            EQp = EllipticCurve(Qp(p), [a+m*p,b+n*p])
            for PQp in EQp.lift_x(ZZ(P.xy()[0]),all=True):
                if P.xy()[1]==GF(p)(PQp.xy()[1]%p):
                    if (p*PQp)[0].valuation()<-2:
                        #print(f"m = {m}, n = {n}")
                        nls.append(n)
                    break
            else:
                print(f"Can't lift point {P} in {E}")
    if set(nls)!=set(range(p)):
        print("Exists a n that is not possible")
    print(nls[0],set([(nls[i]-nls[i+1])%p for i in range(p-1)]))
