((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,B={vr:function vr(d,e,f,g,h,i,j,k,l,m,n,o,p,q){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k
_.x=l
_.y=m
_.Q=n
_.ax=o
_.ay=p
_.CW=q},vq:function vq(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},LS:function LS(d,e){this.a=d
this.b=e},
bEn(d,e,f,g,h,i,j,k,l,m,n){return new B.LT(j,h,k,g,m,d,e,i,n,l,f)},
LT:function LT(d,e,f,g,h,i,j,k,l,m,n){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.w=i
_.x=j
_.y=k
_.z=l
_.Q=m
_.at=n},
ays:function ays(){},
H6:function H6(d,e,f){this.a=d
this.b=e
this.c=f},
tZ:function tZ(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
aS4:function aS4(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
bHv(d){var x,w,v,u=new B.boD(d).aJA(),t=u.a
if(t!=="svg")throw A.w(A.cr("Expected a root <svg> element, got <"+t+">",null,null))
x=B.bUq(u)
w=A.H(y.N,y.P)
B.bHw(u,w)
v=A.a([],y.j)
new B.b5r(w,v).a77(u,new B.ajg(A.eQ(),C.cm,!0,1,D.bEU))
return new B.x7(x,v)},
bUq(d){var x,w,v,u,t,s=d.BJ("viewBox")
if(s!=null){x=B.bqA(s)
if(x.length!==4)throw A.w(A.cr("Expected four numbers in viewBox, got: "+s,null,null))
w=x[0]
v=x[1]
return new A.O(w,v,w+x[2],v+x[3])}u=B.bKl(d.BJ("width"))
t=B.bKl(d.BJ("height"))
if(u==null||t==null)throw A.w(D.bjU)
return new A.O(0,0,0+u,0+t)},
bHw(d,e){var x,w,v,u,t,s
for(x=d.c,w=x.length,v=0;v<x.length;x.length===w||(0,A.F)(x),++v){u=x[v]
if(u.a==="clipPath"){t=u.b.k(0,"id")
s=t==null||t.length===0?null:t
if(s!=null)e.n(0,s,u.c)}B.bHw(u,e)}},
bIv(d){var x,w,v,u,t,s,r=d.BJ("style")
if(r==null)return d.b
x=y.N
w=A.hi(d.b,x,x)
for(x=r.split(";"),v=x.length,u=0;u<v;++u){t=x[u]
s=C.d.dt(t,":")
if(s<=0)continue
w.n(0,C.d.au(C.d.S(t,0,s)),C.d.au(C.d.aL(t,s+1)))}return w},
hO(d,e){var x=d.k(0,e)
return x==null||x.length===0?null:C.d.au(x)},
bqA(d){var x,w,v,u,t,s=A.a([],y.n)
for(x=$.bO4().mv(0,d),x=new A.ug(x.a,x.b,x.c),w=y.F;x.u();){v=x.d
u=(v==null?w.a(v):v).b[0]
u.toString
t=A.ex(u)
if(t!=null)s.push(t)}return s},
bKl(d){if(d==null)return null
return A.ex(C.d.au(C.d.dI(d,"px")?C.d.S(d,0,d.length-2):d))},
c1M(d){var x,w,v,u,t,s,r,q=C.d.au(d)
if(q.length===0||q==="none"||q==="transparent")return null
if(C.d.ac(q,"#")){x=C.d.aL(q,1)
w=x.length
switch(w){case 3:case 4:for(v=0,u="";v<w;++v,u=t){t=x[v]
t=u+t+t}return B.bKh(u.charCodeAt(0)==0?u:u)
case 6:case 8:return B.bKh(x)
default:return null}}s=$.bO5().fG(q)
if(s!=null){w=s.b[1]
w.toString
r=B.bqA(w)
w=r.length
if(w<3)return null
return A.fn(C.f.am(C.f.H(w>3?r[3]:1,0,1)*255),C.l.H(C.f.am(r[0]),0,255),C.l.H(C.f.am(r[1]),0,255),C.l.H(C.f.am(r[2]),0,255))}return D.bOz.k(0,q.toLowerCase())},
bKh(d){var x=A.eT(d,16)
if(x==null)return null
if(d.length===6)return A.ci((x|4278190080)>>>0)
return A.ci(((x&255)<<24|C.l.f3(x,8))>>>0)},
bKo(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k=A.eQ()
for(x=$.bOp().mv(0,d),x=new A.ug(x.a,x.b,x.c),w=y.F;x.u();){v=x.d
u=(v==null?w.a(v):v).b
t=u[1]
t.toString
u=u[2]
u.toString
s=B.bqA(u)
switch(t){case"matrix":if(s.length===6){u=s[0]
t=s[1]
r=s[2]
q=s[3]
p=s[4]
o=s[5]
n=new Float64Array(16)
n[15]=1
n[14]=0
n[13]=o
n[12]=p
n[11]=0
n[10]=1
n[9]=0
n[8]=0
n[7]=0
n[6]=0
n[5]=q
n[4]=r
n[3]=0
n[2]=0
n[1]=t
n[0]=u
k.er(new A.ch(n))}break
case"translate":u=s.length
if(u!==0){t=s[0]
k.eE(t,u>1?s[1]:0,0,1)}break
case"scale":u=s.length
if(u!==0){t=s[0]
k.nf(t,u>1?s[1]:t,1,1)}break
case"rotate":u=s.length
if(u!==0){m=s[0]*3.141592653589793/180
if(u>=3){k.eE(s[1],s[2],0,1)
k.Ej(m)
k.eE(-s[1],-s[2],0,1)}else k.Ej(m)}break
case"skewX":if(s.length!==0){u=s[0]
l=A.eQ()
t=l.a
u=Math.tan(u*3.141592653589793/180)
t.$flags&2&&A.bk(t)
t[4]=u
k.er(l)}break
case"skewY":if(s.length!==0){u=s[0]
l=A.eQ()
t=l.a
u=Math.tan(u*3.141592653589793/180)
t.$flags&2&&A.bk(t)
t[1]=u
k.er(l)}break}}return k},
aaU:function aaU(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
x7:function x7(d,e){this.a=d
this.b=e},
ajg:function ajg(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
b5r:function b5r(d,e){this.a=d
this.b=e},
bM4(d,e){var x=new A.cD($.an().r,C.aj,null,null,A.a([],y.v))
x.smN(e)
new B.bkS(d,x).a6G()
return x},
bkS:function bkS(d,e){var _=this
_.a=d
_.b=e
_.r=_.f=_.e=_.d=_.c=0
_.z=_.y=_.x=_.w=null},
bWp(d){if(!C.d.v(d,"&"))return d
return A.bCz(d,$.bNw(),new B.boE(),null)},
HY:function HY(d,e,f){this.a=d
this.b=e
this.c=f},
boD:function boD(d){this.a=d
this.b=0},
boE:function boE(){},
ayp:function ayp(d){var _=this
_.a=d
_.b=null
_.c=!1
_.d=null
_.e=!1},
ayq:function ayq(d){this.a=d},
ayr:function ayr(d){this.a=d},
a2V:function a2V(d,e,f){this.e=d
this.c=e
this.a=f},
PO:function PO(d,e,f,g,h,i,j){var _=this
_.C=d
_.a2=e
_.U=f
_.aU=_.bd=null
_.bF=g
_.J$=h
_.dy=i
_.b=_.fy=null
_.c=0
_.y=_.d=null
_.z=!0
_.Q=null
_.as=!1
_.at=null
_.ay=$
_.ch=j
_.CW=!1
_.cx=$
_.cy=!0
_.db=!1
_.dx=$},
aS5:function aS5(d,e){this.a=d
this.b=e},
aS6:function aS6(d){this.a=d},
pH:function pH(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
ah0:function ah0(){this.d=$
this.c=this.a=null},
b2l:function b2l(d){this.a=d},
b2k:function b2k(d){this.a=d},
ass(d){var x,w
for(x=0;x<5;++x){w=D.kH[x]
if(w.a===d)return w}return null},
vs:function vs(d,e,f){this.a=d
this.c=e
this.d=f},
ayt:function ayt(){},
a_K(d){return A.au(["left",d.a,"top",d.b,"right",d.c,"bottom",d.d],y.N,y.X)}},D,E
J=c[1]
A=c[0]
C=c[2]
B=a.updateHolder(c[173],B)
D=c[467]
E=c[473]
B.vr.prototype={
Om(d){var x,w,v,u,t=this,s=t.y,r=t.r
if(r==null)r=null
if(d===C.hB)return B.bEn(t.CW,t.x,null,t.f,C.hB,s,t.a,t.w,C.R,r,s)
x=t.Q
if(x==null){w=s.b
v=new A.K(w,0,w,s.d)}else v=x
if(x==null){w=s.b
u=new A.K(w,0,w,s.d)}else u=x
w=t.w
return B.bEn(t.CW,t.x,null,t.f,C.kY,v,t.a,new A.a2(w.b,w.a),C.R,r,u)},
aKL(){return this.Om(C.hB)},
dC(){var x,w=this,v=y.N,u=y.X,t=A.H(v,u)
t.n(0,"id",w.a)
t.n(0,"name",w.b)
t.n(0,"brand",w.c)
x=w.d
if(x!=null)t.n(0,"year",x)
t.n(0,"platform",w.e.b)
t.n(0,"kind",w.CW.b)
x=w.w
t.n(0,"portraitSize",A.au(["width",x.a,"height",x.b],v,u))
t.n(0,"frame",w.f.dC())
v=w.r
if(v!=null)t.n(0,"systemUi",v.dC())
t.n(0,"devicePixelRatio",w.x)
t.n(0,"portraitPadding",B.a_K(w.y))
v=w.Q
if(v!=null)t.n(0,"landscapePadding",B.a_K(v))
t.n(0,"systemGestureInsets",B.a_K(C.R))
v=w.ax
if(v!=null)t.n(0,"portraitKeyboardHeight",v)
v=w.ay
if(v!=null)t.n(0,"landscapeKeyboardHeight",v)
return t},
h(d,e){var x=this
if(e==null)return!1
if(x===e)return!0
return e instanceof B.vr&&e.a===x.a&&e.b===x.b&&e.c===x.c&&e.d==x.d&&e.e===x.e&&e.f.h(0,x.f)&&J.x(e.r,x.r)&&e.w.h(0,x.w)&&e.x===x.x&&e.y.h(0,x.y)&&J.x(e.Q,x.Q)&&C.R.h(0,C.R)&&e.ax==x.ax&&e.ay==x.ay&&A.cu(D.tG,D.tG)&&e.CW===x.CW},
gq(d){var x=this
return A.P(x.a,x.b,x.c,x.d,x.e,x.f,x.r,x.w,x.x,x.y,null,x.Q,null,C.R,x.ax,x.ay,A.bo(D.tG),x.CW,C.a,C.a)},
l(d){return"DevicePreset("+this.a+", "+this.b+")"}}
B.vq.prototype={
aBU(d,e){var x,w,v,u=this.b,t=-u.a
u=-u.b
x=this.a
w=t+x.a
x=u+x.b
if(e===C.hB)return new A.O(t,u,w,x)
v=d.b
return new A.O(u,v-w,x,v-t)},
dC(){var x=this,w=y.N,v=y.X,u=A.H(w,v),t=x.a
u.n(0,"size",A.au(["width",t.a,"height",t.b],w,v))
t=x.b
if(!t.h(0,C.x))u.n(0,"screenOffset",A.au(["x",t.a,"y",t.b],w,v))
w=x.c
if(w.length!==0)u.n(0,"screenPath",w)
w=x.d
if(w.length!==0)u.n(0,"body",w)
return u},
h(d,e){var x=this
if(e==null)return!1
if(x===e)return!0
return e instanceof B.vq&&e.a.h(0,x.a)&&e.b.h(0,x.b)&&e.c===x.c&&e.d===x.d},
gq(d){var x=this
return A.P(x.a,x.b,x.c,x.d,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a)},
l(d){var x=this
return"DeviceFrame(size: "+x.a.l(0)+", screenOffset: "+x.b.l(0)+", screenPath: "+x.c.length+" chars, body: "+x.d.length+" chars)"}}
B.LS.prototype={
K(){return"DeviceKind."+this.b}}
B.LT.prototype={
gaCY(){var x=this.c,w=new A.O(0,0,0+x.a,0+x.b),v=this.d,u=v.a.gab(0)
if(u)return w
return w.h9(v.aBU(x,this.b))},
dC(){var x,w=this,v=y.N,u=y.X,t=A.H(v,u)
t.n(0,"presetId",w.a)
t.n(0,"orientation",w.b.b)
x=w.c
t.n(0,"screenSize",A.au(["width",x.a,"height",x.b],v,u))
t.n(0,"frame",w.d.dC())
v=w.e
if(v!=null)t.n(0,"systemUi",v.dC())
t.n(0,"deviceKind",w.w.b)
t.n(0,"devicePixelRatio",w.x)
t.n(0,"padding",B.a_K(w.y))
t.n(0,"viewPadding",B.a_K(w.z))
t.n(0,"systemGestureInsets",B.a_K(w.Q))
v=w.at
if(v!=null){u=A.am(v).i("ar<1,b9<q,J?>>")
v=A.af(new A.ar(v,new B.ays(),u),u.i("b8.E"))
t.n(0,"displayFeatures",v)}return t},
h(d,e){var x,w=this
if(e==null)return!1
if(w===e)return!0
x=!1
if(e instanceof B.LT)if(e.a===w.a)if(e.b===w.b)if(e.c.h(0,w.c))if(e.d.h(0,w.d))if(J.x(e.e,w.e))if(e.w===w.w)if(e.x===w.x)if(e.y.h(0,w.y))if(e.z.h(0,w.z))if(e.Q.h(0,w.Q))if(A.cu(e.at,w.at))x=A.cu(null,null)
return x},
gq(d){var x=this,w=null,v=x.at
v=v==null?w:A.bo(v)
return A.P(x.a,x.b,x.c,x.d,x.e,!0,w,x.w,x.x,x.y,x.z,x.Q,w,v,w,w,w,w,w,w)},
l(d){var x,w=this,v=A.a([],y.s)
v.push("presetId: "+w.a)
v.push("orientation: "+w.b.b)
v.push("screenSize: "+w.c.l(0))
v.push("frame: "+w.d.l(0))
x=w.e
if(x!=null)v.push("systemUi: "+x.l(0))
v.push("deviceKind: "+w.w.b)
v.push("devicePixelRatio: "+w.x)
v.push("padding: "+w.y.l(0))
v.push("viewPadding: "+w.z.l(0))
v.push("systemGestureInsets: "+w.Q.l(0))
x=w.at
if(x!=null)v.push("displayFeatures: "+A.D(x))
return"DeviceSimulation("+C.b.aR(v,", ")+")"}}
B.H6.prototype={
dC(){var x=A.H(y.N,y.X),w=this.a,v=w.gab(0)
if(!v)x.n(0,"statusBar",w.dC())
w=this.b
v=w.gab(0)
if(!v)x.n(0,"navigationBar",w.dC())
x.n(0,"platform",this.c.b)
return x},
h(d,e){var x=this
if(e==null)return!1
if(x===e)return!0
return e instanceof B.H6&&e.a.h(0,x.a)&&e.b.h(0,x.b)&&e.c===x.c},
gq(d){return A.P(this.a,this.b,this.c,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a)},
l(d){return"SystemUiSimulation(statusBar: "+this.a.l(0)+", navigationBar: "+this.b.l(0)+", platform: "+this.c.l(0)+")"}}
B.tZ.prototype={
gab(d){return this.a.length===0&&this.b.length===0&&this.c.length===0},
dC(){var x=this,w=A.H(y.N,y.X),v=x.a
if(v.length!==0)w.n(0,"leading",v)
v=x.b
if(v.length!==0)w.n(0,"center",v)
v=x.c
if(v.length!==0)w.n(0,"trailing",v)
w.n(0,"inset",x.d)
v=x.e
if(v!=null)w.n(0,"bottomInset",v)
return w},
h(d,e){var x=this
if(e==null)return!1
if(x===e)return!0
return e instanceof B.tZ&&e.a===x.a&&e.b===x.b&&e.c===x.c&&e.d===x.d&&e.e==x.e},
gq(d){var x=this
return A.P(x.a,x.b,x.c,x.d,x.e,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a)},
l(d){var x=this
return"SystemUiBar(leading: "+x.a.length+" chars, center: "+x.b.length+" chars, trailing: "+x.c.length+" chars, inset: "+x.d+", bottomInset: "+A.D(x.e)+")"}}
B.aS4.prototype={
h(d,e){var x=this
if(e==null)return!1
if(x===e)return!0
return e instanceof B.aS4&&e.a.h(0,x.a)&&e.b.h(0,x.b)&&e.c.h(0,x.c)&&e.d.h(0,x.d)&&e.e.h(0,x.e)},
gq(d){var x=this
return A.P(x.a,x.b,x.c,x.d,x.e,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a)},
l(d){return"SystemUiColors(statusBarIcons: "+this.a.l(0)+", navigationBarIcons: "+this.b.l(0)+")"}}
B.aaU.prototype={}
B.x7.prototype={
aJq(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l,k
$.an()
x=A.bD()
x.f=!0
for(w=this.b,v=w.length,u=d.a,t=e!=null,s=0;s<w.length;w.length===v||(0,A.F)(w),++s){r=w[s]
q=t&&r.d
p=r.b
if(q)p=e.aM(e.a*p.a)
q=r.c
if(q.length===0){q=r.a
x.r=p.N()
o=x.du()
n=q.e
u.drawPath((n==null?q.e=new A.n8(q.ghW().a.snapshot()):n).a,o)
o.delete()
continue}J.b7(u.save())
for(n=q.length,m=0;m<q.length;q.length===n||(0,A.F)(q),++m){l=q[m]
k=l.e
if(k==null)k=l.e=new A.n8(l.ghW().a.snapshot())
u.clipPath(k.a,$.K2(),!0)}q=r.a
x.r=p.N()
o=x.du()
n=q.e
u.drawPath((n==null?q.e=new A.n8(q.ghW().a.snapshot()):n).a,o)
o.delete()
u.restore()}},
a5S(d,e,f){var x,w,v,u,t,s,r=this
if(r.b.length===0||r.a.gab(0)||e.gab(0))return
x=d.a
J.b7(x.save())
w=e.a
v=e.b
x.translate(w,v)
u=r.a
t=u.a
s=u.b
d.tZ((e.c-w)/(u.c-t),(e.d-v)/(u.d-s))
x.translate(-t,-s)
r.aJq(d,f)
x.restore()},
aJu(d,e){return this.a5S(d,e,null)}}
B.ajg.prototype={}
B.b5r.prototype={
a77(d,e){var x,w,v
for(x=d.c,w=x.length,v=0;v<x.length;x.length===w||(0,A.F)(x),++v)this.aAT(x[v],e)},
aAT(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j=this,i=d.a
if(D.bWs.v(0,i))return
x=B.bIv(d)
w=new Float64Array(16)
v=new A.ch(w)
v.dH(e.a)
u=B.hO(x,"transform")
if(u!=null)v.er(B.bKo(u))
t=B.hO(x,"opacity")
t=t==null?null:A.ex(t)
if(t==null)t=1
s=e.d*t
r=B.hO(x,"fill")
q=e.c
if(r==="currentColor"){p=e.b
if(p==null)p=C.cm
q=!0}else if(r==null)p=e.b
else if(r==="none"||r==="transparent")p=null
else{o=B.c1M(r)
t=o==null
p=t?e.b:o
q=t&&q}n=j.avK(x,v,e)
if(D.bWg.v(0,i)){j.a77(d,new B.ajg(v,p,q,s,n))
return}if(p==null)return
m=j.Se(d,x)
if(m==null)return
i=B.hO(x,"fill-opacity")
l=i==null?null:A.ex(i)
k=C.f.H(s*(l==null?1:l),0,1)
j.b.push(new B.aaU(m.aD(w),p.aM(p.a*k),n,q))},
avK(a0,a1,a2){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=null,d=B.hO(a0,"clip-path")
if(d==null)return a2.e
x=$.bOr().fG(d)
w=x==null?e:x.b[1]
v=w==null?e:this.a.k(0,w)
if(v==null||v.length===0)return a2.e
u=$.an()
t=A.a([],y.v)
s=new A.cD(u.r,C.aj,e,e,t)
for(u=v.length,r=y.t,q=0;q<v.length;v.length===u||(0,A.F)(v),++q){p=v[q]
o=B.bIv(p)
n=this.Se(p,o)
if(n==null)continue
m=o.k(0,"transform")
l=m==null||m.length===0?e:C.d.au(m)
if(l==null)k=n
else{k=B.bKo(l)
j=n.b
i=n.a
h=n.c
g=n.d
f=A.j0(n.r,!0,r)
g=new A.cD(i,j,h,g,f)
f.push(new A.Sa(new Float64Array(A.p9(k.a))))
k=g}j=k.b
i=k.c
h=A.j0(k.r,!0,r)
k=new A.ym(new A.cD(k.a,j,i,k.d,h),C.x,e)
t.push(k)
j=s.f
if(j!=null)k.e9(j)
k=s.e
if(k!=null)k.a.delete()
s.e=null}u=A.af(a2.e,y.i)
u.push(s.aD(a1.a))
return u},
Se(d,e){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i=null,h=B.hO(e,"fill-rule")==="evenodd"?C.uu:C.aj
switch(d.a){case"path":x=B.hO(e,"d")
if(x==null)return i
return B.bM4(x,h)
case"rect":w=B.hO(e,"width")
v=w==null?i:A.ex(w)
if(v==null)v=0
w=B.hO(e,"height")
u=w==null?i:A.ex(w)
if(u==null)u=0
if(v<=0||u<=0)return i
w=B.hO(e,"x")
t=w==null?i:A.ex(w)
if(t==null)t=0
w=B.hO(e,"y")
s=w==null?i:A.ex(w)
if(s==null)s=0
w=B.hO(e,"rx")
r=w==null?i:A.ex(w)
w=B.hO(e,"ry")
q=w==null?i:A.ex(w)
w=t+v
p=s+u
o=new A.cD($.an().r,C.aj,i,i,A.a([],y.v))
o.smN(h)
n=r==null
if((n?q:r)==null)o.aP(new A.re(new A.O(t,s,w,p)))
else{if(n){q.toString
n=q}else n=r
if(q==null){r.toString
m=r}else m=q
o.aP(new A.hX(new A.qh(t,s,w,p,n,m,n,m,n,m,n,m)))}return o
case"circle":w=B.hO(e,"r")
l=w==null?i:A.ex(w)
if(l==null)l=0
if(l<=0)return i
w=new A.cD($.an().r,C.aj,i,i,A.a([],y.v))
w.smN(h)
p=B.hO(e,"cx")
p=p==null?i:A.ex(p)
if(p==null)p=0
n=B.hO(e,"cy")
n=n==null?i:A.ex(n)
w.aP(new A.kR(A.oj(new A.y(p,n==null?0:n),l)))
return w
case"ellipse":w=B.hO(e,"rx")
r=w==null?i:A.ex(w)
if(r==null)r=0
w=B.hO(e,"ry")
q=w==null?i:A.ex(w)
if(q==null)q=0
if(r<=0||q<=0)return i
w=new A.cD($.an().r,C.aj,i,i,A.a([],y.v))
w.smN(h)
p=B.hO(e,"cx")
p=p==null?i:A.ex(p)
if(p==null)p=0
n=B.hO(e,"cy")
n=n==null?i:A.ex(n)
w.aP(new A.kR(A.a81(new A.y(p,n==null?0:n),q*2,r*2)))
return w
case"polygon":w=B.hO(e,"points")
k=B.bqA(w==null?"":w)
if(k.length<6)return i
w=$.an()
p=A.a([],y.v)
o=new A.cD(w.r,C.aj,i,i,p)
o.smN(h)
o.aP(new A.i8(k[0],k[1]))
for(j=2;w=j+1,w<k.length;j+=2){w=new A.dT(k[j],k[w])
p.push(w)
n=o.f
if(n!=null)w.e9(n)
w=o.e
if(w!=null)w.a.delete()
o.e=null}o.aP(new A.rw())
return o
default:return i}}}
B.bkS.prototype={
a6G(){var x,w,v,u,t=this
for(x=t.a,w=x.length,v=null;;){t.Jq()
u=t.c
if(u>=w)return
if(C.d.v("MmZzLlHhVvCcSsQqTtAa",A.dN(x.charCodeAt(u)))){u=t.c
v=x[u]
t.c=u+1}else if(v==null)throw A.w(A.cr("Expected an SVG path command",x,t.c))
else if(v==="Z"||v==="z")throw A.w(A.cr('Unexpected argument after a "close" command',x,t.c))
t.aji(v)
if(v==="M")v="L"
else if(v==="m")v="l"}},
aji(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h=this,g=d.toUpperCase()!==d
switch(d.toUpperCase()){case"M":x=h.eG()
w=x+(g?h.d:0)
x=h.eG()
v=x+(g?h.e:0)
h.b.aP(new A.i8(w,v))
h.d=h.f=w
h.e=h.r=v
h.zd()
break
case"L":x=h.eG()
u=g?h.d:0
t=h.eG()
s=g?h.e:0
h.A5(x+u,t+s)
break
case"H":x=h.eG()
u=g?h.d:0
h.A5(x+u,h.e)
break
case"V":x=h.d
u=h.eG()
h.A5(x,u+(g?h.e:0))
break
case"C":r=g?h.d:0
q=g?h.e:0
h.Tx(h.eG()+r,h.eG()+q,h.eG()+r,h.eG()+q,h.eG()+r,h.eG()+q)
break
case"S":r=g?h.d:0
q=g?h.e:0
x=h.eG()
u=h.eG()
t=h.eG()
s=h.eG()
p=h.w
o=h.d
o=p==null?o:2*o-p
p=h.x
n=h.e
n=p==null?n:2*n-p
h.Tx(o,n,x+r,u+q,t+r,s+q)
break
case"Q":r=g?h.d:0
q=g?h.e:0
h.Y1(h.eG()+r,h.eG()+q,h.eG()+r,h.eG()+q)
break
case"T":r=g?h.d:0
q=g?h.e:0
x=h.eG()
u=h.eG()
t=h.y
o=h.d
o=t==null?o:2*o-t
t=h.z
n=h.e
n=t==null?n:2*n-t
h.Y1(o,n,x+r,u+q)
break
case"A":m=Math.abs(h.eG())
l=Math.abs(h.eG())
k=h.eG()
j=h.Ut()
i=h.Ut()
x=h.eG()
w=x+(g?h.d:0)
x=h.eG()
v=x+(g?h.e:0)
if(m===0||l===0)h.A5(w,v)
else{h.b.aP(new A.a0i(new A.y(w,v),new A.be(m,l),k,j,i))
h.d=w
h.e=v
h.zd()}break
case"Z":h.b.aP(new A.rw())
h.d=h.f
h.e=h.r
h.zd()
break
default:throw A.w(A.cr('Unsupported SVG path command "'+d+'"',h.a,h.c))}},
A5(d,e){var x=this
x.b.aP(new A.dT(d,e))
x.d=d
x.e=e
x.zd()},
Tx(d,e,f,g,h,i){var x=this
x.b.aP(new A.a2A(d,e,f,g,h,i))
x.d=h
x.e=i
x.z=x.y=null
x.w=f
x.x=g},
Y1(d,e,f,g){var x=this
x.b.aP(new A.ty(d,e,f,g))
x.d=f
x.e=g
x.x=x.w=null
x.y=d
x.z=e},
zd(){var x=this
x.z=x.y=x.x=x.w=null},
Jq(){var x,w,v,u
for(x=this.a,w=x.length;v=this.c,v<w;){u=x.charCodeAt(v)
if(u===32||u===9||u===10||u===13||u===12||u===44)this.c=v+1
else return}},
eG(){var x,w,v,u,t,s,r,q,p,o=this
o.Jq()
x=o.c
w=o.a
v=w.length
if(x<v){u=w.charCodeAt(x)
if(u===43||u===45){t=x+1
o.c=t}else t=x}else t=x
for(;;){s=t<v
if(s){r=w.charCodeAt(t)
r=r>=48&&r<=57}else r=!1
if(!r)break;++t
o.c=t}if(s&&w.charCodeAt(t)===46){++t
o.c=t
for(;;){if(t<v){s=w.charCodeAt(t)
s=s>=48&&s<=57}else s=!1
if(!s)break;++t
o.c=t}}if(t<v){u=w.charCodeAt(t)
if(u===101||u===69){s=o.c=t+1
if(s<v){q=w.charCodeAt(s)
if(q===43||q===45){++s
o.c=s}}if(s<v){r=w.charCodeAt(s)
r=r>=48&&r<=57}else r=!1
if(r){t=s
for(;;){if(t<v){s=w.charCodeAt(t)
s=s>=48&&s<=57}else s=!1
if(!s)break;++t
o.c=t}v=t}else{o.c=t
v=t}}else v=t}else v=t
p=A.ex(C.d.S(w,x,v))
if(p==null)throw A.w(A.cr("Expected a number",w,x))
return p},
Ut(){var x,w,v,u=this
u.Jq()
x=u.c
w=u.a
if(x>=w.length)throw A.w(A.cr("Expected an arc flag",w,x))
v=w.charCodeAt(x)
if(v!==48&&v!==49)throw A.w(A.cr('Expected an arc flag ("0" or "1")',w,x))
u.c=x+1
return v===49}}
B.HY.prototype={
BJ(d){var x=this.b.k(0,d)
return x==null||x.length===0?null:x},
l(d){var x=this.b
return"<"+this.a+" "+new A.bZ(x,A.G(x).i("bZ<1>")).aR(0," ")+">"}}
B.boD.prototype={
aJA(){var x,w,v,u=this
for(x=u.a,w=x.length;;){u.vY()
v=u.b
if(v>=w)throw A.w(A.cr("No XML element found",x,v))
if(!C.d.bP(x,"<",v))throw A.w(A.cr("Expected an element",x,v))
if(C.d.bP(x,"<?",v))u.rf("?>")
else if(C.d.bP(x,"<!--",v))u.rf("-->")
else if(C.d.bP(x,"<!",v))u.ZN()
else return u.Xx()}},
Xx(){var x,w,v,u,t,s,r,q,p,o,n=this
n.ajn("<")
x=n.IM()
w=y.N
v=A.H(w,w)
for(w=n.a;;){n.vY()
u=n.b
if(C.d.bP(w,"/>",u)){n.b=u+2
t=C.d.dt(x,":")
return new B.HY(t===-1?x:C.d.aL(x,t+1),v,D.bEV)}if(C.d.bP(w,">",u)){n.b=u+1
break}s=n.IM()
n.vY()
u=n.b
if(!C.d.bP(w,"=",u))A.az(A.cr('Expected "="',w,u))
n.b=u+1
n.vY()
v.n(0,s,n.auY())}r=A.a([],y.y)
for(u=w.length;;){q=n.b
n.ay7(60)
p=n.b
if(p>=u)throw A.w(A.cr('Unterminated element "<'+x+'>"',w,q))
if(C.d.bP(w,"</",p)){n.b=p+2
o=n.IM()
n.vY()
u=n.b
if(!C.d.bP(w,">",u))A.az(A.cr('Expected ">"',w,u));++u
n.b=u
if(o!==x)throw A.w(A.cr('Closing tag "</'+o+'>" does not match "<'+x+'>"',w,u))
t=C.d.dt(x,":")
return new B.HY(t===-1?x:C.d.aL(x,t+1),v,r)}if(C.d.bP(w,"<!--",p))n.rf("-->")
else if(C.d.bP(w,"<![CDATA[",p))n.rf("]]>")
else if(C.d.bP(w,"<?",p))n.rf("?>")
else if(C.d.bP(w,"<!",p))n.ZN()
else r.push(n.Xx())}},
ajn(d){var x=this.a,w=this.b
if(!C.d.bP(x,d,w))throw A.w(A.cr('Expected "'+d+'"',x,w))
this.b=w+d.length},
rf(d){var x=this.a,w=this.b,v=C.d.k9(x,d,w)
if(v===-1)throw A.w(A.cr('Expected "'+d+'"',x,w))
this.b=v+d.length},
ay7(d){var x,w=this.a,v=w.length
for(;;){x=this.b
if(!(x<v&&w.charCodeAt(x)!==d))break
this.b=x+1}},
ZN(){var x,w,v,u,t,s=this
s.b+=2
x=s.a
w=x.length
v=1
for(;;){u=s.b
if(!(u<w&&v>0))break
A:{t=x.charCodeAt(u)
if(t===91){s.rf("]")
break A}if(t===62)--v
s.b=u+1}}if(v>0)throw A.w(A.cr("Unterminated declaration",x,u))},
vY(){var x,w,v,u
for(x=this.a,w=x.length;v=this.b,v<w;){u=x.charCodeAt(v)
if(u===32||u===9||u===10||u===13)this.b=v+1
else return}},
IM(){var x,w,v,u,t,s,r=this.b
for(x=this.a,w=x.length,v=r;v<w;){u=x.charCodeAt(v)
t=!0
if(!(u>=65&&u<=90))if(!(u>=97&&u<=122)){s=u>=48&&u<=57||u===45||u===95||u===46||u===58
t=s}if(!t)break;++v
this.b=v}if(v===r)throw A.w(A.cr("Expected a name",x,r))
return C.d.S(x,r,v)},
auY(){var x,w,v,u=this,t=u.b,s=u.a,r=s.length
if(t>=r)throw A.w(A.cr("Expected an attribute value",s,t))
x=s.charCodeAt(t)
if(x!==34&&x!==39)throw A.w(A.cr("Attribute values must be quoted",s,t))
t=u.b=t+1
w=t
for(;;){if(!(w<r&&s.charCodeAt(w)!==x))break;++w
u.b=w}if(w>=r)throw A.w(A.cr("Unterminated attribute value",s,t))
v=C.d.S(s,t,w)
u.b=w+1
return B.bWp(v)}}
B.ayp.prototype={
ga1t(){var x=this
if(!x.c){x.c=!0
if(x.a.d.length!==0)x.b=x.Vc(new B.ayq(x),"body artwork")}return x.b},
ga8g(){var x=this
if(!x.e){x.e=!0
if(x.a.c.length!==0)x.d=x.Vc(new B.ayr(x),"screen outline")}return x.d},
a8f(d,e){var x,w=this.ga8g()
if(w==null)return null
if(e===C.hB)return w
x=A.eQ()
x.eE(0,d.b,0,1)
x.Ej(-1.5707963267948966)
return w.aD(x.a)},
aJr(d,e,f){var x,w,v,u,t=this.ga1t()
if(t==null||t.b.length===0)return
x=d.a
J.b7(x.save())
if(f===C.kY){x.translate(0,e.b)
d.Op(-1.5707963267948966)}w=this.a
v=w.b
u=-v.a
v=-v.b
w=w.a
t.aJu(d,new A.O(u,v,u+w.a,v+w.b))
x.restore()},
akH(d,e){var x,w,v,u
try{v=d.$0()
return v}catch(u){x=A.aG(u)
w=A.bf(u)
v=A.bF("while parsing the device frame "+e)
A.dx(new A.bU(x,w,"device_preview",v,null,!1))
return null}},
Vc(d,e){return this.akH(d,e,y.z)}}
B.a2V.prototype={
aJ(d){var x=A.eZ(d)
if(x==null)x=C.t
x=new B.PO(this.e,null,x,A.aU(),null,new A.bw(),A.aU())
x.aH()
x.sb1(null)
return x},
aO(d,e){var x
e.sa9I(this.e)
e.saJn(null)
x=A.eZ(d)
e.sbN(x==null?C.t:x)}}
B.PO.prototype={
sa9I(d){var x,w=this,v=w.C
if(d===v)return
if(w.y!=null){x=w.gHC()
v.P(x)
d.a_(x)}w.C=d
w.aQ()},
saJn(d){return},
sbN(d){if(d===this.U)return
this.U=d
this.aQ()},
av(d){this.oT(d)
this.C.a_(this.gHC())},
ak(){this.C.P(this.gHC())
this.mi()},
m(){this.bF.saN(null)
this.hU()},
ani(){return this.aQ()},
gaeD(){var x=this,w=x.C.a,v=w==null?null:w.d
if(v==null)return x.bd=null
w=x.bd
if(!J.x(w==null?null:w.a,v))x.bd=new B.ayp(v)
return x.bd},
gaeE(){var x,w=this,v=w.C.a,u=v==null?null:v.e
if(u!=null){x=u.a.gab(0)
if(x)x=u.b.gab(0)
else x=!1
if(!x)v.toString}else x=!0
if(x)return w.aU=null
x=w.aU
if(!J.x(x==null?null:x.a,u))w.aU=new B.aS5(u,A.H(y.N,y.B))
return w.aU},
asQ(d,e){var x,w,v,u,t,s,r,q,p,o,n=this,m=n.gaeE(),l=n.C.a
if(m==null||l==null)return
x=d.gdU()
w=x.a
J.b7(w.save())
w.translate(e.a,e.b)
v=n.gA()
u=l.y
t=$.bt().c
s=l.e
s=s==null?null:s.c
if((s==null?null:s)==null)A.b1()
r=t.d===C.ae?C.bU:C.ae
t=r===C.bU
s=t?C.aN:D.xV
t=t?C.aN:D.xV
q=n.U
p=m.a
o=u.b
if(o>0)m.Xl(x,C.aB,p.a,C.aB,!1,new A.O(0,0,0+v.a,0+o),q,s)
u=u.d
if(u>0){s=v.b-u
m.Xl(x,C.aB,p.b,C.aB,!0,new A.O(0,s,0+v.a,s+u),q,t)}w.restore()},
asN(d,e){return},
Ir(d,e){this.lf(d,e)
this.asN(d,e)
this.asQ(d,e)},
aC(d,e){var x,w,v,u,t,s,r=this,q=r.gaeD()
if(q==null){r.bF.saN(null)
r.Ir(d,e)
return}x=r.C.a
w=x==null?null:x.b
if(w==null)w=C.hB
v=r.gA()
if(q.ga1t()!=null){u=d.gdU()
x=u.a
J.b7(x.save())
x.translate(e.a,e.b)
q.aJr(u,v,w)
x.restore()}t=q.a8f(v,w)
if(t==null){r.bF.saN(null)
r.Ir(d,e)
return}x=r.bF
s=r.cx
s===$&&A.c()
x.saN(d.aJU(s,e,new A.O(0,0,0+v.a,0+v.b),t,r.gasL(),x.a))}}
B.aS5.prototype={
Xl(d,e,f,g,h,i,j,k){var x,w,v,u
if(e.a>0){$.an()
x=A.bD()
x.r=e.N()
d.fi(i,x)}if(g.a>0){x=i.a
w=h?i.b:i.d-1
$.an()
v=A.bD()
v.r=g.N()
d.fi(new A.O(x,w,x+(i.c-x),w+1),v)}u=j===C.ah
this.Iq(d,-1,f,i,u?f.c:f.a,k)
this.Iq(d,0,f,i,f.b,k)
this.Iq(d,1,f,i,u?f.a:f.c,k)},
Iq(d,e,f,g,h,i){var x,w,v,u,t,s,r
if(h.length===0)return
x=this.aiT(h)
w=!0
if(x!=null)if(x.b.length!==0){w=x.a
w=new A.a2(w.c-w.a,w.d-w.b).gab(0)}if(w)return
w=x.a
v=w.c-w.a
w=w.d-w.b
A:{if(e<0){u=g.a+f.d
break A}if(0===e){u=g.gb0().a-v/2
break A}u=g.c-f.d-v
break A}t=f.e
s=t==null?g.gb0().b-w/2:g.d-t-w
r=Math.max(g.b,Math.min(s,g.d-w))
x.a5S(d,new A.O(u,r,u+v,r+w),i)},
aiT(d){return this.b.bk(d,new B.aS6(d))}}
B.pH.prototype={
t(){return new B.ah0()}}
B.ah0.prototype={
ad(){var x,w,v=this
v.ah()
x=v.a
x=x.c.F9(x.e)
w=$.a4()
v.d!==$&&A.bB()
v.d=new A.bp(x,w,y.T)},
al(d){var x,w=this
w.aq(d)
x=w.a
if(d.c!==x.c||d.e!==x.e)w.p(new B.b2l(w))},
m(){var x=this.d
x===$&&A.c()
x.k1$=$.a4()
x.id$=0
this.T()},
j(d){var x,w,v=null,u=A.h(d),t=this.a,s=t.c,r=t.e,q=s.Qp(r),p=s.aJp(r),o=s.a53(r),n=s.qj(r),m=A.d1(d,v)
t=m==null?D.bPn:m
x=t.aE1(s.c.x,p,q,C.R,p)
t=this.d
t===$&&A.c()
w=u.aDC(new B.b2k(s))
return A.bJ(v,v,new A.A(n.a,n.b,new A.I(o,new B.a2V(t,new A.A(q.a,q.b,A.bl(A.Hm(A.Oq(this.a.d,x),w),u.a.b,!0),v),v),v),v),!0,v,v,!1,v,!0,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v)}}
B.vs.prototype={
Qp(d){var x
if(!this.d||d===C.cA)return this.c.w
x=this.c.Om(C.kY)
return x.c},
aJp(d){var x,w
if(!this.d||d===C.cA)return this.c.y
x=this.c
w=x.Q
if(w==null){x=x.y
w=x.b
x=new A.K(w,0,w,x.d)}else x=w
return x},
F9(d){if(!this.d||d===C.cA)return this.c.aKL()
return this.c.Om(C.kY)},
a53(d){var x=this.F9(d),w=x.c,v=x.gaCY(),u=v.gab(0)
if(u)return C.R
u=new B.ayt()
return new A.K(u.$1(-v.a),u.$1(-v.b),u.$1(v.c-w.a),u.$1(v.d-w.b))},
qj(d){var x=this.Qp(d),w=this.a53(d)
return new A.a2(x.a+w.a+w.c,x.b+w.b+w.d)}}
var z=a.updateTypes(["b9<q,J?>(bHd)","x7()","~()","~(mb,y)","x7?()"])
B.ays.prototype={
$1(d){return d.dC()},
$S:z+0}
B.boE.prototype={
$1(d){var x,w=d.ma(1)
w.toString
switch(w){case"amp":return"&"
case"lt":return"<"
case"gt":return">"
case"quot":return'"'
case"apos":return"'"}if(C.d.ac(w,"#x")||C.d.ac(w,"#X")){x=A.eT(C.d.aL(w,2),16)
if(x==null){w=d.ma(0)
w.toString}else w=A.dN(x)
return w}if(C.d.ac(w,"#")){x=A.eT(C.d.aL(w,1),null)
if(x==null){w=d.ma(0)
w.toString}else w=A.dN(x)
return w}w=d.ma(0)
w.toString
return w},
$S:164}
B.ayq.prototype={
$0(){return B.bHv(this.a.a.d)},
$S:z+1}
B.ayr.prototype={
$0(){return B.bM4(this.a.a.c,C.aj)},
$S:735}
B.aS6.prototype={
$0(){var x,w,v,u
try{v=B.bHv(this.a)
return v}catch(u){x=A.aG(u)
w=A.bf(u)
v=A.bF("while parsing simulated system UI")
A.dx(new A.bU(x,w,"device_preview",v,null,!1))
return null}},
$S:z+4}
B.b2l.prototype={
$0(){var x=this.a,w=x.d
w===$&&A.c()
x=x.a
w.sD(x.c.F9(x.e))},
$S:0}
B.b2k.prototype={
$0(){return this.a.c.e},
$S:736}
B.ayt.prototype={
$1(d){return isNaN(d)?0:C.f.H(d,0,1/0)},
$S:1};(function installTearOffs(){var x=a._instance_0u,w=a._instance_2u
var v
x(v=B.PO.prototype,"gHC","ani",2)
w(v,"gasL","Ir",3)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.J,[B.vr,B.vq,B.LT,B.H6,B.tZ,B.aS4,B.aaU,B.x7,B.ajg,B.b5r,B.bkS,B.HY,B.boD,B.ayp,B.aS5,B.vs])
w(B.LS,A.dX)
x(A.ap,[B.ays,B.boE,B.ayt])
x(A.aA,[B.ayq,B.ayr,B.aS6,B.b2l,B.b2k])
w(B.a2V,A.bq)
w(B.PO,A.ol)
w(B.pH,A.r)
w(B.ah0,A.t)})()
A.ag(b.typeUniverse,JSON.parse('{"a2V":{"bq":[],"b_":[],"b":[]},"PO":{"S":[],"bA":["S"],"R":[],"aZ":[]},"pH":{"r":[],"b":[]},"ah0":{"t":["pH"]}}'))
var y=(function rtii(){var x=A.e
return{M:x("fg<q>"),v:x("f<dM>"),s:x("f<q>"),j:x("f<aaU>"),y:x("f<HY>"),n:x("f<C>"),P:x("a3<HY>"),i:x("ws"),t:x("dM"),F:x("wG"),N:x("q"),T:x("bp<LT?>"),z:x("@"),X:x("J?"),B:x("x7?")}})();(function constants(){var x=a.makeConstList
D.xV=new A.ad(1,0.08627450980392157,0.09411764705882353,0.10980392156862745,C.M)
D.bjU=new A.eP("The root <svg> element needs a viewBox or width/height attributes",null,null)
D.bEU=x([],A.e("f<ws>"))
D.tG=x([],A.e("f<bHd>"))
D.bEV=x([],y.y)
D.bY0=new A.a2(436,908)
D.bQU=new A.y(17,17)
D.aoY=new B.vq(D.bY0,D.bQU,"M 317.34,0 C 322.68,0 328.02,0.02 333.37,0.21 C 339.49,0.44 345.54,0.9 351.58,2.03 C 363.77,4.3 374.86,9.23 383.81,18.19 C 392.77,27.14 397.7,38.23 399.97,50.43 C 401.1,56.46 401.56,62.51 401.79,68.62 C 401.98,73.92 402,79.21 402,84.5 L 402,789.5 C 402,794.79 401.98,800.08 401.79,805.38 C 401.56,811.49 401.1,817.54 399.97,823.57 C 397.7,835.77 392.77,846.86 383.81,855.81 C 374.86,864.77 363.77,869.7 351.58,871.97 C 345.54,873.1 339.49,873.56 333.37,873.79 C 328.02,873.98 322.68,874 317.34,874 L 84.66,874 C 79.32,874 73.98,873.98 68.63,873.79 C 62.51,873.56 56.46,873.1 50.42,871.97 C 38.23,869.7 27.14,864.77 18.19,855.81 C 9.23,846.86 4.3,835.77 2.03,823.57 C 0.9,817.54 0.44,811.49 0.21,805.38 C 0.02,800.08 0,794.79 0,789.5 L 0,84.5 C 0,79.21 0.02,73.92 0.21,68.62 C 0.44,62.51 0.9,56.46 2.03,50.43 C 4.3,38.23 9.23,27.14 18.19,18.19 C 27.14,9.23 38.23,4.3 50.42,2.03 C 56.46,0.9 62.51,0.44 68.63,0.21 C 73.98,0.02 79.32,0 84.66,0 L 317.34,0 Z M 245,11 H 157 A 18.5,18.5 0 0 0 157,48 H 245 A 18.5,18.5 0 0 0 245,11 Z",'<svg viewBox="0 0 436 908">\n  <rect x="1" y="1" width="434" height="906" rx="79" fill="#000000"/>\n  <rect x="2" y="2" width="432" height="904" rx="78" fill="#7e7e7e"/>\n  <rect x="16" y="16" width="404" height="876" rx="64" fill="#7e7e7e"/>\n  <rect x="3" y="3" width="430" height="902" rx="77" fill="#2c2c2c"/>\n  <rect x="16" y="16" width="404" height="876" rx="64" fill="#2c2c2c"/>\n  <rect x="8" y="8" width="420" height="892" rx="72" fill="#000000"/>\n  <rect x="16" y="16" width="404" height="876" rx="64" fill="#000000"/>\n</svg>')
D.c1e=new B.tZ('<svg viewBox="0 0 30.75 11.62">\n  <g transform="scale(0.36) translate(-118.17, -47.03)" fill="currentColor">\n    <path d="M129.206 79.3125C126.038 79.3125 123.439 78.446 121.408 76.7131C119.376 74.9801 118.297 72.75 118.169 70.0227H123.325C123.496 71.429 124.128 72.5653 125.222 73.4318C126.315 74.2983 127.658 74.7315 129.249 74.7315C131.053 74.7315 132.509 74.1776 133.616 73.0696C134.739 71.9474 135.3 70.4702 135.3 68.6378C135.3 66.8054 134.739 65.321 133.616 64.1847C132.509 63.0341 131.067 62.4588 129.291 62.4588C128.041 62.4588 126.926 62.7216 125.946 63.2472C124.98 63.7727 124.213 64.5185 123.645 65.4844H118.659L120.257 47.7997H138.773V52.4446H124.518L123.773 61.0739H124.135C125.555 59.1562 127.722 58.1974 130.634 58.1974C133.545 58.1974 135.932 59.1634 137.793 61.0952C139.668 63.027 140.605 65.4986 140.605 68.5099C140.605 71.7202 139.554 74.3267 137.452 76.3295C135.364 78.3182 132.615 79.3125 129.206 79.3125Z"/>\n    <path d="M149.862 75.2855C148.868 75.2855 148.051 74.9659 147.412 74.3267C146.773 73.6875 146.453 72.8849 146.453 71.919C146.453 70.9389 146.773 70.1364 147.412 69.5114C148.051 68.8722 148.868 68.5526 149.862 68.5526C150.871 68.5526 151.688 68.8722 152.313 69.5114C152.952 70.1364 153.271 70.9389 153.271 71.919C153.271 72.8849 152.952 73.6875 152.313 74.3267C151.688 74.9659 150.871 75.2855 149.862 75.2855ZM149.862 59.3054C148.868 59.3054 148.051 58.9929 147.412 58.3679C146.773 57.7287 146.453 56.9261 146.453 55.9602C146.453 54.9801 146.773 54.1776 147.412 53.5526C148.051 52.9134 148.868 52.5937 149.862 52.5937C150.871 52.5937 151.688 52.9134 152.313 53.5526C152.952 54.1776 153.271 54.9801 153.271 55.9602C153.271 56.9261 152.952 57.7287 152.313 58.3679C151.688 58.9929 150.871 59.3054 149.862 59.3054Z"/>\n    <path d="M167.195 78.5455V53.3395H166.833L159.183 58.7088V53.4247L167.216 47.7997H172.692V78.5455H167.195Z"/>\n    <path d="M188 64.9091V60.6477H191.75C193.313 60.6477 194.584 60.2216 195.564 59.3693C196.544 58.5028 197.034 57.3807 197.034 56.0028C197.034 54.6392 196.551 53.5526 195.586 52.7429C194.634 51.919 193.355 51.5071 191.75 51.5071C190.159 51.5071 188.867 51.9261 187.872 52.7642C186.892 53.6023 186.353 54.7457 186.253 56.1946H181.118C181.26 53.3679 182.297 51.1378 184.229 49.5043C186.161 47.8565 188.725 47.0327 191.921 47.0327C194.904 47.0327 197.382 47.8139 199.357 49.3764C201.346 50.9247 202.34 52.8778 202.34 55.2358C202.34 57.0398 201.836 58.581 200.827 59.8594C199.833 61.1378 198.483 61.9545 196.779 62.3097V62.6719C198.881 62.9134 200.536 63.7017 201.743 65.0369C202.965 66.3722 203.576 68.0625 203.576 70.108C203.576 72.75 202.468 74.9446 200.252 76.6918C198.05 78.4389 195.28 79.3125 191.942 79.3125C188.632 79.3125 185.934 78.4673 183.846 76.777C181.772 75.0866 180.664 72.8352 180.522 70.0227H185.784C185.898 71.4432 186.516 72.5795 187.638 73.4318C188.76 74.2699 190.209 74.6889 191.985 74.6889C193.746 74.6889 195.181 74.2344 196.289 73.3253C197.411 72.402 197.972 71.2159 197.972 69.767C197.972 68.2614 197.425 67.0753 196.331 66.2088C195.238 65.3423 193.746 64.9091 191.857 64.9091H188Z"/>\n  </g>\n</svg>',"",'<svg viewBox="0 0 70.53 13.62">\n  <g transform="scale(0.36) translate(-826.18, -43.64)" fill="currentColor">\n    <path d="M826.182 68.8112C826.182 67.2663 827.434 66.014 828.979 66.014H831.776C833.321 66.014 834.573 67.2663 834.573 68.8112V74.4056C834.573 75.9505 833.321 77.2028 831.776 77.2028H828.979C827.434 77.2028 826.182 75.9505 826.182 74.4056V68.8112Z"/>\n    <path d="M840.168 61.8182C840.168 60.2733 841.42 59.021 842.965 59.021H845.762C847.307 59.021 848.559 60.2733 848.559 61.8182V74.4056C848.559 75.9505 847.307 77.2028 845.762 77.2028H842.965C841.42 77.2028 840.168 75.9505 840.168 74.4056V61.8182Z"/>\n    <path d="M854.154 52.028C854.154 50.4831 855.406 49.2308 856.951 49.2308H859.748C861.293 49.2308 862.545 50.4831 862.545 52.028V74.4056C862.545 75.9505 861.293 77.2028 859.748 77.2028H856.951C855.406 77.2028 854.154 75.9505 854.154 74.4056V52.028Z"/>\n    <path d="M868.14 46.4336C868.14 44.8887 869.392 43.6364 870.937 43.6364H873.734C875.279 43.6364 876.531 44.8887 876.531 46.4336V74.4056C876.531 75.9505 875.279 77.2028 873.734 77.2028H870.937C869.392 77.2028 868.14 75.9505 868.14 74.4056V46.4336Z"/>\n    <path d="M913.959 50.8742C920.859 50.8745 927.494 53.5806 932.495 58.4331C932.871 58.8077 933.473 58.803 933.844 58.4225L937.443 54.7146C937.631 54.5216 937.736 54.2601 937.734 53.9882C937.733 53.7162 937.625 53.456 937.435 53.2653C924.311 40.4267 903.606 40.4267 890.482 53.2653C890.291 53.4559 890.184 53.7159 890.182 53.9879C890.18 54.2599 890.285 54.5214 890.472 54.7146L894.073 58.4225C894.443 58.8035 895.046 58.8083 895.422 58.4331C900.423 53.5802 907.059 50.8742 913.959 50.8742ZM914.059 62.0682C917.849 62.068 921.505 63.5062 924.315 66.1035C924.695 66.4721 925.294 66.4641 925.664 66.0855L929.259 62.3775C929.449 62.1831 929.554 61.9192 929.551 61.645C929.548 61.3709 929.438 61.1093 929.245 60.9187C920.688 52.794 907.436 52.794 898.88 60.9187C898.686 61.1093 898.576 61.371 898.573 61.6453C898.571 61.9195 898.676 62.1833 898.866 62.3775L902.46 66.0855C902.831 66.4641 903.429 66.4721 903.809 66.1035C906.618 63.5079 910.27 62.0698 914.059 62.0682ZM921.369 69.3055C921.375 69.5805 921.269 69.8455 921.077 70.0381L914.858 76.4444C914.675 76.6326 914.427 76.7386 914.168 76.7386C913.908 76.7386 913.66 76.6326 913.477 76.4444L907.257 70.0381C907.065 69.8454 906.96 69.5802 906.965 69.3053C906.971 69.0303 907.088 68.77 907.288 68.5857C911.259 65.1568 917.076 65.1568 921.048 68.5857C921.247 68.7701 921.364 69.0306 921.369 69.3055Z" fill-rule="evenodd"/>\n    <path d="M951.27 55.2766C951.27 48.8499 956.48 43.64 962.907 43.64H1003.63C1010.06 43.64 1015.27 48.8499 1015.27 55.2766V69.8224C1015.27 76.2491 1010.06 81.459 1003.63 81.459H962.907C956.48 81.459 951.27 76.2491 951.27 69.8224V55.2766Z M966.132 72.7316L974.868 56.0124V55.7568H964.527V52.2197H979.186V55.7994L970.621 72.7316H966.132Z M990.824 73.2571C989.337 73.2571 988.011 72.9399 986.847 72.3054C985.691 71.6709 984.763 70.7523 984.062 69.5497C982.917 67.7883 982.344 65.4823 982.344 62.6319C982.344 59.2322 983.101 56.5617 984.616 54.6204C986.132 52.679 988.224 51.7084 990.895 51.7084C992.846 51.7084 994.508 52.234 995.881 53.2851C997.263 54.3363 998.102 55.7189 998.395 57.4329H994.148C993.949 56.7606 993.551 56.2255 992.955 55.8278C992.368 55.43 991.671 55.2312 990.867 55.2312C989.465 55.2312 988.362 55.8609 987.557 57.1204C986.761 58.3704 986.387 60.0608 986.435 62.1916H986.69C987.154 61.2256 987.841 60.4822 988.75 59.9614C989.669 59.4311 990.725 59.1659 991.918 59.1659C993.859 59.1659 995.469 59.8099 996.747 61.0978C998.026 62.3857 998.665 64.0098 998.665 65.97C998.665 68.1008 997.931 69.848 996.463 71.2116C994.995 72.5753 993.116 73.2571 990.824 73.2571ZM988.139 68.6832C988.849 69.3839 989.73 69.7343 990.781 69.7343C991.832 69.7343 992.713 69.3887 993.423 68.6974C994.143 67.9966 994.503 67.1301 994.503 66.0979C994.503 65.0562 994.153 64.1944 993.452 63.5126C992.751 62.8213 991.866 62.4756 990.796 62.4756C989.725 62.4756 988.835 62.8166 988.125 63.4984C987.424 64.1802 987.074 65.0325 987.074 66.0553C987.074 67.097 987.429 67.9729 988.139 68.6832Z" fill-rule="evenodd" fill-opacity="0.4"/>\n    <path d="M951.27 55.2766C951.27 48.8499 956.48 43.64 962.907 43.64H997.816V81.459H962.907C956.48 81.459 951.27 76.2491 951.27 69.8224V55.2766Z M966.132 72.7316L974.868 56.0124V55.7568H964.527V52.2197H979.186V55.7994L970.621 72.7316H966.132Z M990.824 73.2571C989.337 73.2571 988.011 72.9399 986.847 72.3054C985.691 71.6709 984.763 70.7523 984.062 69.5497C982.917 67.7883 982.344 65.4823 982.344 62.6319C982.344 59.2322 983.101 56.5617 984.616 54.6204C986.132 52.679 988.224 51.7084 990.895 51.7084C992.846 51.7084 994.508 52.234 995.881 53.2851C997.263 54.3363 998.102 55.7189 998.395 57.4329H994.148C993.949 56.7606 993.551 56.2255 992.955 55.8278C992.368 55.43 991.671 55.2312 990.867 55.2312C989.465 55.2312 988.362 55.8609 987.557 57.1204C986.761 58.3704 986.387 60.0608 986.435 62.1916H986.69C987.154 61.2256 987.841 60.4822 988.75 59.9614C989.669 59.4311 990.725 59.1659 991.918 59.1659C993.859 59.1659 995.469 59.8099 996.747 61.0978C998.026 62.3857 998.665 64.0098 998.665 65.97C998.665 68.1008 997.931 69.848 996.463 71.2116C994.995 72.5753 993.116 73.2571 990.824 73.2571ZM988.139 68.6832C988.849 69.3839 989.73 69.7343 990.781 69.7343C991.832 69.7343 992.713 69.3887 993.423 68.6974C994.143 67.9966 994.503 67.1301 994.503 66.0979C994.503 65.0562 994.153 64.1944 993.452 63.5126C992.751 62.8213 991.866 62.4756 990.796 62.4756C989.725 62.4756 988.835 62.8166 988.125 63.4984C987.424 64.1802 987.074 65.0325 987.074 66.0553C987.074 67.097 987.429 67.9729 988.139 68.6832Z" fill-rule="evenodd"/>\n    <path d="M1018.18 57.6263V69.4317C1020.56 68.4318 1022.1 66.1059 1022.1 63.529C1022.1 60.9521 1020.56 58.6261 1018.18 57.6263Z" fill-opacity="0.4"/>\n  </g>\n</svg>',30,null)
D.c1h=new B.tZ("",'<svg viewBox="0 0 145 5">\n  <path d="M 2.5,0 H 142.5 A 2.5,2.5 0 0 1 145,2.5 V 2.5 A 2.5,2.5 0 0 1 142.5,5 H 2.5 A 2.5,2.5 0 0 1 0,2.5 V 2.5 A 2.5,2.5 0 0 1 2.5,0 Z" fill="currentColor"/>\n</svg>',"",16,8)
D.c1l=new B.H6(D.c1e,D.c1h,C.aE)
D.bY_=new A.a2(402,874)
D.bhD=new A.K(0,62,0,34)
D.bi2=new A.K(62,0,62,20)
D.zh=new B.LS(0,"phone")
D.ap3=new B.vr("apple-iphone-16-pro","iPhone 16 Pro","Apple",2024,C.aE,D.aoY,D.c1l,D.bY_,3,D.bhD,D.bi2,335,208,D.zh)
D.apa=new B.vs(C.im,D.ap3,!0)
D.bXZ=new A.a2(384,796)
D.bQT=new A.y(12,8)
D.aoX=new B.vq(D.bXZ,D.bQT,"M 20,0 H 340 A 20,20 0 0 1 360,20 V 760 A 20,20 0 0 1 340,780 H 20 A 20,20 0 0 1 0,760 V 20 A 20,20 0 0 1 20,0 Z",'<svg viewBox="0 0 384 796">\n  <defs><clipPath id="shell">\n    <path d="M 32,0 H 352 A 28,28 0 0 1 380,28 V 768 A 28,28 0 0 1 352,796 H 32 A 28,28 0 0 1 4,768 V 28 A 28,28 0 0 1 32,0 Z"/>\n  </clipPath></defs>\n  <g fill="#3d4149">\n    <rect x="0" y="159.2" width="6" height="43.78" rx="2"/>\n    <rect x="0" y="214.92" width="6" height="43.78" rx="2"/>\n    <rect x="378" y="191.04" width="6" height="63.68" rx="2"/>\n  </g>\n  <path d="M 32,0 H 352 A 28,28 0 0 1 380,28 V 768 A 28,28 0 0 1 352,796 H 32 A 28,28 0 0 1 4,768 V 28 A 28,28 0 0 1 32,0 Z" fill="#1f2126"/>\n  <path d="M 32,2 H 352 A 26,26 0 0 1 378,28 V 768 A 26,26 0 0 1 352,794 H 32 A 26,26 0 0 1 6,768 V 28 A 26,26 0 0 1 32,2 Z" fill="#3d4149"/>\n  <g clip-path="url(#shell)">\n    <path d="M -796,0 L -477.6,0 L 96,796 L -222.4,796 Z" fill="#ffffff" fill-opacity="0.18"/>\n  </g>\n  <path d="M 32,3.5 H 352 A 24.5,24.5 0 0 1 376.5,28 V 768 A 24.5,24.5 0 0 1 352,792.5 H 32 A 24.5,24.5 0 0 1 7.5,768 V 28 A 24.5,24.5 0 0 1 32,3.5 Z" fill="#08090b"/>\n</svg>')
D.c1f=new B.tZ('<svg viewBox="0 0 26.48 10.01">\n  <g transform="scale(0.31) translate(-118.17, -47.03)" fill="currentColor">\n    <path d="M129.206 79.3125C126.038 79.3125 123.439 78.446 121.408 76.7131C119.376 74.9801 118.297 72.75 118.169 70.0227H123.325C123.496 71.429 124.128 72.5653 125.222 73.4318C126.315 74.2983 127.658 74.7315 129.249 74.7315C131.053 74.7315 132.509 74.1776 133.616 73.0696C134.739 71.9474 135.3 70.4702 135.3 68.6378C135.3 66.8054 134.739 65.321 133.616 64.1847C132.509 63.0341 131.067 62.4588 129.291 62.4588C128.041 62.4588 126.926 62.7216 125.946 63.2472C124.98 63.7727 124.213 64.5185 123.645 65.4844H118.659L120.257 47.7997H138.773V52.4446H124.518L123.773 61.0739H124.135C125.555 59.1562 127.722 58.1974 130.634 58.1974C133.545 58.1974 135.932 59.1634 137.793 61.0952C139.668 63.027 140.605 65.4986 140.605 68.5099C140.605 71.7202 139.554 74.3267 137.452 76.3295C135.364 78.3182 132.615 79.3125 129.206 79.3125Z"/>\n    <path d="M149.862 75.2855C148.868 75.2855 148.051 74.9659 147.412 74.3267C146.773 73.6875 146.453 72.8849 146.453 71.919C146.453 70.9389 146.773 70.1364 147.412 69.5114C148.051 68.8722 148.868 68.5526 149.862 68.5526C150.871 68.5526 151.688 68.8722 152.313 69.5114C152.952 70.1364 153.271 70.9389 153.271 71.919C153.271 72.8849 152.952 73.6875 152.313 74.3267C151.688 74.9659 150.871 75.2855 149.862 75.2855ZM149.862 59.3054C148.868 59.3054 148.051 58.9929 147.412 58.3679C146.773 57.7287 146.453 56.9261 146.453 55.9602C146.453 54.9801 146.773 54.1776 147.412 53.5526C148.051 52.9134 148.868 52.5937 149.862 52.5937C150.871 52.5937 151.688 52.9134 152.313 53.5526C152.952 54.1776 153.271 54.9801 153.271 55.9602C153.271 56.9261 152.952 57.7287 152.313 58.3679C151.688 58.9929 150.871 59.3054 149.862 59.3054Z"/>\n    <path d="M167.195 78.5455V53.3395H166.833L159.183 58.7088V53.4247L167.216 47.7997H172.692V78.5455H167.195Z"/>\n    <path d="M188 64.9091V60.6477H191.75C193.313 60.6477 194.584 60.2216 195.564 59.3693C196.544 58.5028 197.034 57.3807 197.034 56.0028C197.034 54.6392 196.551 53.5526 195.586 52.7429C194.634 51.919 193.355 51.5071 191.75 51.5071C190.159 51.5071 188.867 51.9261 187.872 52.7642C186.892 53.6023 186.353 54.7457 186.253 56.1946H181.118C181.26 53.3679 182.297 51.1378 184.229 49.5043C186.161 47.8565 188.725 47.0327 191.921 47.0327C194.904 47.0327 197.382 47.8139 199.357 49.3764C201.346 50.9247 202.34 52.8778 202.34 55.2358C202.34 57.0398 201.836 58.581 200.827 59.8594C199.833 61.1378 198.483 61.9545 196.779 62.3097V62.6719C198.881 62.9134 200.536 63.7017 201.743 65.0369C202.965 66.3722 203.576 68.0625 203.576 70.108C203.576 72.75 202.468 74.9446 200.252 76.6918C198.05 78.4389 195.28 79.3125 191.942 79.3125C188.632 79.3125 185.934 78.4673 183.846 76.777C181.772 75.0866 180.664 72.8352 180.522 70.0227H185.784C185.898 71.4432 186.516 72.5795 187.638 73.4318C188.76 74.2699 190.209 74.6889 191.985 74.6889C193.746 74.6889 195.181 74.2344 196.289 73.3253C197.411 72.402 197.972 71.2159 197.972 69.767C197.972 68.2614 197.425 67.0753 196.331 66.2088C195.238 65.3423 193.746 64.9091 191.857 64.9091H188Z"/>\n  </g>\n</svg>',"",'<svg viewBox="0 0 63.16 11">\n  <g transform="translate(0, 0)">\n    <path d="M 7.79,10.63 L 0.55,3.85 A 10.54,10.54 0 0 1 15.03,3.85 Z" fill="currentColor"/>\n  </g>\n  <g transform="translate(20.58, 0)">\n    <path d="M 12.83,0 L 12.83,11 L 0,11 Z" fill="currentColor"/>\n  </g>\n  <g transform="translate(38.41, 0)">\n    <path d="M 3.12,0 H 18.88 A 3.12,3.12 0 0 1 22,3.12 V 7.88 A 3.12,3.12 0 0 1 18.88,11 H 3.12 A 3.12,3.12 0 0 1 0,7.88 V 3.12 A 3.12,3.12 0 0 1 3.12,0 Z M 3.3,1.28 H 18.7 A 2.02,2.02 0 0 1 20.72,3.3 V 7.7 A 2.02,2.02 0 0 1 18.7,9.72 H 3.3 A 2.02,2.02 0 0 1 1.28,7.7 V 3.3 A 2.02,2.02 0 0 1 3.3,1.28 Z" fill-rule="evenodd" fill="currentColor" fill-opacity="0.45"/>\n    <path d="M 3.12,1.83 H 13.75 A 1.28,1.28 0 0 1 15.03,3.12 V 7.88 A 1.28,1.28 0 0 1 13.75,9.17 H 3.12 A 1.28,1.28 0 0 1 1.83,7.88 V 3.12 A 1.28,1.28 0 0 1 3.12,1.83 Z" fill="currentColor"/>\n    <path d="M 22.55,3.67 L 22.55,7.33 A 1.47,1.47 0 0 0 22.55,3.67 Z" fill="currentColor" fill-opacity="0.45"/>\n  </g>\n</svg>',16,null)
D.c1i=new B.tZ("",'<svg viewBox="0 0 96 4">\n  <path d="M 2,0 H 94 A 2,2 0 0 1 96,2 V 2 A 2,2 0 0 1 94,4 H 2 A 2,2 0 0 1 0,2 V 2 A 2,2 0 0 1 2,0 Z" fill="currentColor"/>\n</svg>',"",16,9)
D.c1j=new B.H6(D.c1f,D.c1i,C.bA)
D.bXY=new A.a2(360,780)
D.ap2=new B.vr("samsung-galaxy-s25","Galaxy S25","Samsung",2025,C.bA,D.aoX,D.c1j,D.bXY,3,C.mK,C.mK,336,252,D.zh)
D.ap7=new B.vs(C.mk,D.ap2,!0)
D.bY3=new A.a2(938,1298)
D.bQZ=new A.y(59,59)
D.aoV=new B.vq(D.bY3,D.bQZ,"M 25.55,0 C 281.85,0 538.15,0 794.45,0 C 796.52,0 798.71,-0.01 800.29,0.04 C 802.03,0.09 803.72,0.21 805.4,0.53 C 808.83,1.19 812.01,2.69 814.66,5.34 C 817.31,7.99 818.81,11.17 819.46,14.6 C 819.79,16.28 819.91,17.97 819.96,19.71 C 820.01,21.29 820,23.48 820,25.55 L 820,1154.45 C 820,1156.52 820.01,1158.71 819.96,1160.29 C 819.91,1162.03 819.79,1163.72 819.46,1165.4 C 818.81,1168.83 817.31,1172.01 814.66,1174.66 C 812.01,1177.31 808.83,1178.81 805.4,1179.47 C 803.72,1179.79 802.03,1179.91 800.29,1179.96 C 798.71,1180.01 796.52,1180 794.45,1180 L 25.55,1180 C 23.47,1180 21.29,1180.01 19.71,1179.96 C 17.97,1179.91 16.28,1179.79 14.6,1179.47 C 11.17,1178.81 7.99,1177.31 5.34,1174.66 C 2.69,1172.01 1.19,1168.83 0.53,1165.4 C 0.21,1163.72 0.09,1162.03 0.04,1160.29 C -0.01,1158.71 0,1156.52 0,1154.45 L 0,25.55 C 0,23.48 -0.01,21.29 0.04,19.71 C 0.09,17.97 0.21,16.28 0.53,14.6 C 1.19,11.17 2.69,7.99 5.34,5.34 C 7.99,2.69 11.17,1.19 14.6,0.53 C 16.28,0.21 17.97,0.09 19.71,0.04 C 21.29,-0.01 23.48,0 25.55,0 Z",'<svg viewBox="0 0 938 1298">\n  <rect x="0" y="0" width="938" height="1298" rx="81" fill="#7e7e7e"/>\n  <rect x="1" y="1" width="936" height="1296" rx="80" fill="#2c2c2c"/>\n  <rect x="6" y="6" width="926" height="1286" rx="75" fill="#010101"/>\n</svg>')
D.c1g=new B.tZ('<svg viewBox="0 0 29.04 10.98">\n  <g transform="scale(0.34) translate(-118.17, -47.03)" fill="currentColor">\n    <path d="M129.206 79.3125C126.038 79.3125 123.439 78.446 121.408 76.7131C119.376 74.9801 118.297 72.75 118.169 70.0227H123.325C123.496 71.429 124.128 72.5653 125.222 73.4318C126.315 74.2983 127.658 74.7315 129.249 74.7315C131.053 74.7315 132.509 74.1776 133.616 73.0696C134.739 71.9474 135.3 70.4702 135.3 68.6378C135.3 66.8054 134.739 65.321 133.616 64.1847C132.509 63.0341 131.067 62.4588 129.291 62.4588C128.041 62.4588 126.926 62.7216 125.946 63.2472C124.98 63.7727 124.213 64.5185 123.645 65.4844H118.659L120.257 47.7997H138.773V52.4446H124.518L123.773 61.0739H124.135C125.555 59.1562 127.722 58.1974 130.634 58.1974C133.545 58.1974 135.932 59.1634 137.793 61.0952C139.668 63.027 140.605 65.4986 140.605 68.5099C140.605 71.7202 139.554 74.3267 137.452 76.3295C135.364 78.3182 132.615 79.3125 129.206 79.3125Z"/>\n    <path d="M149.862 75.2855C148.868 75.2855 148.051 74.9659 147.412 74.3267C146.773 73.6875 146.453 72.8849 146.453 71.919C146.453 70.9389 146.773 70.1364 147.412 69.5114C148.051 68.8722 148.868 68.5526 149.862 68.5526C150.871 68.5526 151.688 68.8722 152.313 69.5114C152.952 70.1364 153.271 70.9389 153.271 71.919C153.271 72.8849 152.952 73.6875 152.313 74.3267C151.688 74.9659 150.871 75.2855 149.862 75.2855ZM149.862 59.3054C148.868 59.3054 148.051 58.9929 147.412 58.3679C146.773 57.7287 146.453 56.9261 146.453 55.9602C146.453 54.9801 146.773 54.1776 147.412 53.5526C148.051 52.9134 148.868 52.5937 149.862 52.5937C150.871 52.5937 151.688 52.9134 152.313 53.5526C152.952 54.1776 153.271 54.9801 153.271 55.9602C153.271 56.9261 152.952 57.7287 152.313 58.3679C151.688 58.9929 150.871 59.3054 149.862 59.3054Z"/>\n    <path d="M167.195 78.5455V53.3395H166.833L159.183 58.7088V53.4247L167.216 47.7997H172.692V78.5455H167.195Z"/>\n    <path d="M188 64.9091V60.6477H191.75C193.313 60.6477 194.584 60.2216 195.564 59.3693C196.544 58.5028 197.034 57.3807 197.034 56.0028C197.034 54.6392 196.551 53.5526 195.586 52.7429C194.634 51.919 193.355 51.5071 191.75 51.5071C190.159 51.5071 188.867 51.9261 187.872 52.7642C186.892 53.6023 186.353 54.7457 186.253 56.1946H181.118C181.26 53.3679 182.297 51.1378 184.229 49.5043C186.161 47.8565 188.725 47.0327 191.921 47.0327C194.904 47.0327 197.382 47.8139 199.357 49.3764C201.346 50.9247 202.34 52.8778 202.34 55.2358C202.34 57.0398 201.836 58.581 200.827 59.8594C199.833 61.1378 198.483 61.9545 196.779 62.3097V62.6719C198.881 62.9134 200.536 63.7017 201.743 65.0369C202.965 66.3722 203.576 68.0625 203.576 70.108C203.576 72.75 202.468 74.9446 200.252 76.6918C198.05 78.4389 195.28 79.3125 191.942 79.3125C188.632 79.3125 185.934 78.4673 183.846 76.777C181.772 75.0866 180.664 72.8352 180.522 70.0227H185.784C185.898 71.4432 186.516 72.5795 187.638 73.4318C188.76 74.2699 190.209 74.6889 191.985 74.6889C193.746 74.6889 195.181 74.2344 196.289 73.3253C197.411 72.402 197.972 71.2159 197.972 69.767C197.972 68.2614 197.425 67.0753 196.331 66.2088C195.238 65.3423 193.746 64.9091 191.857 64.9091H188Z"/>\n  </g>\n</svg>',"",'<svg viewBox="0 0 66.61 12.86">\n  <g transform="scale(0.34) translate(-826.18, -43.64)" fill="currentColor">\n    <path d="M826.182 68.8112C826.182 67.2663 827.434 66.014 828.979 66.014H831.776C833.321 66.014 834.573 67.2663 834.573 68.8112V74.4056C834.573 75.9505 833.321 77.2028 831.776 77.2028H828.979C827.434 77.2028 826.182 75.9505 826.182 74.4056V68.8112Z"/>\n    <path d="M840.168 61.8182C840.168 60.2733 841.42 59.021 842.965 59.021H845.762C847.307 59.021 848.559 60.2733 848.559 61.8182V74.4056C848.559 75.9505 847.307 77.2028 845.762 77.2028H842.965C841.42 77.2028 840.168 75.9505 840.168 74.4056V61.8182Z"/>\n    <path d="M854.154 52.028C854.154 50.4831 855.406 49.2308 856.951 49.2308H859.748C861.293 49.2308 862.545 50.4831 862.545 52.028V74.4056C862.545 75.9505 861.293 77.2028 859.748 77.2028H856.951C855.406 77.2028 854.154 75.9505 854.154 74.4056V52.028Z"/>\n    <path d="M868.14 46.4336C868.14 44.8887 869.392 43.6364 870.937 43.6364H873.734C875.279 43.6364 876.531 44.8887 876.531 46.4336V74.4056C876.531 75.9505 875.279 77.2028 873.734 77.2028H870.937C869.392 77.2028 868.14 75.9505 868.14 74.4056V46.4336Z"/>\n    <path d="M913.959 50.8742C920.859 50.8745 927.494 53.5806 932.495 58.4331C932.871 58.8077 933.473 58.803 933.844 58.4225L937.443 54.7146C937.631 54.5216 937.736 54.2601 937.734 53.9882C937.733 53.7162 937.625 53.456 937.435 53.2653C924.311 40.4267 903.606 40.4267 890.482 53.2653C890.291 53.4559 890.184 53.7159 890.182 53.9879C890.18 54.2599 890.285 54.5214 890.472 54.7146L894.073 58.4225C894.443 58.8035 895.046 58.8083 895.422 58.4331C900.423 53.5802 907.059 50.8742 913.959 50.8742ZM914.059 62.0682C917.849 62.068 921.505 63.5062 924.315 66.1035C924.695 66.4721 925.294 66.4641 925.664 66.0855L929.259 62.3775C929.449 62.1831 929.554 61.9192 929.551 61.645C929.548 61.3709 929.438 61.1093 929.245 60.9187C920.688 52.794 907.436 52.794 898.88 60.9187C898.686 61.1093 898.576 61.371 898.573 61.6453C898.571 61.9195 898.676 62.1833 898.866 62.3775L902.46 66.0855C902.831 66.4641 903.429 66.4721 903.809 66.1035C906.618 63.5079 910.27 62.0698 914.059 62.0682ZM921.369 69.3055C921.375 69.5805 921.269 69.8455 921.077 70.0381L914.858 76.4444C914.675 76.6326 914.427 76.7386 914.168 76.7386C913.908 76.7386 913.66 76.6326 913.477 76.4444L907.257 70.0381C907.065 69.8454 906.96 69.5802 906.965 69.3053C906.971 69.0303 907.088 68.77 907.288 68.5857C911.259 65.1568 917.076 65.1568 921.048 68.5857C921.247 68.7701 921.364 69.0306 921.369 69.3055Z" fill-rule="evenodd"/>\n    <path d="M951.27 55.2766C951.27 48.8499 956.48 43.64 962.907 43.64H1003.63C1010.06 43.64 1015.27 48.8499 1015.27 55.2766V69.8224C1015.27 76.2491 1010.06 81.459 1003.63 81.459H962.907C956.48 81.459 951.27 76.2491 951.27 69.8224V55.2766Z M966.132 72.7316L974.868 56.0124V55.7568H964.527V52.2197H979.186V55.7994L970.621 72.7316H966.132Z M990.824 73.2571C989.337 73.2571 988.011 72.9399 986.847 72.3054C985.691 71.6709 984.763 70.7523 984.062 69.5497C982.917 67.7883 982.344 65.4823 982.344 62.6319C982.344 59.2322 983.101 56.5617 984.616 54.6204C986.132 52.679 988.224 51.7084 990.895 51.7084C992.846 51.7084 994.508 52.234 995.881 53.2851C997.263 54.3363 998.102 55.7189 998.395 57.4329H994.148C993.949 56.7606 993.551 56.2255 992.955 55.8278C992.368 55.43 991.671 55.2312 990.867 55.2312C989.465 55.2312 988.362 55.8609 987.557 57.1204C986.761 58.3704 986.387 60.0608 986.435 62.1916H986.69C987.154 61.2256 987.841 60.4822 988.75 59.9614C989.669 59.4311 990.725 59.1659 991.918 59.1659C993.859 59.1659 995.469 59.8099 996.747 61.0978C998.026 62.3857 998.665 64.0098 998.665 65.97C998.665 68.1008 997.931 69.848 996.463 71.2116C994.995 72.5753 993.116 73.2571 990.824 73.2571ZM988.139 68.6832C988.849 69.3839 989.73 69.7343 990.781 69.7343C991.832 69.7343 992.713 69.3887 993.423 68.6974C994.143 67.9966 994.503 67.1301 994.503 66.0979C994.503 65.0562 994.153 64.1944 993.452 63.5126C992.751 62.8213 991.866 62.4756 990.796 62.4756C989.725 62.4756 988.835 62.8166 988.125 63.4984C987.424 64.1802 987.074 65.0325 987.074 66.0553C987.074 67.097 987.429 67.9729 988.139 68.6832Z" fill-rule="evenodd" fill-opacity="0.4"/>\n    <path d="M951.27 55.2766C951.27 48.8499 956.48 43.64 962.907 43.64H997.816V81.459H962.907C956.48 81.459 951.27 76.2491 951.27 69.8224V55.2766Z M966.132 72.7316L974.868 56.0124V55.7568H964.527V52.2197H979.186V55.7994L970.621 72.7316H966.132Z M990.824 73.2571C989.337 73.2571 988.011 72.9399 986.847 72.3054C985.691 71.6709 984.763 70.7523 984.062 69.5497C982.917 67.7883 982.344 65.4823 982.344 62.6319C982.344 59.2322 983.101 56.5617 984.616 54.6204C986.132 52.679 988.224 51.7084 990.895 51.7084C992.846 51.7084 994.508 52.234 995.881 53.2851C997.263 54.3363 998.102 55.7189 998.395 57.4329H994.148C993.949 56.7606 993.551 56.2255 992.955 55.8278C992.368 55.43 991.671 55.2312 990.867 55.2312C989.465 55.2312 988.362 55.8609 987.557 57.1204C986.761 58.3704 986.387 60.0608 986.435 62.1916H986.69C987.154 61.2256 987.841 60.4822 988.75 59.9614C989.669 59.4311 990.725 59.1659 991.918 59.1659C993.859 59.1659 995.469 59.8099 996.747 61.0978C998.026 62.3857 998.665 64.0098 998.665 65.97C998.665 68.1008 997.931 69.848 996.463 71.2116C994.995 72.5753 993.116 73.2571 990.824 73.2571ZM988.139 68.6832C988.849 69.3839 989.73 69.7343 990.781 69.7343C991.832 69.7343 992.713 69.3887 993.423 68.6974C994.143 67.9966 994.503 67.1301 994.503 66.0979C994.503 65.0562 994.153 64.1944 993.452 63.5126C992.751 62.8213 991.866 62.4756 990.796 62.4756C989.725 62.4756 988.835 62.8166 988.125 63.4984C987.424 64.1802 987.074 65.0325 987.074 66.0553C987.074 67.097 987.429 67.9729 988.139 68.6832Z" fill-rule="evenodd"/>\n    <path d="M1018.18 57.6263V69.4317C1020.56 68.4318 1022.1 66.1059 1022.1 63.529C1022.1 60.9521 1020.56 58.6261 1018.18 57.6263Z" fill-opacity="0.4"/>\n  </g>\n</svg>',42,null)
D.c1d=new B.tZ("",'<svg viewBox="0 0 320 5">\n  <path d="M 2.5,0 H 317.5 A 2.5,2.5 0 0 1 320,2.5 V 2.5 A 2.5,2.5 0 0 1 317.5,5 H 2.5 A 2.5,2.5 0 0 1 0,2.5 V 2.5 A 2.5,2.5 0 0 1 2.5,0 Z" fill="currentColor"/>\n</svg>',"",16,8)
D.c1k=new B.H6(D.c1g,D.c1d,C.aE)
D.bY2=new A.a2(820,1180)
D.Dh=new A.K(0,32,0,25)
D.ap1=new B.LS(1,"tablet")
D.ap6=new B.vr("apple-ipad-air-11-m4",'iPad Air 11" (M4)',"Apple",2026,C.aE,D.aoV,D.c1k,D.bY2,2,D.Dh,D.Dh,337,422,D.ap1)
D.apb=new B.vs(C.ze,D.ap6,!0)
D.bXX=new A.a2(1922,1109)
D.bQV=new A.y(1,28)
D.aoZ=new B.vq(D.bXX,D.bQV,"M 0,0 H 1920 V 1068 A 12,12 0 0 1 1908,1080 H 12 A 12,12 0 0 1 0,1068 Z",'<svg viewBox="0 0 1922 1109">\n  <path d="M 12,0 H 1910 A 12,12 0 0 1 1922,12 V 1097 A 12,12 0 0 1 1910,1109 H 12 A 12,12 0 0 1 0,1097 V 12 A 12,12 0 0 1 12,0 Z" fill="#26282c"/>\n  <circle cx="16" cy="14" r="6" fill="#ff5f57"/>\n  <circle cx="36" cy="14" r="6" fill="#febc2e"/>\n  <circle cx="56" cy="14" r="6" fill="#28c840"/>\n  <rect x="891" y="9" width="140" height="10" rx="5" fill="#c9ccd1" fill-opacity="0.35"/>\n</svg>')
D.bXW=new A.a2(1920,1080)
D.zi=new B.LS(3,"desktop")
D.ap5=new B.vr("desktop-large","Large Desktop Window","Generic",null,C.fH,D.aoZ,null,D.bXW,2,C.R,null,null,null,D.zi)
D.ap9=new B.vs(C.k8,D.ap5,!1)
D.bXU=new A.a2(1026,673)
D.bQW=new A.y(1,32)
D.aoW=new B.vq(D.bXU,D.bQW,"M 0,0 H 1024 V 632 A 8,8 0 0 1 1016,640 H 8 A 8,8 0 0 1 0,632 Z",'<svg viewBox="0 0 1026 673">\n  <path d="M 8,0 H 1018 A 8,8 0 0 1 1026,8 V 665 A 8,8 0 0 1 1018,673 H 8 A 8,8 0 0 1 0,665 V 8 A 8,8 0 0 1 8,0 Z" fill="#202226"/>\n  <rect x="980" y="15" width="10" height="2" fill="#c9ccd1"/>\n  <rect x="994" y="15" width="10" height="2" fill="#c9ccd1"/>\n  <rect x="1008" y="15" width="10" height="2" fill="#c9ccd1"/>\n  <rect x="443" y="11" width="140" height="10" rx="5" fill="#c9ccd1" fill-opacity="0.35"/>\n</svg>')
D.bXT=new A.a2(1024,640)
D.ap4=new B.vr("desktop-small","Small Desktop Window","Generic",null,C.vB,D.aoW,null,D.bXT,1,C.R,null,null,null,D.zi)
D.ap8=new B.vs(C.zf,D.ap4,!1)
D.kH=x([D.apa,D.ap7,D.apb,D.ap9,D.ap8],A.e("f<vs>"))
D.bQr={black:0,white:1,gray:2,grey:3,silver:4,red:5,green:6,blue:7,yellow:8,orange:9,navy:10}
D.xP=new A.ad(1,0.5019607843137255,0.5019607843137255,0.5019607843137255,C.M)
D.a3f=new A.ad(1,0.7529411764705882,0.7529411764705882,0.7529411764705882,C.M)
D.a34=new A.ad(1,0,0.5019607843137255,0,C.M)
D.a3t=new A.ad(1,1,0.6470588235294118,0,C.M)
D.a3W=new A.ad(1,0,0,0.5019607843137255,C.M)
D.bOz=new A.bE(D.bQr,[C.cm,C.aN,D.xP,D.xP,D.a3f,E.pJ,D.a34,E.xN,E.xQ,D.a3t,D.a3W],A.e("bE<q,ad>"))
D.bPn=new A.Fe(C.ac,1,C.pv,C.bU,C.R,C.R,C.R,C.R,!1,!1,!1,!1,!1,!1,!1,!1,C.kW,C.zg,C.tF,!1,null,null,null,null,null)
D.bQN={g:0,a:1,svg:2,switch:3}
D.bWg=new A.fg(D.bQN,4,y.M)
D.bQj={defs:0,clipPath:1,mask:2,title:3,desc:4,metadata:5,style:6,symbol:7,linearGradient:8,radialGradient:9,filter:10}
D.bWs=new A.fg(D.bQj,11,y.M)})();(function lazyInitializers(){var x=a.lazyFinal
x($,"chw","bO4",()=>A.a9("[-+]?(\\d*\\.\\d+|\\d+\\.?)([eE][-+]?\\d+)?",!0,!1,!1,!1))
x($,"ci5","bOr",()=>A.a9("url\\(\\s*#([^)\\s]+)\\s*\\)",!0,!1,!1,!1))
x($,"chB","bO5",()=>A.a9("rgba?\\(([^)]*)\\)",!0,!1,!1,!1))
x($,"ci3","bOp",()=>A.a9("(\\w+)\\s*\\(([^)]*)\\)",!0,!1,!1,!1))
x($,"cgG","bNw",()=>A.a9("&([a-zA-Z]+|#[xX]?[0-9a-fA-F]+);",!0,!1,!1,!1))})()};
(a=>{a["5ZU3bBALJgNqkQNMda0dprk5X/s="]=a.current})($__dart_deferred_initializers__);