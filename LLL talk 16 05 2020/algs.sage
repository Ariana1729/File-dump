def euclid(a,b):
    while True:
        if abs(a)>abs(b):
            a,b = b,a
        verbose(f"a = {a}, b = {b}", level=3)
        if a==0:
            return abs(b)
        q = b/a
        verbose(f"q = {q}", level=3)
        q = round(q)
        b -= q*a

def gauss(b1,b2):
    while True:
        if b1.norm()>b2.norm():
            b1,b2 = b2,b1
        verbose(f"b1 = {b1}, b2 = {b2}", level=3)
        m = (b1*b2)/(b1*b1)
        verbose(f'm = {m}', level=3)
        m = round(m)
        if m==0:
            return b1,b2
        b2-=m*b1

def lll(B,delta=3/4):
    B = copy(B)
    verbose(f"Input to LLL: {B}", level=3)
    i = 1
    while i<B.nrows():
        verbose(f"i = {i}:", level=3)
        Bs = list(B.gram_schmidt()[0])
        Bs = Bs + [vector(0 for _ in range(len(M[0]))) for _ in range(B.nrows()-len(Bs))]
        for j in reversed(range(i)):
            verbose(f"  j = {j}:", level=3)
            if Bs[j]*Bs[j]==0:
                m = 0
            else:
                m = (B[i]*Bs[j])/(Bs[j]*Bs[j])
            verbose(f"    m{i},{j} = {m}", level=3)
            if abs(m)>1/2:
                B[i] -= round(m)*B[j]
                Bs = list(B.gram_schmidt()[0])
                Bs = Bs + [vector(0 for _ in range(len(M[0]))) for _ in range(B.nrows()-len(Bs))]
            verbose("    "+str(B).replace("\n","\n    "), level=3)
        if B[i]*B[i]==0 and B[i-1]*B[i-1]!=0:
            verbose(f"Lovasz condition failed for {i}, {i-1}", level=3)
            B[i],B[i-1] = B[i-1],B[i]
            verbose("    "+str(B).replace("\n","\n    "), level=3)
            i = max(i-1,1)
        elif Bs[i-1]*Bs[i-1]==0:
            verbose(f"Lovasz condition passed for {i}, {i-1}", level=3)
            i += 1
        elif (delta-((B[i]*Bs[i-1])/(Bs[i-1]*Bs[i-1]))^2)*Bs[i-1]*Bs[i-1]>Bs[i]*Bs[i]:
            verbose(f"Lovasz condition failed for {i}, {i-1}", level=3)
            B[i],B[i-1] = B[i-1],B[i]
            verbose("    "+str(B).replace("\n","\n    "), level=3)
            i = max(i-1,1)
        else:
            verbose(f"Lovasz condition passed for {i}, {i-1}", level=3)
            i += 1
    return B

def rational_approx(x,B):
    t = lll(Matrix([[1,0,round(B*x)],[0,1,-B]]))[0]
    return t[1]/t[0]

def algebraic_approx(x,d,B):
    M = Matrix(d+1,d+2)
    for i in range(d+1):
        M[i,i] = 1
        M[i,d+1] = round(B*x^i)
    t = M.LLL()[0]
    return t[:-1]

def small_roots(f, N, B=None, beta=1., h=None, delta=3/4): # from sage's implementation but better heh
    t = f.coefficients()[-1]
    if gcd(t,N)!=1:
        raise ValueError("Make sure the polynomial can be reduced to a monic")
    f = f/t
    d = f.degree()
    epsilon = beta/8
    if h==None:
        h = max(beta**2/(d * epsilon), 7*beta/d).ceil() # the computation is kinda broken lol
    t = int(d*h*(1/beta-1))
    if B is None:
        B = (0.5 * N**(beta**2/d - epsilon)).ceil()
    P.<x> = PolynomialRing(ZZ, 'x')
    f = P(f)
    verbose(f"f(x) = {f}", level=2)
    verbose(f"N = {N}", level=2)
    verbose(f"B = {B}", level=2)
    g = [x^j * N^(h-i) * f^i for i in range(h) for j in range(d)]
    g += [x^i * f^h for i in range(t)]
    L = Matrix(ZZ, d*h+t, d*h+t)
    for i in range(d*h+t):
        for j in range(g[i].degree()+1):
            L[i,j] = g[i][j]*B^j
    L = L.LLL(delta=delta)
    roots = set([Mod(r,N) for r,m in sum([ZZ(L[0,i]//B^i)*x^i for i in range(d*h+t)]).roots()])
    return [root for root in roots if gcd(N,ZZ(f(root))) != 1] 
