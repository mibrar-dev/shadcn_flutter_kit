((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var B,C,A={ati:function ati(){},aGU:function aGU(d,e){this.a=d
this.b=e},OY:function OY(d){this.a=d},OZ:function OZ(d){this.a=null
this.b=d},P_:function P_(d,e){this.c=d
this.a=e},akG:function akG(d){this.d=d
this.c=this.a=null},FC:function FC(d,e,f){this.e=d
this.c=e
this.a=f},a8m:function a8m(d,e,f,g,h){var _=this
_.C=d
_.a2=e
_.J$=f
_.dy=g
_.b=_.fy=null
_.c=0
_.y=_.d=null
_.z=!0
_.Q=null
_.as=!1
_.at=null
_.ay=$
_.ch=h
_.CW=!1
_.cx=$
_.cy=!0
_.db=!1
_.dx=$},ajO:function ajO(d,e,f){var _=this
_.a=d
_.b=e
_.id$=0
_.k1$=f
_.k3$=_.k2$=0},
bPb(){return new A.yo(null)},
yo:function yo(d){this.a=d},
ae9:function ae9(){this.d="tap a row"
this.c=this.a=null},
aVB:function aVB(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
aVz:function aVz(d,e){this.a=d
this.b=e},
aVy:function aVy(d,e,f){this.a=d
this.b=e
this.c=f},
aVA:function aVA(d){this.a=d}}
B=c[0]
C=c[2]
A=a.updateHolder(c[28],A)
A.ati.prototype={}
A.aGU.prototype={}
A.OY.prototype={}
A.OZ.prototype={
a3p(d){var x=this.b.k(0,d)
if(x==null){x=this.a
x=x==null?null:x.a3p(d)}return x}}
A.P_.prototype={
t(){return new A.akG(new A.OZ(B.H(y.o,y.l)))}}
A.akG.prototype={
aV(){this.bg()
var x=this.c
x.toString
this.d.a=B.bI(x,y.h)},
j(d){return new B.bg(this.d,this.a.c,null,y.j)}}
A.FC.prototype={
aJ(d){var x=B.jd(d,y.h)
x.toString
x=new A.a8m(this.e,x,null,new B.bw(),B.aU())
x.aH()
x.sb1(null)
return x},
aO(d,e){var x,w=this.e,v=B.jd(d,y.h)
v.toString
x=e.C
if(x!==w||e.a2!==v){e.a2.b.I(0,x)
e.C=w
e.a2=v
if(e.y!=null)v.b.n(0,w,new A.OY(e))}}}
A.a8m.prototype={
av(d){var x=this
x.oT(d)
x.a2.b.n(0,x.C,new A.OY(x))},
ak(){this.a2.b.I(0,this.C)
this.mi()}}
A.ajO.prototype={
ga2w(){var x=this.b.a3p(this.a),w=x==null?null:x.a
return w!=null&&w.y!=null?w:null}}
A.yo.prototype={
t(){return new A.ae9()}}
A.ae9.prototype={
auD(d,e){var x,w=B.jd(d,y.h),v=new A.aGU("row-anchor",w),u=v.b
u.toString
w=$.a4()
x=new A.ajO(v.a,u,w)
this.p(new A.aVB(this,x.ga2w(),e,x))
x.k1$=w
x.id$=0},
j(d){return B.hv(this.auC(d),C.t)},
auC(d){var x,w,v=null,u=B.h(d),t=B.a([B.j(this.d,v,v,v,v,v,v,v,v,v,v,v,v,v),new B.A(v,B.h(d).w.a*3,v,v)],y.e)
for(x=["first","second"],w=0;w<2;++w)t.push(new B.I(C.fl,new A.P_(new B.av(new A.aVz(this,x[w]),v),v),v))
t.push(new B.A(v,B.h(d).w.a*3,v,v))
t.push(new B.av(new A.aVA(this),v))
return B.bl(new B.I(C.cg,B.u(t,C.o,C.c,C.i,0,C.h),v),u.a.b,!0)}}
var z=a.updateTypes(["FC(k)"])
A.aVB.prototype={
$0(){var x=this,w=x.b,v=x.c
w=w==null?v+": no anchor":v+": "+C.f.a7(w.gA().a,0)+"x"+C.f.a7(w.gA().b,0)+" visible="+(x.d.ga2w()!=null)+" tracking=true"
x.a.d=w},
$S:0}
A.aVz.prototype={
$1(d){var x=null,w=this.b
return new A.FC("row-anchor",B.T(!1,B.j(w+" row",x,x,x,x,x,x,x,x,x,x,x,x,x),x,x,x,x,x,x,x,new A.aVy(this.a,d,w),x,x,C.D,x,x,x,x,C.A),x)},
$S:z+0}
A.aVy.prototype={
$0(){return this.a.auD(this.b,this.c)},
$S:0}
A.aVA.prototype={
$1(d){var x=null,w=B.h(d)
return B.bl(new B.I(C.ex,B.j("dark tokens / "+this.a.d,x,x,x,x,x,x,x,x,x,x,x,x,x),x),w.a.b,!0)},
$S:87};(function inheritance(){var x=a.inheritMany,w=a.inherit
x(B.J,[A.ati,A.OY,A.OZ])
w(A.aGU,A.ati)
x(B.r,[A.P_,A.yo])
x(B.t,[A.akG,A.ae9])
w(A.FC,B.bq)
w(A.a8m,B.ol)
w(A.ajO,B.ew)
x(B.aA,[A.aVB,A.aVy])
x(B.ap,[A.aVz,A.aVA])})()
B.ag(b.typeUniverse,JSON.parse('{"P_":{"r":[],"b":[]},"FC":{"bq":[],"b_":[],"b":[]},"akG":{"t":["P_"]},"a8m":{"S":[],"bA":["S"],"R":[],"aZ":[]},"ajO":{"as":[]},"yo":{"r":[],"b":[]},"ae9":{"t":["yo"]}}'))
var y={j:B.e("bg<OZ>"),e:B.e("f<b>"),o:B.e("J"),l:B.e("OY"),h:B.e("OZ")}};
(a=>{a["DUazlHrq+KKxQhCSspfV/xST16A="]=a.current})($__dart_deferred_initializers__);