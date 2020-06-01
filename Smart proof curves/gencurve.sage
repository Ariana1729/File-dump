anomalous_curves = eval(open('anomalous_curves','r').read())
a0_curves = eval(open('a0_curves','r').read())
anot0_curves = eval(open('anot0_curves','r').read())

for p in Primes()[25:25]:
    print(p)
    for a in range(1,p):
        for b in range(p):
            if (4*a^3+27*b^2)%p==0:
                continue
            E = EllipticCurve(GF(p),[a,b])
            if E.order()==p:
                anomalous_curves.append([p,a,b])

a=0
for p in Primes()[25:25]:
    print(p)
    for b in range(1,p):
        E = EllipticCurve(GF(p),[a,b])
        if E.order()==p:
            a0_curves.append([p,a,b])
            P = E.gen(0)
            EQp = EllipticCurve(Qp(p), [a,b])
            for PQp in EQp.lift_x(ZZ(P.xy()[0]),all=True):
                if P.xy()[1]==GF(p)(PQp.xy()[1]):
                    if (p*PQp)[0].valuation()>=-2:
                        print(f"{E} is not smart-proof!")
                        del a0_curves[-1]
                    break
            else:
                print(f"Can't lift point {P} in {E}")

pprev = 0
for p,a,b in anomalous_curves:
    if p<=anomalous_curves[-1][0]:
        continue
    if p!=pprev:
        print(p)
        pprev = p
    if a==0:
        continue
    E = EllipticCurve(GF(p),[a,b])
    P = E.gen(0)
    EQp = EllipticCurve(Qp(p), [a,b])
    for PQp in EQp.lift_x(ZZ(P.xy()[0]),all=True):
        if P.xy()[1]==GF(p)(PQp.xy()[1]%p):
            if (p*PQp)[0].valuation()<-2:
                anot0_curves.append([p,a,b])
            break
    else:
        print(f"Can't lift point {P} in {E}")

open('anomalous_curves','w').write(str(anomalous_curves))
open('a0_curves','w').write(str(a0_curves))
open('anot0_curves','w').write(str(anot0_curves))


