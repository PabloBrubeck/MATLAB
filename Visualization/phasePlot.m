function [] = phasePlot(f, x0, x1, y0, y1, n)
x=linspace(x0, x1, n);
y=linspace(y0, y1, n);
[re, im]=meshgrid(x, y);
C=(re+1i*im);

z=f(reshape(C,[1,n*n]));
z=reshape(z,[n,n]);

colormap(hsv);
iarg=image([x0,x1], [y0,y1], arg(z),'CDataMapping','scaled');

colormap(gray);
imod=image([x0,x1], [y0,y1], abs(z),'CDataMapping','scaled');

Z = immultiply(iarg,imod)

xlabel('Re(z)');
ylabel('Im(z)');
caxis([-pi,pi]);
colorbar('YTick', linspace(-pi, pi,5), ...
         'YTickLabel', {'-\pi','-\pi/2','0','\pi/2','\pi'});
end
