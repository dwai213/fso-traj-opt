function xdot = f_sat_dynam(t,x,sat,M)
%x is
%yaw, pitch, roll,  yaw rate, pitch rate, roll rate

M1 = M(1);
M2 = M(2);
M3 = M(3);

lamb1 = sat.J(1,1);
lamb2 = sat.J(2,2);
lamb3 = sat.J(3,3);

a = x(4);
b = x(5);
c = x(6);
d = (lamb2-lamb3)*x(5)*x(6)+M1;
d = d/lamb1;
e = (lamb3-lamb1)*x(4)*x(6)+M2;
e = e/lamb2;
f = (lamb1-lamb2)*x(4)*x(5)+M3;
f = f/lamb3;

xdot = [a;b;c;d;e;f];

end

