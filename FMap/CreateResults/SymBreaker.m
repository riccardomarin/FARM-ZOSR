function landmarks = SymBreaker(landmarks_actual, Joints_Target, KT,print)
%for fl=1:size(list,1)
syms d a b c x y z
landmarks=landmarks_actual;
%load(['../Results/', list(fl).name]);
%Piano puntato in caviglia con normale verso piede
v1=Joints_Target(12,:)-Joints_Target(9,:);
p1=v1(1)*(x-Joints_Target(9,1))+v1(2)*(y-Joints_Target(9,2))+v1(3)*(z-Joints_Target(9,3));
n1=v1;

%Piano sui tre punti: caviglia, ginocchio, piede
po1=Joints_Target(9,:);
po2=Joints_Target(6,:);
po3=Joints_Target(12,:);
vec1=po1-po2;
vec2=po3-po2;
vec_n=cross(vec1,vec2);
p2=vec_n(1)*(x-Joints_Target(9,1))+vec_n(2)*(y-Joints_Target(9,2))+vec_n(3)*(z-Joints_Target(9,3));
n2=vec_n;


%c � la normale del piano 2, la sommo alla caviglia
%piano sui 3 punti: caviglia, ginocchio + normale 
c = double(fliplr(coeffs(p2)));
po1=Joints_Target(9,:);
po2=Joints_Target(6,:);
po3=Joints_Target(9,:)+c([1,2,3]);
vec1=po1-po2;
vec2=po3-po2;
vec_n=cross(vec1,vec2);
p3=vec_n(1)*(x-Joints_Target(9,1))+vec_n(2)*(y-Joints_Target(9,2))+vec_n(3)*(z-Joints_Target(9,3));
n3=vec_n;

%Piano sulla coscia
po1=Joints_Target(3,:);
po2=Joints_Target(6,:);
po3=po2+c([1,2,3]);
vec1=po1-po2;
vec2=po3-po2;
vec_n=cross(vec1,vec2);
p4=vec_n(1)*(x-Joints_Target(6,1))+vec_n(2)*(y-Joints_Target(6,2))+vec_n(3)*(z-Joints_Target(6,3));
n4=vec_n;

c = double(fliplr(coeffs(p4)));
po1=Joints_Target(3,:);
po2=Joints_Target(6,:);
po3=Joints_Target(3,:)+c([1,2,3]);
vec1=po1-po2;
vec2=po3-po2;
vec_n=cross(vec1,vec2);
p5=vec_n(1)*(x-po1(1))+vec_n(2)*(y-po1(2))+vec_n(3)*(z-po1(3));
n5=vec_n;

c = double(fliplr(coeffs(p5)));
po1=Joints_Target(1,:);
po2=Joints_Target(3,:);
po3=Joints_Target(3,:)+c([1,2,3]);
vec1=po1-po2;
vec2=po3-po2;
vec_n=cross(vec1,vec2);
p6=vec_n(1)*(x-po1(1))+vec_n(2)*(y-po1(2))+vec_n(3)*(z-po1(3));
n6=vec_n;

%plotSkeleton(Joints_Target,KT,'T','b');
p1_explicit=solve(p1,z);
p2_explicit=solve(p2,z);
p3_explicit=solve(p3,z);
p4_explicit=solve(p4,z);
p5_explicit=solve(p5,z);
p6_explicit=solve(p6,z);



%x=Joints_Target(9,1);
%y=Joints_Target(9,2);
%z=Joints_Target(9,3);

%GC=

%ThetaInDegrees = atan2d(norm(cross(u,v)),dot(u,v));
%
c = double(fliplr(coeffs(p2)));
po1=Joints_Target(9,:);
po3=Joints_Target(6,:)+c([1,2,3]);
po2=Joints_Target(6,:);
P=[po1;po2;po3];
T=[1 2 3];
TR = triangulation(T,P);
FN = faceNormal(TR);
N=double(fliplr(coeffs(p3)));
N=N([1,2,3]);
N=N/norm(N);
%trimesh(TR)

po2=Joints_Target(3,:);
po3=Joints_Target(6,:)+c([1,2,3]);
po1=Joints_Target(6,:);
P=[po1;po2;po3];
T=[1 2 3];
TR = triangulation(T,P);
FN2 = faceNormal(TR);
N2=double(fliplr(coeffs(p4)));
N2=N2([1,2,3]);
N2=N/norm(N);




c = double(fliplr(coeffs(p5)));

po2=Joints_Target(3,:);
po3=Joints_Target(3,:)+c([1,2,3]);
po1=Joints_Target(1,:);
P=[po1;po2;po3];
T=[1 2 3];
TR = triangulation(T,P);
FN3 = faceNormal(TR);
N3=double(fliplr(coeffs(p4)));
N3=N3([1,2,3]);
N3=N/norm(N); 

%c = double(fliplr(coeffs(p2)))


FN=FN/10;
FN2=FN2/10;
FN3=FN3/10;


if nargin==4
 %scatter3(Joints_Target(9,1)+n1(1),Joints_Target(9,2)+n1(2),Joints_Target(9,3)+n1(1),'filled');

FS=n1/norm(n1)/10
  subplot(2,4,[1 5])
  plotSkeleton(Joints_Target,KT,'','b');
  span=[Joints_Target(9,1)-0.1 Joints_Target(9,1)+0.1 Joints_Target(9,2)-0.1 Joints_Target(9,2)+0.1];
  fsurf(p1_explicit,span,'FaceAlpha',0.5)
  quiver3(Joints_Target(9,1),Joints_Target(9,2),Joints_Target(9,3),FS(1),FS(2),FS(3),1,'LineWidth',2)
  

subplot(2,4,[2 6])
 plotSkeleton(Joints_Target,KT,'','b');
 span=[Joints_Target(6,1)-0.1 Joints_Target(6,1)+0.1 Joints_Target(6,2)-0.1 Joints_Target(6,2)+0.1];
 fsurf(p3_explicit,span,'FaceAlpha',0.5)
 quiver3(Joints_Target(6,1),Joints_Target(6,2),Joints_Target(6,3),FN(1),FN(2),FN(3),2,'LineWidth',2)

subplot(2,4,[3 7])
 plotSkeleton(Joints_Target,KT,'','b');
 span=[Joints_Target(6,1)-0.05 Joints_Target(6,1)+0.05 Joints_Target(6,2)-0.1 Joints_Target(6,2)+0.1];
 fsurf(p4_explicit,span,'FaceAlpha',0.5)
 quiver3(Joints_Target(6,1),Joints_Target(6,2),Joints_Target(6,3),FN2(1),FN2(2),FN2(3),2,'LineWidth',2)
subplot(2,4,[4 8])
 %figure;
 plotSkeleton(Joints_Target,KT,'','b');
 span=[Joints_Target(3,1)-0.05 Joints_Target(3,1)+0.05 Joints_Target(3,2)-0.05 Joints_Target(3,2)+0.05];
 fsurf(p6_explicit,span,'FaceAlpha',0.5)
 quiver3(Joints_Target(3,1),Joints_Target(3,2),Joints_Target(3,3),FN3(1),FN3(2),FN3(3),2,'LineWidth',2)
 quiver3(Joints_Target(10,1),Joints_Target(10,2),Joints_Target(10,3),FN3(1),FN3(2),FN3(3),2,'LineWidth',2)
%  
%  figure;
%  plotSkeleton(Joints_Target,KT,'T','b');
%  span=[Joints_Target(6,1)-0.05 Joints_Target(6,1)+0.05 Joints_Target(6,2)-0.05 Joints_Target(6,2)+0.05];
%  fsurf(p5_explicit,span,'FaceAlpha',0.5)
%  quiver3(Joints_Target(6,1),Joints_Target(6,2),Joints_Target(6,3),n5(1),n5(2),n5(3),8,'LineWidth',2)
%  plotSkeleton(Joints_Target,KT,'T','b');
%  span=[Joints_Target(9,1)-0.1 Joints_Target(9,1)+0.1 Joints_Target(9,2)-0.1 Joints_Target(9,2)+0.1];
%  fsurf(p2_explicit,span,'FaceAlpha',0.5)
%  quiver3(Joints_Target(9,1),Joints_Target(9,2),Joints_Target(9,3),n2(1),n2(2),n2(3),2,'LineWidth',2)


end


%figure();
% plotSkeleton(Joints_Target,KT,'T','b');
% scatter3(Joints_Target(3,1)+FN2(1),Joints_Target(3,2)+FN2(2), Joints_Target(3,3)+FN2(3));
% scatter3(Joints_Target(6,1)+FN(1),Joints_Target(6,2)+FN(2), Joints_Target(6,3)+FN(3));
% scatter3(Joints_Target(1,1)+FN3(1),Joints_Target(1,2)+FN3(2), Joints_Target(1,3)+FN3(3));


top=Joints_Target(4,:);

%Mi porto in un sistema di riferimento comodo (chest => origine)
% z => vettore da chest a top
% y => normale che parte da chest
% manca solo un asse, che andiamo a trovare
origin=Joints_Target(1,:)-Joints_Target(1,:);
z=top-Joints_Target(1,:);
y=FN3;

%ho due vettori che vorrò classificare per il mio nuovo sistema di
%riferimento
uno=Joints_Target(2,:)-Joints_Target(1,:);
due=Joints_Target(3,:)-Joints_Target(1,:);

ax_y=origin-y;
ax_z=origin-z;

ax_x=cross(ax_y,ax_z);
ax_x=ax_x/norm(ax_x);
ax_y=ax_y/norm(ax_y);
ax_z=ax_z/norm(ax_z);
uno=uno/norm(uno);
due=due/norm(due);

if(norm(ax_x-uno)>norm(ax_x-due))
   %risultato="Sx"
   dx=Joints_Target(3,:);
else
    %risultato="Dx"
   dx=Joints_Target(2,:);
   landmarks(3)=landmarks_actual(4);
   landmarks(4)=landmarks_actual(3);
end

%plotSkeleton(Joints_Target,KT,' ','b');
%scatter3(dx(1),dx(2),dx(3));

%BRACCIA
syms d a b c x y z;
po1=Joints_Target(16,:);
po2=Joints_Target(13,:);
po3=Joints_Target(10,:);
vec1=po1-po2;
vec2=po3-po2;
vec_n=cross(vec1,vec2);
p2=vec_n(1)*(x-Joints_Target(16,1))+vec_n(2)*(y-Joints_Target(16,2))+vec_n(3)*(z-Joints_Target(16,3));
p2_explicit=solve(p2,z);


c = double(fliplr(coeffs(p2)));
po1=Joints_Target(10,:);
po2=Joints_Target(13,:);
po3=Joints_Target(10,:)+c([1,2,3]);
vec1=po1-po2;
vec2=po3-po2;
vec_n=cross(vec1,vec2);
p3=vec_n(1)*(x-Joints_Target(10,1))+vec_n(2)*(y-Joints_Target(10,2))+vec_n(3)*(z-Joints_Target(10,3));
p3_explicit=solve(p3,z);
%plotSkeleton(Joints_Target,KT,' ','b');
%fsurf(p3_explicit)

c = double(fliplr(coeffs(p2)));

po1=Joints_Target(13,:);
po2=Joints_Target(10,:);
po3=Joints_Target(10,:)+c([1,2,3]);
P=[po1;po2;po3];
T=[1 2 3];
TR = triangulation(T,P);
FN = faceNormal(TR);




top=Joints_Target(13,:);


%Mi porto in un sistema di riferimento comodo (chest => origine)
% z => vettore da chest a top
% y => normale che parte da chest
% manca solo un asse, che andiamo a trovare
origin=Joints_Target(10,:)-Joints_Target(10,:);
z=top-Joints_Target(10,:);
y=FN3; %<---- QUI
%scatter3(Joints_Target(10,1)+y(1)/10,Joints_Target(10,2)+y(2)/10,Joints_Target(10,3)+y(3)/10);
%ho due vettori che vorrò classificare per il mio nuovo sistema di
%riferimento
uno=Joints_Target(14,:)-Joints_Target(10,:);
due=Joints_Target(15,:)-Joints_Target(10,:);

ax_y=origin-y;
ax_z=origin-z;

ax_x=cross(ax_y,ax_z);
ax_x=ax_x/norm(ax_x);
ax_y=ax_y/norm(ax_y);
ax_z=ax_z/norm(ax_z);
uno=uno/norm(uno);
due=due/norm(due);

if(norm(ax_x-uno)>norm(ax_x-due))
   %risultato="Sx"
   dx=Joints_Target(15,:);
else
    %risultato="Dx"
   dx=Joints_Target(14,:);
   landmarks(2)=landmarks_actual(5);
   landmarks(5)=landmarks_actual(2);
end
end

