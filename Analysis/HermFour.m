function [Z] = HermFour(f, n, m)
[x, w]=GaussHermite(n);
H=zeros(m, n);
H(1,:)=pi^(-1/4)*exp(-x.^2);
H(2,:)=H(1,:).*(2*x);
W=zeros(m, n);
W(1,:)=sqrt(2/sqrt(pi))*w;
W(2,:)=W(1,:).*(2*x);
for i=1:m-2
    H(i+2,:)=(2*x)/sqrt(i+1).*H(i+1,:)-sqrt(i/(i+1))*H(i,:);
    W(i+2,:)=(2*x)/sqrt(i+1).*W(i+1,:)-sqrt(i/(i+1))*W(i,:);
end
F=H'*diag(1i.^(0:m-1))*W;
[kx, ky]=meshgrid(sqrt(2)*x);
Y=f(kx, ky);
Z=F*Y*F.';
u=F*(Z./(-kx.^2-ky.^2))*F.';

figure(1);
mesh(kx, ky, real(u));
end