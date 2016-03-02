function gval = g_pointingConstraint(xu_trajectory,cfg,sats)
% Takes in the entire two satellite trajectory and compute a Tx1 vector of
% pointing errors
nX = cfg.nX; T = cfg.T;

g = @(x,ind) g_pointingError(x,ind,sats);

figure(35), clf;
gval = zeros(T,1);
for t=1:T
   ind = (t-1)*nX+1;
   gval(t) = g(xu_trajectory(ind:ind+nX-1),t)-1;
end

end

function err = g_pointingError(xu_trajectory_t,ind,sats)
    max_error = 1; %maximum allowable error in units of m, less than 1m

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
    
    [v1, v2] = generatePlane(T2+x2_0,N2); %basis vector for receiver plane
    
    %compute intersection for plane and pointing vector
    p1 = x1_0 + T1;
    p2 = x2_0 + T2;
    coeffs = [v1 v2 -N1]\(p1-p2);
    w = coeffs(3)*N1+p1;
    % fprintf('P2: %1.3d \t%1.3d \t%1.3d\n',p2);
    % fprintf('w: %1.3d \t%1.3d \t%1.3d\n',w);
    % fprintf('Err: %1.3d \n',err);
    % fprintf('\n');
    
    if ind > 0
        scale = 10000;
        figure(35), hold on, view(0,90); axis equal
        plot3(x1_0(1),x1_0(2),x1_0(3),'ko')
        plot3(p1(1),p1(2),p1(3),'k*')
        quiver(x1_0(1),x1_0(2),scale*T1(1),scale*T1(2));
        plot3(x2_0(1),x2_0(2),x2_0(3),'bo')
        plot3(p2(1),p2(2),p2(3),'b*')
    end

    if coeffs(3) < 0 %pointing vector was pointing away from receiver
        err = max_error;
        % error 'Got negative coefficient';
    else
        err = norm(w-p2)/max_error;
    end



end