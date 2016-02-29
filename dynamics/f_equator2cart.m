function out = f_equator2cart(x,th)
%x: 3xT vector that represents coordinates in the equatorial plane
%th: inclination of orbit

%Rotation around X axis
A = [   1 0 0               ; ...
        0 cos(th) sin(th)   ; ...
        0 -sin(th) cos(th)] ;
out = A*x;
end