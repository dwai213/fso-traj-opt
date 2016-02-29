function gval = g_pointingConstraint(xu_trajectory,cfg,sats)
% Takes in the entire two satellite trajectory and compute a Tx1 vector of
% pointing errors
nX = cfg.nX; T = cfg.T;

epsilon = 1e3; %Tolerable error but definite should readjust later

g = @(x) g_pointingError(x,sats);

gval = zeros(T,1);
for t=1:T
   ind = (t-1)*nX+1;
   gval(t) = g(xu_trajectory(ind:ind+nX-1)) - epsilon;
end

%Makes sure that states where the vector isn't even close won't get
%considered
maxError = max(gval);
for t = 1:T
    if isnan(gval(t))
        gval(t) = 10*maxError;
    end
end

end

function error = g_pointingError(xu_trajectory_t,sats)
    max_error = 10; %maximum allowable error in units of m, less than 1m

    emitter = sats{1}; receiver = sats{2};
    x1 = xu_trajectory_t(1:9); %emitter's states
    x2 = xu_trajectory_t(10:18); %receiver's states

    %emitter pointing vector
    radius = x1(1)*emitter.r_nom;
    x = radius*cos(x1(3)); y = radius*sin(x1(3)); z = 0;
    x1_0 = f_equator2cart([x;y;z],0); %center of craft
    R1 = f_orbital2body(x1(4),x1(5),x1(6));
    T1 = R1*(emitter.tool); %tool point on craft
    N1 = T1/norm(T1,2); %pointing vector for laser
    
    %receiver plane
    radius = x2(1)*receiver.r_nom;
    x = radius*cos(x2(3)); y = radius*sin(x2(3)); z = 0;
    x2_0 = f_equator2cart([x;y;z],0); %center of craft
    R2 = f_orbital2body(x2(4),x2(5),x2(6));
    T2 = R2*(receiver.tool); %tool point on craft
    N2 = T2/norm(T2,2); %normal vector for plane
    [v1, v2] = generatePlane(T2+x2_0,N2); %basis vector for planes
    
    %compute intersection for plane and pointing vector
    p1 = x1_0 + T1;
    p2 = x2_0 + T2;
    coeffs = [v1 v2 -N1]\(p1-p2);
    w = coeffs(3)*N1+p1;
    if coeffs(3) < 0 %pointing vector was pointing away from receiver
        error = NaN;
    else
        error = norm(w-p2)/max_error;
    end
end