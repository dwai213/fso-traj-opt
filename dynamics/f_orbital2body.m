function out = f_orbital2body(y,p,r)
%y,p,r : scalar yaw, pitch, and roll in radians that parameterize the 3-2-1
%Euler angle transformation

%Rotation around Yaw axis
Y = [   cos(y) sin(y)  0  ; ...
        -sin(y) cos(y) 0  ; ...
        0       0        1] ;
    
%Rotation around Pitch axis
P = [   cos(p)  0       -sin(p) ; ...
        0        1       0       ; ...
        sin(p) 0       cos(p)] ;
    
%Rotation around Roll axis
R = [   1   0       0; ...
        0 cos(r)   sin(r)  ; ...
        0 -sin(r)  cos(r)];
    
out = R*P*Y;
end