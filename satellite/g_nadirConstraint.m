function gval = g_nadirConstraint(xu_trajectory,cfg,sats)

T = cfg.T;

delta = -.995; % the alignment tolerance(cos(theta))
% value must be higher than this number in order for it to count as nadir pointing

[x_traj,~] = repack_to_timeSeries(xu_trajectory,cfg);
g = @(x,craft) g_nadirAlignment(x,craft);

% Compute the values of the constraint for the T timesteps of the
% trajectory
gval = zeros(2*T,1);
for i = 1:2:(2*T)
    t = ceil(i/2);
    gval(i) = g(x_traj(1:9,t),sats{1}) - delta;  %HARDCODED FIX LATER
    gval(i+1) = g(x_traj(10:18,t),sats{2}) - delta;
end

end

function alignment = g_nadirAlignment(states,sat)
%Computes how well the nadir point aligns with the outward pointing radial
%vector

rho = states(1);
theta = states(3);
yaw = states(4);
p = states(5);
r = states(6);

radius = rho*sat.r_nom;
x = radius*cos(theta); y = radius*sin(theta); z = 0;
O = f_equator2cart([x;y;z],0);
R = f_orbital2body(yaw,p,r);
N = R*(sat.nadir); %nadir point on craft
alignment = dot(O/norm(O),(N)/norm(N));

end