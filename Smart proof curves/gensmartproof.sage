p = 0xace49eae1cbf07b08e2f9b68886fd57dc3e65f43992252c9b1c4148b24697a0a3b08956ce2b13e2fa8d9474c8a67249526d690b715c034aec356b0063e3eaac9
a = 0x5381f0f284ffb47a8843a93281f6b0e965e2c500d5165f7677f6c12715e082475f29e7ab1c80adde8ccb6a82bd55850cca7ea67f901d7db9ad697a837213e2d6
b = 0x5bcdf1f8522f1e6a0313e8ae94f7feccab546ae24e0d55ee21866ffdf95364062d4bcd321e1d78d3390f94ae58d11ac69274cedd680b8e1dc34c949f0f58acea
R.<x>=PolynomialRing(Integers(p^2))

def Zpxinv(v):
    if v.subs(x=0)^2==0:
        return 0
    t = v.subs(x=-x)/v.subs(x=0)^2
    if v*t!=1:
        return 0
    return t

class Elpoint():
    def __init__(self,px,py):
        self.x = R(px)
        self.y = R(py)
        self.xy = [self.x,self.y]
    def oncurve(self,a,b):
        if self.x^3+a*self.x+b==self.y^2:
            return True
        return False
    def add(self,Q,a):
        if Q.xy == self.xy:
            l = Zpxinv(2*self.y)
            if l == 0:
                return -1
            l = l*(3*self.x^2+a)
        else:
            l = Zpxinv(Q.x-self.x)
            if l == 0:
                return -1
            l = (Q.y-self.y)*l
        Rx = l^2 - self.x - Q.x
        Ry = l * (self.x - Rx) - self.y
        R = Elpoint(Rx,Ry)
        return R

def mul(G,n,a):
    if n==1:
        return G
    if n%2==0:
        t = mul(G,n/2,a)
        return t.add(t,a)
    return G.add(mul(G,n-1,a),a)

E = EllipticCurve(GF(p),[a,b])
P = E.gen(0)
EQp = EllipticCurve(Qp(p), [a,b])
PQp=[i for i in EQp.lift_x(ZZ(P.xy()[0]),all=True) if ZZ(i.xy()[1])%p==P.xy()[1]][0]
Ax, Ay = [ZZ(i%p^2) for i in PQp.xy()]
A = Elpoint(R(Ax),R(Ay+(1/(Ay*2)%p)*x*p))
B = mul(A,p-1,a)
t = A.x-B.x
ti,tj = [ZZ(i) for i in t.coefficients()]
n = -ti/tj%p
k = 3*b/(2*a)%p % p
print(f"m = arbitrary\np = {p}\na = {a}\nb = {b}\nn = {n}\nk = {k}\na = a+m*p\nb = b+(n+m*k)*p")
