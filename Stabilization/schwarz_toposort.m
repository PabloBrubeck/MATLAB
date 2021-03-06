function [isweep,icolor,itopo,iflux] = schwarz_toposort(itopo,iflux)
ndim=2;
nfaces=2*ndim;
nel=size(itopo,2);

isweep=zeros(nel,1);
icolor=zeros(nel,1);

k=1;
q=0;
for e=1:nel
    if(all(iflux(:,e)>=0))
        q=q+1;
        isweep(q)=e;
        icolor(e)=k;
    end
end

p1=1;
p2=q;
qlag=0;
while (q>qlag && q<nel)
    k=k+1;
    qlag=q;
    for p=p1:p2
    e=isweep(p);   
    for f=1:nfaces
        ee=itopo(f,e);
        if(iflux(f,e)>0 && ee~=e)
            ff=find(itopo(:,ee)==e);
            itopo(ff,ee)=ee;
            iflux(ff,ee)=0;
            itopo(f,e)=e;
            iflux(f,e)=0;
            if(icolor(ee)==0 && all(iflux(:,ee)>=0))
                q = q+1;
                isweep(q)=ee;
                icolor(ee)=k;
            end
        end
    end
    end
    p1=p2+1;
    p2=q;
end

end