def invpoint(P):
    return (-P[0],-P[1],1)

def addpoints(P,Q,p,a,b):
    Px, Py, Pz = P
    Qx, Qy, Qz = Q
    if Py==0:
        return Q
    if Qy==0:
        return P
    Px, Py, Pz = Qp(p)(Px), Qp(p)(Py), Qp(p)(Pz)
    Qx, Qy, Qz = Qp(p)(Qx), Qp(p)(Qy), Qp(p)(Qz)
    Px, Py = Px/Pz, Py/Pz
    Qx, Qy = Qx/Qz, Qy/Qz
    l, Rx, Ry = None, None, None
    if Px == Qx:
        if Py != Qy:
            Rx = -Px
            Ry = a*Px/b + Py + Qy
            return (Rx, Ry, Qp(p)(1))
        l = (3*Px^2+a*Py^2)/(1-2*a*Px*Py-3*b*Py^2)
    else:
        l = (Py-Qy)/(Px-Qx)
    Rx = (l*(2*a+3*b*l)*(Py-l*Px))/(1+a*l^2+b*l^3) + Px + Qx
    Ry = l*Rx + l*Px - Py
    return (Rx, Ry, Qp(p)(1))

def mulpoint(n,P,p,a,b):
    if n==0:
        return (0,0,1)
    if n==1:
        return P
    if n%2==0:
        Q = mulpoint(n/2,P,p,a,b)
        return addpoints(Q,Q,p,a,b)
    return addpoints(P,mulpoint(n-1,P,p,a,b),p,a,b)

def genpoints(p,a,b):
    var('x y')
    f = x^3+a*x*y^2+b*y^3-y
    points = solve_mod(f,p^2)
    EQp = EllipticCurve(Qp(p), [a,b])
    E1pts = []
    for i in range(1,p):
        E1pts += EQp.lift_x(QQ(i/p^2),all=True)
    i = 0
    while i<len(points):
        if points[i][1] == 0:
            if points[i][0] == 0:
                points[i] = (Qp(p)(0), Qp(p)(0), Qp(p)(1))
                i += 1
                continue
            for PQp in E1pts:
                xx, yy, _ = PQp
                if ZZ(xx/yy%p^2) == points[i][0]:
                    points[i] = (xx/yy, 1/yy, Qp(p)(1))
                    i += 1
                    break
            else:
                print('idk why it didnt get lifted',points[i])
                del points[i]
            continue
        for PQp in EQp.lift_x(ZZ(points[i][0]/points[i][1]),all=True):
            if points[i][1]==ZZ(1/PQp.xy()[1]%p^2):
                xx, yy, _ = PQp
                points[i] = (xx/yy, 1/yy, Qp(p)(1))
                i += 1
                break
        else:
            print('idk why it didnt get lifted',points[i])
            del points[i]
    return points

def testgrphom(p,a,b): 
    E = EllipticCurve(GF(p), [a, b])
    EQp = EllipticCurve(Qp(p), [a,b])
    pts = []
    for P in E.points()[1:]:
        for PQp in EQp.lift_x(ZZ(P.xy()[0]),all=True):
            if P.xy()[1]==ZZ(PQp.xy()[1]%p):
                pts.append(PQp)
                break
        else:
            print(P,'no lifted points')
            continue
    grphom = 1
    print(f"{len(pts)} points lifted")
    for PQp in pts:
        Px, Py, _ = PQp
        PZp = (Px/Py, 1/Py, 1)
        for QQp in pts:
            Qx, Qy, _ = QQp
            QZp = (Qx/Qy, 1/Qy, 1)
            RQp = PQp + QQp
            RZp = addpoints(PZp, QZp, p, a, b)
            x, y, _ = RQp
            x, y = x/y, 1/y
            if x!=RZp[0] or y!=RZp[1] and RZp!=(Qp(p)(0),Qp(p)(0),Qp(p)(1)):
                print(i,x,y,RZp)
                grphom = 0
    if grphom==1:
        print("Yes")

def checkgrp(pts,e,p,a,b):
    for P in pts:
        if addpoints(e,P,p,a,b)!=P:
            print(f"eP!=P, e={e}, P={P}")
            return False
        if addpoints(invpoint(P),P,p,a,b)!=e:
            print(f"P^(-1)P!=e, e={e}, P={P}")
            return False
        for Q in pts:
            if redmod(addpoints(P,Q,p,a,b),p^2) not in map(lambda x:redmod(x,p^2), pts):
                print(f"Not closed\n{P}\n{Q}\n{addpoints(P,Q,p,a,b)}")
                return False
            if addpoints(P,Q,p,a,b)!=addpoints(Q,P,p,a,b):
                print(f"Not commutative\n{P}\n{Q}")
                return False
            for R in pts:
                if addpoints(addpoints(P,Q,p,a,b),R,p,a,b)!=addpoints(P,addpoints(Q,R,p,a,b),p,a,b):
                    print(f"Not associative, {P}, {Q}, {R}")
                    return False
    print("Is a group")   
    return True

def redmod(pt,m):
    return tuple(map(lambda x:Integers(m)(x),pt))

p, a, b = 7, 3, 5 # passes smart attack
#p, a, b = 5, 3, 2 # fails smart attack
#p, a, b = 7, 0, 5
a += 3*p
b += 6*p

#testgrphom(p,a,b)
pts = genpoints(p,a,b)
print(f"Num of pts: {len(pts)}")
#checkgrp(pts,(0,0,1),p,a,b)
for P in pts:
    pt = redmod(P,p^2)
    ppt = redmod(mulpoint(p,P,p,a,b),p^2)
    print(f"p{pt} = {ppt}")
