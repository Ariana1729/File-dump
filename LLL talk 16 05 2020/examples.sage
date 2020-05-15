load('algs.sage')
#set_verbose(3) to see very detailed output

def slide5(a = 2272203976, b = 11891239374):
    print(f"GCD of {a} and {b} is {euclid(a,b)}")

def slide6(b1 = vector([65387,45561]), b2 = vector([63377,14505])):
    print(f"Smallest generating vectors of the lattice ({b1}, {b2}) is {gauss(b1, b2)}")

def slide10(L = Matrix(3,3,[1,2,0,1,3,2,2,2,1])):
    print(f"LLL reduced lattice of\n{L}\nis\n{lll(L)}")

def slide14(x = pi^4, B = 10^6):
    a = rational_approx(x, B)
    print(f"A rational approximation of {x} is {rational_approx(x, B)}")

def slide15(d = 0):# notice how removing some r allows LLL to find some linear relation in r to get elements in c
    r = [1, 196883, 21296876, 842609326, 18538750076, 19360062527, 293553734298, 3879214937598, 36173193327999, 125510727015275, 190292345709543, 222879856734249, 1044868466775133, 1109944460516150, 2374124840062976,8980616927734375, 8980616927734375,15178147608537368]
    if d!=0:
        r = r[:-d]
    c = [1, 196884, 21493760, 864299970, 20245856256, 333202640600, 4252023300096, 44656994071935, 401490886656000, 3176440229784420, 22567393309593600, 146211911499519294, 874313719685775360, 4872010111798142520, 25497827389410525184]
    print('j invariant coefficients: ',r)
    print('Dimensions of irred rep. of monster group',c)
    x = 10^100
    M = Matrix(len(r)+1,len(r)+1)
    for i in range(len(r)):
        M[i,i] = 1
        M[i,len(r)] = x*r[i]
    for k in c:
        M[len(r),len(r)] = -x*k
        t = M.LLL()
        for i in range(len(r)):
            t[i,0] += t[i,-1]
            if t[i][:-1].dot_product(vector(r))==k:
                print(f"{k} = "+" + ".join(f"{j[0]}*{j[1]}" for j in zip(t[i],r) if j[0]!=0).replace("+ -","- ").replace("1*",""))

def slide16(x = (sqrt(12)/73+4)^(1/3), B = 10^100, d = 7):
    var('t')
    f = sum(c*t^d for d,c in enumerate(algebraic_approx(x,d,B)))
    print(f"{x} is approximately a root of {f}")

def slide24():
    p = random_prime(2^2^7)
    q = random_prime(2^2^7)
    N = p*q
    P.<x>=PolynomialRing(Integers(N))
    t = randint(0,N)
    B = N^0.3
    f = (t-int(random()*B)+x)^3-t^3
    print(f"Small root of {f} mod {N} is {small_roots(f, N, B=int(B), h=8)[0]}")

def slide26():
    p = random_prime(2^2^8)
    q = random_prime(2^2^8)
    N = p*q
    P.<x>=PolynomialRing(Integers(N))
    B = 2^2^6
    f = p - int(random()*B) + x
    r = small_roots(f, N, B=int(B), beta=0.5, h=8)[0]
    print(f"Small root {f} mod {N} is {r}, hence {f(r)} is a factor of {N}")

