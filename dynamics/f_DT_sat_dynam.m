function next_states = f_DT_sat_dynam(state,controls,dT,sats)
% Discretized dynamics for satellite system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STATE REPRESENTATION
% EMITTER (9 states)
% rho, drho, theta for sat1
% y, p, r for sat1
% \dot{y, p, r} for sat1
% RECEIVER (9 states)
% rho, drho, theta for sat2
% y, p, r for sat2
% \dot{y, p, r} for sat2
% q1, q2 for two turret joints on sat1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONTROL REPRESENTATION (8 inputs)
% Mx, My, Mz for sat1
% Mx, My, Mz for sat2
% \dot{q1 q2} for sat1 turrets

%Convention emitter satellite first and then receiver
sat1 = sats{1};
sat2 = sats{2};

next_sat1_coords = satCartesianDynam_nondim(sat1,state(1:3),dT);
next_sat1_body_coords = satBodyDynam(sat1,state(4:9),controls(1:3),dT);
next_sat2_coords = satCartesianDynam_nondim(sat2,state(10:12),dT);
next_sat2_body_coords = satBodyDynam(sat2,state(13:18),controls(4:6),dT);
% next_turret_states = turretDynam(state(10:11),controls(4:5),dT);
 
next_states = [next_sat1_coords;...
    next_sat1_body_coords;...
    next_sat2_coords;...
    next_sat2_body_coords;
%     next_turret_states;...
    ];
end


function next_state = satCartesianDynam_nondim(sat,coords,dT)
	%one step dynamics for non-dim cartesian coordinates

rho = coords(1);
drho = coords(2);
theta = coords(3);
dT = sat.w_kepler*dT;

next_rho = rho + drho*dT;
next_drho = drho + dT*(1/rho^3 - 1/rho^2);
next_theta = theta + dT*1/rho^2;

next_state = [next_rho; next_drho; next_theta];

end

function next_state = satBodyDynam(sat,coords,controls,dT)
	%one step dynamics for body angle dynamics

y = coords(1); p = coords(2); r = coords(3);
dy = coords(4); dp = coords(5); dr = coords(6);
L1 = sat.J(1,1); L2 = sat.J(2,2); L3 = sat.J(3,3);
M1 = controls(1); M2 = controls(2); M3 = controls(3);

next_y = y + dy*dT;
next_dy = dy + dT*((L2-L3)*dp*dr+M1)/L1;
next_p = p + dp*dT;
next_dp = dp + dT*((L3-L1)*dy*dr+M2)/L2;
next_r = r + dr*dT;
next_dr = dr + dT*((L1-L2)*dy*dp+M3)/L3;

next_state = [next_y;next_p;next_r;next_dy;next_dp;next_dr];

end

function next_state = turretDynam(coords,controls,dT)

q1 = coords(1);
q2 = coords(2);
dq1 = controls(1);
dq2 = controls(2);

next_q1 = q1 + dq1*dT;
next_q2 = q2 + dq2*dT;

next_state = [next_q1;next_q2];

end
