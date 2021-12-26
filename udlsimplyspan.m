%simply supported beam with UDL
clear all;
clc;
E=input('Youngs Modulus or Modulus of elasticity in Pascals \n E=');
I=input('Area moment of inertia in m^4\n I=');
L=input('Length of beam in meters \n L=');
w=input('Intensity of point load w in N/m \n w=');
% Example E=2*(10^11),I=10^-4,w=5000 and L=5
Ra=(w*L/2);
Rb=(w*L)/2;
syms x M(x); 
syms C1 C2 C3; 
syms slope(x); 
M(x)=(Ra*x)-((w*(x)^2)/2);
%first section
format long;
SF(x)=diff(M(x),x);
deflection(x,C2,C3)=((int(int(M(x),x),x))+(C2*x)+C3)/(E*I);
D1y(x,C2,C3)=diff(deflection,x);
eq2 =deflection(0,C2,C3) == 0;
eq3 =deflection(L,C2,C3) == 0;
[aa,bb]= vpasolve([eq2,eq3],[C2,C3]);       
C2=eval(aa);
C3=eval(bb);
deflection(x)=deflection(x,C2,C3);
slope(x)=diff(deflection(x),x);
X=0:0.1:L;
figure
area(X,double(SF(X)))
ylabel('Shear Force in N');
xlabel('Location on beam from extreme left along length in m');
figure
area(X,double(M(X)))
ylabel('Bending Moment in N-m');
xlabel('Location on beam from extreme left along length in m');
figure
area(X,double(slope(X)))
ylabel('Slope of bend curvature of beam');
xlabel('Location on beam from extreme left along length in m');
figure
plot(X,double(deflection(X)))
ylabel('Deflection in m');
xlabel('Location on beam from extreme left along length in m');
% Maximum Bending Moment
BM_max_loc=vpasolve(diff(M(x),x)==0,x,[0,L]);
BM_max_loc=eval(BM_max_loc);
max_BM=double(M(BM_max_loc));
fprintf('Maximum BM is at %f m from extreme left side of beam \n',BM_max_loc);
fprintf('Maximum BM is %f N-m \n',max_BM);
% Maximum deflection
Def_max_loc=vpasolve(diff(deflection(x),x)==0,x,[0,L]);
Def_max_loc=eval(Def_max_loc);
max_def=double(deflection(Def_max_loc));
fprintf('Maximum deflection is at %f m from extreme left side of beam \n',Def_max_loc);
fprintf('Maximum deflection is %f m \n',max_def);
        