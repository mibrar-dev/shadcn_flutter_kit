((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,C,D,B={my:function my(d,e){this.a=d
this.b=e},Hx:function Hx(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},aTO:function aTO(){},aTP:function aTP(d){this.a=d},Hy:function Hy(d,e){this.a=d
this.b=e},kB:function kB(d,e,f,g,h,i,j,k,l,m){var _=this
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=i
_.y=j
_.a=k
_.b=l
_.c=m},
bZF(d){return A.bYB},
bZ0(d){return A.bYf},
c3d(d){return A.bYk}},A,E,F
J=c[1]
C=c[0]
D=c[2]
B=a.updateHolder(c[139],B)
A=c[250]
E=c[217]
F=c[398]
B.my.prototype={}
B.Hx.prototype={
j(d){var x,w,v,u,t,s,r,q,p,o=null,n=C.h(d),m=y.m,l=C.aF(d,A.cbg,new B.aTO(),this.e,m,m)
m=this.c
x=m.length
if(x===0)return D.aa
w=n.a
v=l.x
if(v==null)v=2
u=l.y
t=l.w
s=C.ab(t==null?Math.max(0,n.b.a*16-2):t)
r=C.a([],y.e)
for(q=0;q<x;++q){if(q>0)r.push(new C.c4(v,o,o))
p=m[q]
r.push(new C.bz(1,D.X,new C.qH(new C.A(o,u,new C.iw(l.aFK(p.b).G(w),!0,o,o),o),new B.aTP(p),D.F,o),o))}m=this.d
return C.fx(s,m==null?C.M(r,D.m,o,D.c,D.j,0,o):C.bJ(o,o,C.M(r,D.m,o,D.c,D.j,0,o),!0,o,o,!1,o,!1,o,o,o,o,o,o,o,o,o,m,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o))}}
B.Hy.prototype={
K(){return"TrackerLevel."+this.b}}
B.kB.prototype={
aFK(d){var x,w=this
switch(d.a){case 0:x=w.d
break
case 1:x=w.e
break
case 2:x=w.f
break
case 3:x=w.r
break
default:x=null}return x},
F(d){var x,w,v,u,t,s=this,r=s.d
if(r==null)r=d.d
x=s.e
if(x==null)x=d.e
w=s.f
if(w==null)w=d.f
v=s.r
if(v==null)v=d.r
u=s.w
if(u==null)u=d.w
t=s.x
if(t==null)t=d.x
return new B.kB(r,x,w,v,u,t,s.y,d.a,d.b,d.c)},
h(d,e){var x=this
if(e==null)return!1
if(x===e)return!0
return e instanceof B.kB&&J.x(e.d,x.d)&&J.x(e.e,x.e)&&J.x(e.f,x.f)&&J.x(e.r,x.r)&&e.w==x.w&&e.x==x.x&&e.y===x.y},
gq(d){var x=this
return C.P(x.a,x.b,x.c,x.d,x.e,x.f,x.r,x.w,x.x,x.y,D.a,D.a,D.a,D.a,D.a,D.a,D.a,D.a,D.a,D.a)}}
var z=a.updateTypes(["b(k)","kB(kB)"])
B.aTO.prototype={
$1(d){return d},
$S:z+1}
B.aTP.prototype={
$1(d){return this.a.a},
$S:11};(function installTearOffs(){var x=a._static_1
x(B,"c89","bZF",0)
x(B,"c88","bZ0",0)
x(B,"c8a","c3d",0)})();(function inheritance(){var x=a.inherit,w=a.inheritMany
x(B.my,C.J)
x(B.Hx,C.i)
w(C.ap,[B.aTO,B.aTP])
x(B.Hy,C.dX)
x(B.kB,C.ao)})()
C.ag(b.typeUniverse,JSON.parse('{"Hx":{"i":[],"b":[]},"kB":{"ao":[]}}'))
var y={j:C.e("f<my>"),e:C.e("f<b>"),m:C.e("kB")};(function constants(){var x=a.makeConstList
A.a8B=new E.z(B.c89())
A.a87=new E.z(B.c88())
A.aaY=new E.z(B.c8a())
A.bGJ=x([A.a8B,A.a87,A.aaY],C.e("f<z>"))
A.a_c=A.bGJ
A.c67=new C.o("One",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
A.oF=new B.Hy(0,"fine")
A.Ur=new B.my(A.c67,A.oF)
A.U1=new C.o("Two",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
A.Ut=new B.Hy(2,"critical")
A.cb8=new B.my(A.U1,A.Ut)
A.TG=new C.o("Three",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
A.Us=new B.Hy(1,"warning")
A.cbd=new B.my(A.TG,A.Us)
A.brY=x([A.Ur,A.cb8,A.cbd],y.j)
A.cbi=new B.kB(null,null,null,null,4,4,24,null,null,null)
A.cbj=new B.Hx(A.brY,null,A.cbi,null)
A.bYf=new C.A(320,null,A.cbj,null)
A.cbh=new B.kB(D.az,null,null,null,null,null,16,null,null,null)
A.cba=new B.my(A.U1,A.oF)
A.cbb=new B.my(A.TG,A.oF)
A.bGR=x([A.Ur,A.cba,A.cbb],y.j)
A.cbl=new B.Hx(A.bGR,null,null,null)
A.abw=new C.kg(A.cbh,A.cbl,null,C.e("kg<kB>"))
A.bYk=new C.A(320,null,A.abw,null)
A.c9t=new C.o("Healthy",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
A.w1=new B.my(A.c9t,A.oF)
A.c6n=new C.o("Degraded",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
A.cb9=new B.my(A.c6n,A.Us)
A.c4O=new C.o("Down",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
A.cbc=new B.my(A.c4O,A.Ut)
A.c8K=new C.o("No data",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
A.cbf=new B.Hy(3,"unknown")
A.cbe=new B.my(A.c8K,A.cbf)
A.brk=x([A.w1,A.cb9,A.cbc,A.cbe,A.w1,A.w1],y.j)
A.cbk=new B.Hx(A.brk,"Activity tracker",null,null)
A.bYB=new C.A(320,null,A.cbk,null)
A.bUI=new C.cG(D.a2X,1)
A.cbg=new B.kB(F.uE,A.bUI,D.dj,D.ca,null,2,32,null,null,null)})()};
(a=>{a["sbBBPMBM+nRXNrU8LP5zv7qlcls="]=a.current})($__dart_deferred_initializers__);