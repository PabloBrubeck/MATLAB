function u=NavierStokes(n)
% Solves for the velocity field assuming periodic boundary conditions.

nu=0.7978;
dt=0.005;
u=zeros(n,n,n,3);

N=size(u);
i=[0:N(1)/2-1, 0, -N(1)/2+1:-1];
j=[0:N(2)/2-1, 0, -N(2)/2+1:-1];
k=[0:N(3)/2-1, 0, -N(3)/2+1:-1];
[i2,j2,k2]=meshgrid(i.^2, j.^2, k.^2);
D2=-i2-j2-k2;
op=nu*D2;

x=2*pi*(0:N(1)-1)/N(1);
y=2*pi*(0:N(2)-1)/N(2);
z=2*pi*(0:N(3)-1)/N(3);
[xx,yy,zz]=meshgrid(x, y, z);

u(:,:,:,1)=cos(zz+yy);
u(:,:,:,2)=sin(zz+xx);
u(:,:,:,3)=cos(yy+xx);
figure(1);
h=quiver3(xx, yy, zz, u(:,:,:,1), u(:,:,:,2), u(:,:,:,3));
axis equal;

nframes=10000;
for t=1:nframes
    tic
    u=solveRK4(u, dt, op);
    title(sprintf('Calculation time %.0f ms', 1000*toc));
    if(mod(t,10)==0)
        set(h, 'UData', u(:,:,:,1));
        set(h, 'VData', u(:,:,:,2));
        set(h, 'WData', u(:,:,:,3));
        drawnow; 
    end
end

end

function A=advection(u)
A = bsxfun(@times, u(:,:,:,1), spectralD(u,1,1));
A=A+bsxfun(@times, u(:,:,:,2), spectralD(u,1,2));
A=A+bsxfun(@times, u(:,:,:,3), spectralD(u,1,3));
end

function L=specLaplacian(u, op)
L(:,:,:,1)=ifftn(op.*fftn(u(:,:,:,1)));
L(:,:,:,2)=ifftn(op.*fftn(u(:,:,:,2)));
L(:,:,:,3)=ifftn(op.*fftn(u(:,:,:,3)));
end

function ut=partialTime(u, op)
ut=specLaplacian(u, op)-advection(u);
end

function u=solveRK4(u, dt, op)
k1=dt*partialTime(u, op);
k2=dt*partialTime(u+k1/2, op);
k3=dt*partialTime(u+k2/2, op);
k4=dt*partialTime(u+k3, op);
u=u+(k1+2*k2+2*k3+k4)/6;
end

function u=solveEuler(u, dt, op)
u=u+dt*partialTime(u, op);
end