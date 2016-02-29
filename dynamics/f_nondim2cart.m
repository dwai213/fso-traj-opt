function [E, EE] = f_nondim2cart(sat,TOUT,YOUT)

%Equatorial plane
r = YOUT(:,1)*sat.r_nom;
EE.t = TOUT/sat.w_kepler;
EE.x = r.*cos(YOUT(:,3));
EE.y = r.*sin(YOUT(:,3));
EE.z = zeros(size(YOUT(:,3)));

%Orbital Plane in Cartesian space
E.t = TOUT/sat.w_kepler;
cartesian_coords = f_equator2cart([EE.x EE.y EE.z]',0); %planar
E.x = cartesian_coords(1,:)';
E.y = cartesian_coords(2,:)';
E.z = cartesian_coords(3,:)';

end