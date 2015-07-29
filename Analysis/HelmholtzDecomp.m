function [Phi, A] = HelmholtzDecomp(u)
% Calculates the irrotational and solenoidal components of a vector field
% u=-grad(Phi)+curl(A)

N=size(u);
i=[0:N(1)/2, -N(1)/2+1:-1];
j=[0:N(2)/2, -N(2)/2+1:-1];
k=[0:N(3)/2, -N(3)/2+1:-1];
[ii,jj,kk]=meshgrid(i, j, k);
omega=cat(4, ii, jj, kk);
omega=bsxfun(@rdivide, omega, dot(omega, omega, 4));
omega(1,1,1,:)=0;

u_hat(:,:,:,1)=fftn(u(:,:,:,1));
u_hat(:,:,:,2)=fftn(u(:,:,:,2));
u_hat(:,:,:,3)=fftn(u(:,:,:,3));


Phi=ifftn(1i*dot(omega, u_hat, 4));

A_hat=1i*cross(omega, u_hat);
A(:,:,:,1)=ifftn(A_hat(:,:,:,1));
A(:,:,:,2)=ifftn(A_hat(:,:,:,2));
A(:,:,:,3)=ifftn(A_hat(:,:,:,3));
end