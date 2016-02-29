function [v1,v2] = generatePlane(p0, N)
%CREATEPLANE Create a plane in parametrized form
%
%
%   PLANE = createPlane(P0, N);
%   Creates a plane from a point and from a normal to the plane. The
%   parameter N is given either as a 3D vector (1-by-3 row vector), or as
%   [THETA PHI], where THETA is the colatitute (angle with the vertical
%   axis) and PHI is angle with Ox axis, counted counter-clockwise (both
%   given in radians).
%   
%   The created plane data has the following format:
%   PLANE = [X0 Y0 Z0  DX1 DY1 DZ1  DX2 DY2 DZ2], with
%   - (X0, Y0, Z0) is a point belonging to the plane
%   - (DX1, DY1, DZ1) is a first direction vector
%   - (DX2, DY2, DZ2) is a second direction vector
%   The 2 direction vectors are normalized and orthogonal.
%
%

    n = N/norm(N,2);

    % find a vector not colinear to the normal
    v0 = [0 0 1]';
    if norm(cross(n, v0),2) < 1e-14
        disp 'Using different vector for cross product'
        v0 = [0 1 0]';
    end

    % create direction vectors
    V1 = cross(n, v0);
    v1 = V1/norm(V1,2);
    V2 = cross(v1, n);
    v2 = V2/norm(V2,2);

    v1 = -v1;
end
