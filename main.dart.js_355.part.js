((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var A,C,E,B={DG:function DG(d,e,f){this.d=d
this.e=e
this.a=f},awH:function awH(){},na:function na(d,e,f,g,h,i,j,k){var _=this
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.a=i
_.b=j
_.c=k},
bYi(d){return D.W5},
bYj(d){return D.W4},
bYk(d){return D.cir},
TQ:function TQ(d,e,f){this.c=d
this.d=e
this.a=f},
TR:function TR(d){this.a=d},
afG:function afG(){this.d="idle"
this.c=this.a=null},
b_I:function b_I(d){this.a=d},
b_H:function b_H(d){this.a=d},
b_J:function b_J(d){this.a=d},
b_G:function b_G(d){this.a=d},
cef(d){var x,w,v,u,t=C.d.m5(d),s=A.a9("^(?:```+|~~~+)\\s*([A-Za-z][\\w+-]*)",!0,!1,!1,!1).fG(t)
if(s!=null){x=A.ast(s.b[1])
if(x!=null)return x}w=A.a9("^import\\s+['\"]package:flutter/",!0,!1,!1,!1)
v=!0
if(!w.b.test(t)){w=A.a9("^import\\s+['\"]dart:",!0,!1,!1,!1)
if(!w.b.test(t)){w=A.a9("^\\s*void\\s+main\\s*\\(",!0,!1,!0,!1)
w=w.b.test(t)}else w=v}else w=v
if(w)return C.lk
w=A.a9("^#!\\S*\\b(?:ba)?sh\\b|^#!\\S*\\bzsh\\b",!0,!1,!1,!1)
if(w.b.test(t))return C.ll
w=A.a9("^<!DOCTYPE html|^<html[\\s>]",!1,!1,!1,!1)
if(w.b.test(t))return C.vw
w=A.a9("^<\\?xml",!0,!1,!1,!1)
if(w.b.test(t))return C.vw
w=A.a9("^import\\s+(?:UIKit|Foundation|SwiftUI)\\b",!0,!1,!1,!1)
if(w.b.test(t))return C.Sc
w=A.a9("^\\s*def\\s+\\w+\\s*\\([^)]*\\)\\s*:",!0,!1,!1,!1)
if(!w.b.test(t)){w=A.a9("^\\s*(?:async\\s+)?def\\s+\\w+\\s*\\(.*\\)\\s*(?:->\\s*\\w+\\s*)?:",!0,!1,!1,!1)
w=w.b.test(t)}else w=!0
if(w)return C.Sg
w=A.a9("^\\s*(?:pub\\s+)?(?:fun|val|var)\\s+\\w+",!0,!1,!1,!1)
if(w.b.test(t)&&C.d.v(t,A.a9("\\b(?:Unit|Int|String|Boolean)\\b",!0,!1,!1,!1)))return C.Sb
w=A.a9("^\\s*(?:const|let|var|function)\\s+\\w+",!0,!1,!1,!1)
v=!0
if(!w.b.test(t)){w=A.a9("=>",!0,!1,!1,!1)
if(!w.b.test(t)){w=A.a9("^\\s*console\\.log\\(",!0,!1,!0,!1)
w=w.b.test(t)}else w=v}else w=v
if(w)return C.vv
u=C.d.au(t)
if(u.length===0)return null
if(C.d.ac(u,"{")||C.d.ac(u,"[")){w=A.a9('^[\\s{}\\[\\]",:0-9aeflnrtyA-FLNR\\.\\-+]*$',!0,!1,!1,!1)
w=w.b.test(u)}else w=!1
if(w)return C.Sh
return null}},D,F
A=c[0]
C=c[2]
E=c[165]
B=a.updateHolder(c[46],B)
D=c[309]
F=c[217]
B.DG.prototype={
j(d){var x,w,v,u,t,s=this,r=null,q=A.h(d),p=y.j,o=A.aF(d,D.a2g,new B.awH(),r,p,p),n=q.f
p=q.a
x=o.d.G(p)
w=o.e.G(p)
w=A.aT(w,C.y,o.f*n)
v=A.ab(q.b.a*16)
u=q.r
t=A.cg(o.w,u.a*n)
p=A.aK(r,r,p.c,r,r,r,r,r,r,r,r,r,r,r,r,r,r,!0,r,r,r,r,r,r,r,r)
p=A.a([A.aq(r,A.b3(A.b3(A.d7(A.wn(d,!1)==null?s.SY(q):A.aO8(s.SY(q),r,r,new A.h4()),r,r,r,p,r,r),r,t,r,r,C.B),r,r,r,r,C.u),C.n,r,r,r,r,r,r,r,r,r,r,r)],y.e)
if(s.d.length!==0){t=d.Z(y.o).w
u=u.b*n
p.push(A.bA7(r,A.M(s.aym(n),C.m,r,C.c,C.i,0,r),u,r,t,u,r))}return A.aq(r,A.cd(C.a2,p,C.T,C.dO),C.n,r,r,new A.a1(x,r,w,v,r,r,r,C.q),r,r,r,r,r,r,r,r)},
aym(d){var x,w,v,u=A.a([],y.e)
for(x=this.d,w=4*d,v=0;v<x.length;++v){if(v>0)u.push(new A.c4(w,null,null))
u.push(x[v])}return u},
SY(d){var x,w,v,u=null,t=this.e,s=t.c
if(s==null){x=t.d
s=x==null?u:x.Ox()}if(s==null)return A.il(E.aSH(t))
w=A.ast(u)
if(w==null)w=B.cef(s)
if(w==null)return A.il(E.aSH(t))
v=d.d.b.R(d.a.c)
return A.il(E.aSH(A.lq(A.bN(A.CL(v,s,d.gmj(),w),u,u,u,u,u,u,u,u,v,u),u,u,u,u,u,u,u,u,u)))}}
B.na.prototype={
F(d){var x=this
return new B.na(x.d,x.e,x.f,d.r,x.w,d.a,d.b,d.c)},
h(d,e){var x,w=this
if(e==null)return!1
if(w===e)return!0
x=!1
if(e instanceof B.na)if(e.d.h(0,w.d))if(e.e.h(0,w.e))if(e.f===w.f)x=e.w.h(0,w.w)
return x},
gq(d){var x=this
return A.P(x.a,x.b,x.c,x.d,x.e,x.f,x.r,x.w,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a)}}
B.TQ.prototype={
j(d){var x=null
return A.T(!1,A.j(this.c,x,x,x,x,x,x,x,x,x,x,x,x,x),x,x,x,x,x,x,x,this.d,x,x,C.r,x,x,x,x,C.S)}}
B.TR.prototype={
t(){return new B.afG()}}
B.afG.prototype={
j(d){var x=null,w=A.h(d),v=y.e
return A.u(A.a([new B.DG(A.a([new B.TQ("Copy",new B.b_I(this),x),new B.TQ("Run",new B.b_J(this),x)],v),D.c5O,x),A.p(w.w.a*2),A.j(this.d,x,x,x,x,x,x,x,x,A.aK(x,x,A.h(d).a.as,x,x,x,x,x,x,x,x,12,x,x,x,x,x,!0,x,x,x,x,x,x,x,x),x,x,x,x)],v),C.o,C.c,C.i,0,C.h)}}
var z=a.updateTypes(["b(k)","na(na)"])
B.awH.prototype={
$1(d){return d},
$S:z+1}
B.b_I.prototype={
$0(){var x=this.a
return x.p(new B.b_H(x))},
$S:0}
B.b_H.prototype={
$0(){return this.a.d="copied"},
$S:0}
B.b_J.prototype={
$0(){var x=this.a
return x.p(new B.b_G(x))},
$S:0}
B.b_G.prototype={
$0(){return this.a.d="running"},
$S:0};(function installTearOffs(){var x=a._static_1
x(B,"caa","bYi",0)
x(B,"cab","bYj",0)
x(B,"cac","bYk",0)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.i,[B.DG,B.TQ])
w(B.awH,A.ap)
w(B.na,A.ao)
w(B.TR,A.r)
w(B.afG,A.t)
x(A.aA,[B.b_I,B.b_H,B.b_J,B.b_G])})()
A.ag(b.typeUniverse,JSON.parse('{"DG":{"i":[],"b":[]},"na":{"ao":[]},"TR":{"r":[],"b":[]},"TQ":{"i":[],"b":[]},"afG":{"t":["TR"]}}'))
var y={j:A.e("na"),o:A.e("dC"),e:A.e("f<b>")};(function constants(){var x=a.makeConstList
D.c82=new A.o('void main() { runApp(const MyApp(home: Center(child: Text("wide")))); }',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a2h=new B.DG(C.b0,D.c82,null)
D.bYu=new A.A(320,null,D.a2h,null)
D.W4=new A.bc(C.C,null,null,D.bYu,null)
D.c6k=new A.o('const greeting = "hello";',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.a2i=new B.DG(C.b0,D.c6k,null)
D.W5=new A.bc(C.C,null,null,D.a2i,null)
D.a7D=new F.z(B.caa())
D.a7F=new F.z(B.cac())
D.a7E=new F.z(B.cab())
D.bLp=x([D.a7D,D.a7F,D.a7E],A.e("f<z>"))
D.Za=D.bLp
D.bhp=new A.ef(1,1,3.5,1)
D.a2g=new B.na(C.dJ,C.aD,1,null,D.bhp,null,null,null)
D.c5O=new A.o("flutter run -d chrome",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.cir=new B.TR(null)})()};
(a=>{a["TjjvghfFOjVbVP3Q3yY7T1salDs="]=a.current})($__dart_deferred_initializers__);