clc, clear all
cd /Users/dwai/Documents/Box/MATLAB/Research/trajopt-orbit-dynamics
%%
% CREATE TENTATIVE TRAJECTORY
earth = initEarth();

sat_cfg.dT = .1;
sat_cfg.M = 600; sat_cfg.R = 2000e3; sat_cfg.T = 127; sat_cfg.incl = 5; 
sat_cfg.th0 = -pi/3; sat_cfg.B0 = [0;0;0;0;0;0]; sat_cfg.T_final = pi/12;
sat_cfg.M0 = [-.05;0;.05];
sat1 = createEmitter(earth,sat_cfg);

visualizeOrbits(earth,{sat1.traj},10)

%%
B = sat1.traj.B;
figure(5)
plot(B.t,[B.y])

%%
tspan = 0:sat1.dT:sat1.T_final;
x0 = [sat1.rho;0;sat1.th0;sat1.B0]; x = x0;
M0 = sat1.M0;
trajectory = zeros(9,length(tspan));
for t = 1:length(tspan)
    trajectory(:,t) = f_DT_sat_dynam(x,M0,sat1.dT,{sat1});
    x = trajectory(:,t);
end

%%
figure(6)
plot(B.t,[B.y-trajectory(4,:)' B.p-trajectory(5,:)' B.r-trajectory(6,:)'])