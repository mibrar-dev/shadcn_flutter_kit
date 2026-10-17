((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,B={
bUP(){return new B.Bq(null)},
Bq:function Bq(d){this.a=d},
apJ:function apJ(d,e){var _=this
_.f=_.e=_.d=$
_.dL$=d
_.aK$=e
_.c=_.a=null},
bmJ:function bmJ(d){this.a=d},
a_v:function a_v(){},
bAN(d,e,f){var x,w,v,u="keyframes",t=d.length
if(t===0)throw A.w(A.hs(d,u,"No keyframes found"))
for(x=C.F,w=0;w<d.length;d.length===t||(0,A.F)(d),++w){v=d[w]
if(v.gi8().a<=0)throw A.w(A.hs(v.gi8(),u,"Keyframe durations must be positive"))
x=new A.aW(x.a+v.gi8().a)}t=e==null?A.asg(B.cer(),f.i("0?")):e
return new B.S0(t,x,A.f9(d,f.i("w2<0>")),f.i("S0<0>"))},
bHY(d,e,f,g){if(A.pa(d)&&A.pa(e))return g.a(C.f.am(d+(e-d)*f))
if(typeof d=="number"&&typeof e=="number")return g.a(d+(e-d)*f)
throw A.w(A.e2("TimelineAnimation<"+A.cO(g).l(0)+"> cannot interpolate "+J.bb(d).l(0)+"; pass an explicit `lerp` (see Transformers).",null))},
bUT(d,e,f){return A.fE(d,e,f)},
rb:function rb(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.$ti=g},
AD:function AD(d,e){this.a=d
this.$ti=e},
QX:function QX(d){this.$ti=d},
S0:function S0(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.$ti=g}},D
J=c[1]
A=c[0]
C=c[2]
B=a.updateHolder(c[135],B)
D=c[464]
B.Bq.prototype={
t(){return new B.apJ(null,null)}}
B.apJ.prototype={
ad(){var x,w,v=this,u=null
v.ah()
x=B.bAN(A.a([D.VD,D.a0i,D.bUR],y.t),u,y.b)
v.e!==$&&A.bB()
v.e=x
w=B.bAN(A.a([D.VE,D.bUS],y.o),B.ces(),y.C)
v.f!==$&&A.bB()
v.f=w
x=A.eK(u,x.b,u,u,v)
x.Ee()
v.d!==$&&A.bB()
v.d=x},
m(){var x=this.d
x===$&&A.c()
x.m()
this.adM()},
j(d){var x,w=null,v=this.d
v===$&&A.c()
v=A.h8(v,new B.bmJ(this),w)
x=this.e
x===$&&A.c()
return A.aQ(A.u(A.a([v,C.dd,A.j("total "+C.l.bt(x.b.a,1000)+"ms \xb7 segments "+x.c.length+" \xb7 int lerp \u2192 "+B.bAN(A.a([D.VC],y.A),w,y.e).aD(0.5),w,w,w,w,w,w,w,w,D.c3n,C.ad,w,w,w)],y.u),C.m,C.c,C.i,0,C.h),w,w)}}
B.a_v.prototype={
m(){var x=this,w=x.aK$
if(w!=null)w.P(x.gey())
x.aK$=null
x.T()},
bG(){this.dE()
this.dw()
this.ez()}}
B.rb.prototype={
rN(d,e,f){var x=d.a.$3(this.a,this.b,f)
return x==null?this.$ti.c.a(x):x},
$iw2:1,
gi8(){return this.c}}
B.AD.prototype={
rN(d,e,f){var x
if(e<=0)return this.a
x=e-1
x=d.a.$3(d.c[x].rN(d,x,1),this.a,f)
return x==null?this.$ti.c.a(x):x},
$iw2:1,
gi8(){return C.mG}}
B.QX.prototype={
rN(d,e,f){var x
if(e<=0)throw A.w(A.bn("StillKeyframe without a value needs a previous keyframe to hold, but it is the first segment of the timeline."))
x=e-1
return d.c[x].rN(d,x,1)},
$iw2:1,
gi8(){return C.aI}}
B.S0.prototype={
aD(d){var x,w,v,u,t,s,r,q,p=this,o=C.f.am(C.f.H(d,0,1)*p.b.a)
for(x=p.c,w=x.length,v=C.F,u=0;u<w;++u,v=q){t=x[u]
s=v.a
r=s+t.gi8().a
q=new A.aW(r)
if(o<r)return t.rN(p,u,(o-s)/t.gi8().a)}return C.b.gaj(x).rN(p,w-1,1)}}
var z=a.updateTypes(["0^(0^,0^,C)<J?>","ad?(ad?,ad?,C)"])
B.bmJ.prototype={
$2(d,e){var x,w,v,u=null,t=this.a,s=t.e
s===$&&A.c()
x=t.d
x===$&&A.c()
w=x.x
w===$&&A.c()
v=s.aD(w)
t=t.f
t===$&&A.c()
x=x.x
x===$&&A.c()
return A.aq(u,u,C.n,u,u,new A.a1(t.aD(x),u,u,A.ab(12),u,u,u,C.q),u,v,u,u,u,u,u,v)},
$S:841};(function aliases(){var x=B.a_v.prototype
x.adM=x.m})();(function installTearOffs(){var x=a.installStaticTearOff
x(B,"cer",3,null,["$1$3","$3"],["bHY",function(d,e,f){return B.bHY(d,e,f,y.m)}],0,0)
x(B,"ces",3,null,["$3"],["bUT"],1,0)})();(function inheritance(){var x=a.mixinHard,w=a.inherit,v=a.inheritMany
w(B.Bq,A.r)
w(B.a_v,A.t)
w(B.apJ,B.a_v)
w(B.bmJ,A.bH)
v(A.J,[B.rb,B.AD,B.QX])
w(B.S0,A.cJ)
x(B.a_v,A.ey)})()
A.ag(b.typeUniverse,JSON.parse('{"Bq":{"r":[],"b":[]},"apJ":{"t":["Bq"]},"rb":{"w2":["1"]},"AD":{"w2":["1"]},"QX":{"w2":["1"]},"S0":{"cJ":["1"],"cJ.T":"1"}}'))
var y={t:A.e("f<w2<C>>"),A:A.e("f<w2<E>>"),o:A.e("f<w2<ad?>>"),u:A.e("f<b>"),b:A.e("C"),m:A.e("@"),e:A.e("E"),C:A.e("ad?")};(function constants(){D.VC=new B.rb(0,10,C.it,A.e("rb<E>"))
D.VD=new B.rb(24,72,C.aY,A.e("rb<C>"))
D.VE=new B.rb(C.db,C.pL,C.kj,A.e("rb<ad?>"))
D.a0i=new B.QX(A.e("QX<C>"))
D.bUR=new B.AD(24,A.e("AD<C>"))
D.bUS=new B.AD(C.db,A.e("AD<ad?>"))
D.c3n=new A.bj(!0,null,null,null,null,null,13,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)})()};
(a=>{a["V6BymLlWedR8rU8nCXopsXPqL8s="]=a.current})($__dart_deferred_initializers__);