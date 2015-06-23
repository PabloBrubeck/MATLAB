function J = quadrature2d(f, x, y, t, w)
% Integrates f over the 2D region bounded by the functions x, y(x)
% using a standard quadrature rule for the [-1, 1] interval.
n=length(t);
grid=zeros(3,n*n);
x0=(x(2)+x(1))/2;
dx=(x(2)-x(1))/2;
for i=1:n
    xi=x0+dx*t(i);
    lim=y(xi); a=lim(1); b=lim(2);
    y0=(b+a)/2;
    dy=(b-a)/2;
    dA=w(i)*dx*dy;
    grid( 1, (i-1)*n+1:i*n)=xi;
    grid(2:3,(i-1)*n+1:i*n)=[y0+dy*t; w*dA];
end
J=f(grid(1,:),grid(2,:))*grid(3,:).';
end