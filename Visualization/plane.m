function []=plane(pointA,pointB,pointC)
normal = cross(pointA-pointB, pointA-pointC); %# Calculate plane normal
%# Transform points to x,y,z
x = [pointA(1) pointB(1) pointC(1)];  
y = [pointA(2) pointB(2) pointC(2)];
z = [pointA(3) pointB(3) pointC(3)];

%Find all coefficients of plane equation    
A = normal(1); B = normal(2); C = normal(3);
D = -dot(normal,pointA);
%Decide on a suitable showing range
xLim = [min(x) max(x)];
zLim = [min(z) max(z)];
[X,Z] = meshgrid(xLim,zLim);
Y = (A * X + C * Z + D)/ (-B);
reOrder = [1 2  4 3];
figure();patch(X(reOrder),Y(reOrder),Z(reOrder),'b');
grid on;
alpha(0.3);