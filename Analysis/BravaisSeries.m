function h = BravaisSeries(f, A, n)
% Returns the Fourier expansion of a Bravais-lattice-periodic-function.
k=0:n-1;
[n1, n2, n3]=meshgrid(k, k, k);
B=A/n*[n3(1:end); n1(1:end); n2(1:end)];
h=reshape(f(B(1,:), B(2,:), B(3,:)), n, n, n);
h=fftn(h)/n^3;
end