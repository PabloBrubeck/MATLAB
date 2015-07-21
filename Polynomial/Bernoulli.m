function B=Bernoulli(n)
B=zeros(1,n);
for m=0:n
    B(m+1)=1/(m+1);
    for j=m:-1:1
        B(j)=j*(B(j)-B(j+1));
    end
end
end