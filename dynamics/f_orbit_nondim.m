function xdot = f_orbit_nondim(t,x)
%x is
%rho, drho/dTau, \theta, the nondimensionalized coordinates from OOR
aa = x(2);
bb = 1./x(1).^3-1./x(1).^2;
cc = 1./x(1).^2;


xdot = [aa;bb;cc];

end

