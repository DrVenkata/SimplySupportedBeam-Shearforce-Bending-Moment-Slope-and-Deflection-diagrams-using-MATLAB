clear all;
clc;
E=input('Youngs Modulus or Modulus of elasticity in Pascals \n E=')
I=input('Area moment of inertia in m^4\n I=')
L=input('Length of beam in meters \n L=')
W=input('Intensity of point load W in Newton \n W=')
a=input('Location of Point load from Extreme Left side of Beam in meters \n a=')
b=L-a;
Ra=(W*(L-a))/L;
Rb=(W*(a))/L;
syms x Dy(x) M1(x) M2(x)  deflection1(x) deflection2(x);
syms C2 C3 C4 C5 slope_a;
syms slope(x) slope1(x) slope2(x); 
M2(x)=(Ra*x)-(W*(x-a));
M1(x)=Ra*x;
SF1(x)=diff(M1(x),x);
SF2(x)=diff(M2(x),x);
format long;
%first section
deflection1(x,C2,C3)=((int(int(M1(x),x),x))+(C2*x)+C3)/(E*I);
D1y(x,C2,C3)=diff(deflection1,x);
eq2 =deflection1(0,C2,C3) == 0;
eq3 =D1y(a,C2,C3) == slope_a;
C3=eval(vpasolve(eq2,C3));
C2=eval(vpasolve(eq3,C2));
deflection1(x,slope_a)=deflection1(x,C2,C3);
%second section
deflection2(x,C4,C5)=((int(int(M2,x),x))+(C4*x)+C5)/(E*I);
D2y(x,C4,C5)=diff(deflection2,x);
eq2=D2y(a,C4,C5)==slope_a;
eq3=deflection2(L,C4,C5)==0;
C4=eval(vpasolve(eq2,C4));
C5=eval(vpasolve(eq3,C5));
deflection2(x,slope_a)=deflection2(x,C4,C5);
% Evaluating slope at load point slope_a
eq=deflection1(a,slope_a)==deflection2(a,slope_a);
slope_a=eval(vpasolve(eq,slope_a));
% deflection and slope equations for section-1 and section-2
deflection1(x)=deflection1(x,slope_a);
deflection2(x)=deflection2(x,slope_a);
slope1(x)=diff(deflection1(x),x);
slope2(x)=diff(deflection2(x),x);
deflection=zeros((L/0.1)+1,1);
BM=zeros((L/0.1)+1,1)
SF=zeros((L/0.1)+1,1)
slope=zeros((L/0.1)+1,1)
i=0;
for X=0:0.1:L
    if X<=a
        deflection(i+1)=deflection(i+1)+deflection1(X);
        BM(i+1)=BM(i+1)+M1(X)
        SF(i+1)=SF(i+1)+SF1(X)
        slope(i+1)=slope(i+1)+slope1(X)
    elseif X>=a && X<=L
        deflection(i+1)=deflection(i+1)+deflection2(X);
        BM(i+1)=BM(i+1)+M2(X);
        SF(i+1)=SF(i+1)+SF2(X);
        slope(i+1)=slope(i+1)+slope2(X)
    end
    i=i+1;
end
X=0:0.1:L;
% Plotting Shearforce Diagram
figure
area(X,double(SF))
ylabel('Shear Force in N');
xlabel('Location on beam from extreme left along length in m');
figure
area(X,double(BM))
ylabel('Bending Moment in N-m');
xlabel('Location on beam from extreme left along length in m');
figure
area(X,double(slope))
ylabel('Slope of bend curvature of beam');
xlabel('Location on beam from extreme left along length in m');
figure
plot(X,double(deflection))
ylabel('Deflection in m');
xlabel('Location on beam from extreme left along length in m');

if a>b
    Def_max_loc=vpasolve(diff(deflection1(x),x)==0,x,[0,a]);
    Def_max_loc=eval(Def_max_loc);
    max_def=double(deflection1(Def_max_loc))*1000;
elseif a<b
    Def_max_loc=vpasolve(diff(deflection2(x),x)==0,x,[a,L]);
    Def_max_loc=eval(Def_max_loc);
    max_def=double(deflection2(Def_max_loc))*1000;
elseif a==b
    Def_max_loc=L/2;
    max_def=double(deflection1(Def_max_loc))*1000;
end
fprintf('Maximum deflection is at %f feom extreme left side of beam \n',Def_max_loc)