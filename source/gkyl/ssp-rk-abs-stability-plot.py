from pylab import *
style.use('postgkyl.mplstyle')

fmt = {}

X = linspace(-3, 1, 100)
Y = linspace(-3, 3, 100)
XX, YY = meshgrid(X,Y)
ZZ = -XX + 1j*YY
WW2 = abs(1-ZZ+0.5*ZZ**2)
cs = contour(XX, YY, WW2, levels=[1], colors='r')

WW3 = abs(1-ZZ+0.5*ZZ**2-1.0/6.0*ZZ**3)
cs = contour(XX, YY, WW3, levels=[1], colors='k')

WW3_4 = abs((ZZ**4-8*ZZ**3+24*ZZ**2-48*ZZ+48)/48.0)
cs = contour(XX, YY, WW3_4, levels=[1], colors='m')

xlabel(r'$\Delta t \lambda$')
ylabel(r'$\Delta t \omega$')
title(r'Absolute Stability Region')

grid()
axis('image')
savefig('ssp-rk-abs-stability.png', dpi=150)
show()
