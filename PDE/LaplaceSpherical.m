function [] = LaplaceSpherical(N)
% Solves Laplace's equation on a sphere

% Initialize adjoint transform
[x,w]=gl(N); % Gauss-Legendre quadrature nodes
M=size(x,2);
kappa = 1000;
nfsft_precompute(N,kappa);
plan=nfsft_init_advanced(N,M,NFSFT_NORMALIZED);
nfsft_set_x(plan,x);
nfsft_precompute_x(plan);

% Compute adjoint transform
V=potential(x);
nfsft_set_f(plan,V.*w);
nfsft_adjoint(plan);
Cml = nfsft_get_f_hat(plan);
nfsft_finalize(plan);

% Prepare spherical plot
figure(1); clf;
depth=256;
colormap(jet(depth));
[h,th,ph]=sphericalPlot(2*N,N);
camlight; shading interp;

% Obtain evaluation nodes
dim=[2*N, N];
x=[th(1:end); ph(1:end)];

% Initialize transform
M=size(x,2);
plan=nfsft_init_advanced(N,M,NFSFT_NORMALIZED);
nfsft_set_x(plan,x);
nfsft_precompute_x(plan);

% Iterate for various values of r
for r=0.01:0.01:3
    title(sprintf('r=%2.2f',r));
    if(r<1)
        fh=bsxfun(@times, r.^(0:N), Cml);
    else
        fh=bsxfun(@times, r.^(-1:-1:-1-N), Cml);
    end
    % Compute the transform
    nfsft_set_f_hat(plan, fh);
    nfsft_trafo(plan);
    fa=nfsft_get_f(plan);
    % Normalize color data
    Cint=reshape(real(fa), dim);
    Cmax=max(Cint(:));
    Cmin=min(Cint(:));
    Cint=depth*(Cint-Cmin)/(Cmax-Cmin);
    set(h,'CData',Cint);
    drawnow;
end
% Clean up memory
nfsft_finalize(plan);
nfsft_forget();
end

% Potential at r=1 (Imposed Boundary Condition)
function y = potential(x)
y=sign((sin(x(2,:)).*cos(x(1,:))).^2-0.5);
y2=-sign((sin(x(2,:)).*sin(x(1,:))).^2-0.5);
idx=x(2,:)<pi/2;
y(idx)=y2(idx);
end
