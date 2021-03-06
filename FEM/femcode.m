function [] = femcode(h0)

% Rectangle with circular hole, refined at circle boundary
fd=@(p) ddiff(drectangle(p,-1,1,-1,1), dcircle(p,0,0,0.5));
fh=@(p) 0.05+0.3*dcircle(p,0,0,0.5);
[p,t,b]=distmesh2d(fd,fh,h0,[-1,-1;1,1],[-1,-1;-1,1;1,-1;1,1]);

% [K,F] = assemble(p,t) % K and F for any mesh of triangles: linear phi's
N=size(p,1);T=size(t,1); % number of nodes, number of triangles
% p lists x,y coordinates of N nodes, t lists triangles by 3 node numbers
F=zeros(N,1); % load vector F to hold integrals of phi's times load f(x,y)

f=@(x,y) 1+0*x+0*y;

i=zeros(9*T,1);
j=zeros(9*T,1);
K=zeros(9*T,1);
for e=1:T  % integration over one triangular element at a time
    nodes=t(e,:); % row of t = node numbers of the 3 corners of triangle e
    Pe=[ones(3,1),p(nodes,:)]; % 3 by 3 matrix with rows=[1 xcorner ycorner] 
    Area=abs(det(Pe))/2; % area of triangle e = half of parallelogram area
    C=inv(Pe); % columns of C are coeffs in a+bx+cy to give phi=1,0,0 at nodes
    % now compute 3 by 3 Ke and 3 by 1 Fe for element e
    grad=C(2:3,:);

    Ke=Area*(grad'*grad); % element matrix from slopes b,c in grad
    centroid=mean(p(nodes,:)); % centroid: average of 3 node coordinates
    load=f(centroid(1), centroid(2));
    Fe=Area/3*load; % integral of phi over triangle is volume of pyramid:
    % multiply Fe by f at centroid for load f(x,y): one-point quadrature!

    idx=9*e-8:9*e;
    [ni,nj]=ndgrid(nodes);
    i(idx)=ni(:);
    j(idx)=nj(:);
    K(idx)=Ke(:); % add Ke to 9 entries of global K
    F(nodes)=F(nodes)+Fe; % add Fe to 3 components of load vector F
end   % all T element matrices and vectors now assembled into K and F
K=sparse(i, j, K, N, N);

% [Kb,Fb] = dirichlet(K,F,b) % assembled K was singular! K*ones(N,1)=0
% Implement Dirichlet boundary conditions U(b)=g(x,y) at nodes in list b
K(b,:)=0; F(b)=0*(sin(3*pi*p(b,1))-sin(3*pi*p(b,2))); % put g(x,y) in boundary rows/columns of K and F 
K(b,b)=speye(length(b),length(b)); % put I into boundary submatrix of K
Kb=K; Fb=F; % Stiffness matrix Kb (sparse format) and load vector Fb

% Solving for the vector U will produce U(b)=0 at boundary nodes
U=Kb\Fb;  % The FEM approximation is U_1 phi_1 + ... + U_N phi_N

% Plot the FEM approximation U(x,y) with values U_1 to U_N at the nodes 
trisurf(t,p(:,1),p(:,2),U,U);
axis square; shading interp; colormap(jet(256));
end

