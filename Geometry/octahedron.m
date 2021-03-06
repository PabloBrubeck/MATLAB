function [] = octahedron(n,m)
top=[0 0 1]';   bot=[0 0 -1]';
front=[1 0 0]'; back=[-1 0 0]';
right=[0 1 0]'; left=[0 -1 0]';

q(:,:,1)=[bot, left, top, front];
q(:,:,2)=[top, front, bot, right];
q(:,:,3)=[bot, back,  top, right];
q(:,:,4)=[top, back,  bot, left];


m=m/2;
n=n/2;

x=zeros(m,4*n);
y=zeros(m,4*n);
z=zeros(m,4*n);
for k=0:3
    for i=0:n-1
        u=i/(n);
        for j=0:m-1
            v=j/(m);
            idx=(k*n+i)*m+j+1;
            p=quadFace(q(:,:,k+1), v, u);
            p=p/norm(p);
            x(idx)=p(1);
            y(idx)=p(2);
            z(idx)=p(3);
        end
    end
end
surf(x,y,z);
axis equal;
end

function p=quadFace(q,u,v)
if(u+v<1)
    p=q*[1-u-v; u; 0; v];    
else
    p=q*[0; 1-v; u+v-1; 1-u];
end
end