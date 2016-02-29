function out = f_cart2equator(x,th)
%x: 3xT vector that represents coordinates in the cartesian (orbital) plane
%th: inclination of orbit

%Rotation around X axis
A = [   1 0 0               ; ...
        0 cos(th) sin(th)   ; ...
        0 -sin(th) cos(th)] ;
out = A'*x; %note the inverse
end