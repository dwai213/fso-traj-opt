function [sat1, sat2] = repack_to_sat(x_target,u_target,sats)

sat1 = sats{1};
sat1.traj = repackageOneSatellite(x_target(1:9,:),u_target(1:3,:),sats{1});
sat2 = sats{2};
sat2.traj = repackageOneSatellite(x_target(10:18,:),u_target(4:6,:),sats{2});

end

function traj = repackageOneSatellite(x_target,u_target,sat)
traj.nondim.rho = x_target(1,:)';
traj.nondim.drho = x_target(2,:)';
traj.nondim.theta = x_target(3,:)';

traj.B.y = x_target(4,:)';
traj.B.p = x_target(5,:)';
traj.B.r = x_target(6,:)';
traj.B.dy = x_target(7,:)';
traj.B.dp = x_target(8,:)';
traj.B.dr = x_target(9,:)';

tspan = 0:sat.dT:sat.T_final;
[traj.E, traj.EE] = f_nondim2cart(sat,sat.w_kepler*tspan,x_target(1:3,:)');

end