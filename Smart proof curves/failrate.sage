a0_curves = eval(open('a0_curves','r').read())
anot0_curves = eval(open('anot0_curves','r').read())

def calcprob(k,n,p): #idk LOL
    if k == n*p:
        return 1
    r = sum(binomial(n,i)*p^i*(1-p)^(n-i) for i in range(k+1))
    if r>0.5:
        r = 1-r
    return 2*r

print('p | a | b | success rate | expected rate | probability')

t=0
m=0
e=0

for p,a,b in a0_curves+anot0_curves:
    E = EllipticCurve(GF(p),[a,b])
    EQp = EllipticCurve(Qp(p,8),[a,b])
    Ps = E.points()[1:]
    logPs = []
    for P in Ps:
        for PQp in EQp.lift_x(ZZ(P.xy()[0]), all=True):
            if GF(p)(PQp.xy()[1]) == P.xy()[1]:
                x,y = (p*PQp).xy()
                logPs.append(-x/y)
                break
        else:
            print('Cant lift point {P} in {E}')
            logPs.append(0)
    attack_pass = 0
    for P in range(p-1):
        for Q in range(P+1,p-1):
            if Ps[P] == -Ps[Q]:
                continue
            k = logPs[Q]/logPs[P]
            if k.valuation()<0:
                continue
            if ZZ(k%p)*Ps[P]==Ps[Q]:
                attack_pass += 1
    print(f"{p:02} {a:02} {b:02} {n(2*attack_pass/(p-1)/(p-3),10)} {n(1/(p-1),10)}, Prob: {calcprob(2*attack_pass,(p-1)*(p-3),1/(p-1))}")
    if 2*attack_pass>p-3:
        m+=1
        t+=1
    elif 2*attack_pass<p-3:
        t+=1
    else:
        e+=1

print(m,t,e)
print(f"Probability that it is random: {calcprob(m,t,1/2)}")

