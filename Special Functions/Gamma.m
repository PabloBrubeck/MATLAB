function y=Gamma(z)
% Computes the gamma function of a complex number.
b=real(z)<0.5;
z=b+(1-2*b).*z-1;
g=7;
k=10;
T=Chebyshev(2*k+1);
p=zeros(k);
for i=0:k-1
p(i+1)=0;
fact=2*exp(g+0.5);
for j=0:i
    p(i+1)=p(i+1)+fact*T(2*i+1,2*j+1)*(j+g+0.5)^(-j-0.5);
    fact=fact*exp(1)*(2*j+1)/2;
end
end
r=ones(size(z));
s=p(1)/2*r;
for i=2:k
r=r.*((z-i+2)./(z+i-1));
s=s+p(i)*r;
end
t=z+g+0.5;
y=power(t,z+0.5).*exp(-t).*s;

for idx=1:numel(z)
    if(b(idx))
         y(idx)=pi/(sin(-pi*z(idx))*y(idx));
    end
end
end
