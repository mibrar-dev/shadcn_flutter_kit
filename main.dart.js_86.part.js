((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,B,A,C={
E2(d,e,f,g){return new C.a3j(e,f,g,d,null)},
bED(d,e){var x,w,v,u
if(d.length<2)return d
x=y.u
w=B.a([],x)
for(v=0;v<d.length;++v){u=B.a([],x)
if(v>0)u.push(e)
u.push(d[v])
A.b.B(w,u)}return w},
a3j:function a3j(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.r=g
_.a=h},
azr:function azr(){},
azq:function azq(d,e){this.a=d
this.b=e},
aoD:function aoD(d,e,f,g,h,i){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.r=h
_.a=i},
aha:function aha(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
z6:function z6(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
l1:function l1(d,e,f,g,h,i,j,k){var _=this
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.a=i
_.b=j
_.c=k}},D,E
J=c[1]
B=c[0]
A=c[2]
C=a.updateHolder(c[190],C)
D=c[478]
E=c[428]
C.a3j.prototype={
j(d){var x,w,v,u,t=this,s=null,r=B.h(d),q=y.z,p=B.aF(d,D.bgG,new C.azr(),s,q,q),o=p.f
if(o==null)o=r.w.a*2*r.f
q=p.r
if(q==null)q=A.iu
x=B.cg(q,r.r.c*r.f)
d.Z(y.o).toString
q=B.a([],y.u)
for(w=t.d,v=0;v<w;++v)q.push(t.aiL(d,r,p,v,o))
u=t.e==null?o:0
return new B.I(x,t.r===A.B?B.M(C.bED(q,new B.A(u,s,s,s)),A.m,s,A.c,A.i,0,s):B.u(C.bED(q,new B.A(s,u,s,s)),A.m,A.c,A.i,0,A.h),s)},
aiL(d,e,f,g,h){var x,w,v,u=this,t=null,s=g===u.c,r=s?f.d:f.e
if(r==null)r=s?D.CZ:D.D_
x=r.d
if(x==null)x=12*e.f
w=f.w
w.toString
if(B.e1(d))w=A.F
v=new C.aoD(r,x,w,e.a,e.f,t)
if(u.e==null)return B.bJ(t,t,v,!1,t,t,!1,t,!1,t,t,t,t,t,t,t,t,t,"Page "+(g+1)+" of "+u.d,t,t,t,t,t,t,t,t,t,t,t,t,t,t,s,t,t,t,t,t,t,t,t)
w=h/2
return B.bJ(t,t,B.cp(t,!1,A.P,v,t,!1,!0,t,!0,t,t,E.V_,t,t,t,t,new C.azq(u,g),t,t,t,new B.bR(new B.K(w,w,w,w),y.B),t,t,t),!1,t,t,!1,t,!1,t,t,t,t,t,t,t,t,t,"Page "+(g+1)+" of "+u.d,t,t,t,t,t,t,t,t,t,t,t,t,t,t,s,t,t,t,t,t,t,t,t)},
gL(d){return this.d}}
C.aoD.prototype={
j(d){var x,w,v=this,u=null,t=B.bI(d,y.i),s=t==null?u:t.a
if(s==null)s=A.bz
t=v.c
x=t.d
if(x==null)x=12*v.r
t=t.a.G(s)
t=t==null?u:t.G(v.f)
w=B.ab(x/2)
return new C.aha(v.d,v.e,new B.a1(t,u,u,w,u,u,u,A.q),u)}}
C.aha.prototype={
j(d){var x=null,w=this.c
return B.Kg(x,A.n,A.b6,this.e,this.d,w,x,x,x,w)}}
C.z6.prototype={
F(d){var x,w,v,u,t
if(d==null)return this
x=d.a
w=this.a.F(x)
x=w
w=d.b
v=d.c
u=this.d
if(u==null)u=d.d
t=d.e
return new C.z6(x,w,v,u,t)},
h(d,e){var x
if(e==null)return!1
if(this===e)return!0
x=!1
if(e instanceof C.z6)if(e.a.h(0,this.a))x=e.d==this.d
return x},
gq(d){var x=this
return B.P(x.a,x.b,x.c,x.d,x.e,A.a,A.a,A.a,A.a,A.a,A.a,A.a,A.a,A.a,A.a,A.a,A.a,A.a,A.a,A.a)}}
C.l1.prototype={
F(d){var x,w,v,u=this,t=d.d,s=u.d.F(t)
t=s
s=u.e
s=s==null?null:s.F(d.e)
if(s==null)s=d.e
x=u.f
if(x==null)x=d.f
w=u.r
if(w==null)w=d.r
v=u.w
if(v==null)v=d.w
return new C.l1(t,s,x,w,v,d.a,d.b,d.c)},
h(d,e){var x=this
if(e==null)return!1
if(x===e)return!0
return e instanceof C.l1&&e.d.h(0,x.d)&&J.x(e.e,x.e)&&e.f==x.f&&J.x(e.r,x.r)&&J.x(e.w,x.w)},
gq(d){var x=this
return B.P(x.a,x.b,x.c,x.d,x.e,x.f,x.r,x.w,A.a,A.a,A.a,A.a,A.a,A.a,A.a,A.a,A.a,A.a,A.a,A.a)}}
var z=a.updateTypes(["l1(l1)"])
C.azr.prototype={
$1(d){return d},
$S:z+0}
C.azq.prototype={
$0(){return this.a.e.$1(this.b)},
$S:0};(function inheritance(){var x=a.inheritMany,w=a.inherit
x(B.i,[C.a3j,C.aoD,C.aha])
w(C.azr,B.ap)
w(C.azq,B.aA)
w(C.z6,B.J)
w(C.l1,B.ao)})()
B.ag(b.typeUniverse,JSON.parse('{"a3j":{"i":[],"b":[]},"aoD":{"i":[],"b":[]},"aha":{"i":[],"b":[]},"l1":{"ao":[]}}'))
var y={o:B.e("dC"),z:B.e("l1"),u:B.e("f<b>"),l:B.e("c0<eH>"),B:B.e("bR<eg>"),i:B.e("ue")};(function constants(){D.bZx=new B.c0(A.az,A.o7,A.o7,null,A.az,null,y.l)
D.CZ=new C.z6(D.bZx,null,null,null,null)
D.bZM=new B.c0(A.bQ,A.ch,A.ch,null,A.bQ,null,y.l)
D.D_=new C.z6(D.bZM,null,null,null,null)
D.bgG=new C.l1(D.CZ,D.D_,null,A.iu,A.af,null,null,null)})()};
(a=>{a["d3zuMOWdEUFY2Rge3UdVeMxtJqs="]=a.current})($__dart_deferred_initializers__);