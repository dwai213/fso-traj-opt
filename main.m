%%
clc, clear all
cd /Users/dwai/Documents/Box/MATLAB/Research/trajopt-orbit-2D
addpath dynamics/
addpath satellite/
addpath sqp/

%% CREATE TENTATIVE TRAJECTORY

sat_cfg.T_final = pi/16;
sat_cfg.th0 = 0; sat_cfg.B0 = [-sat_cfg.th0;0;0;0;0;0];
sat1 = initEmitter(sat_cfg);

sat_cfg.th0 = pi/32/365; sat_cfg.B0 = [-sat_cfg.th0;0;0;0;0;0];
sat2 = initReceiver(sat_cfg);
sats = {sat1,sat2};

% Control bounds
u_min = 1*[-1; -1; -1; -1; -1; -1];
u_max = -u_min;

% Joint bounds
q_min = pi/180*[-190 0]';
q_max = pi/180*[190 120]';

[x_tentative, u_tentative] = initTentativeTraj(sat1,sat2);
replayInterval = 3; fig_num = 25;
evaluateTraj(sats,x_tentative,u_tentative,'tentative',fig_num,replayInterval)

fprintf('Done Creating Tentative Trajectory\r\n');

%% CREATE TARGET, OL, CL TRAJECTORY
tic
f = @(x,u,dt) f_DT_sat_dynam(x,u,dt,{sat1 sat2});
[x_target, u_target] = sqp_find_target_trajectory(f, x_tentative, u_tentative, u_min, u_max, q_min,q_max, {sat1 sat2});
toc
fprintf('Done Creating Target Trajectory\r\n');

x = x_tentative(:,1);
x_sim = zeros(18,length(u_target));
for t = 1:length(u_target)
    x_sim(:,t) = f_DT_sat_dynam(x,u_target(:,t),sat1.dT,{sat1 sat2});
    x = x_sim(:,t);
end
fprintf('Done Creating OL Trajectory\r\n');

nX = 18; nU = 6; T = size(x_tentative,2);
Q_lqr = eye(nX, nX); Q_lqr(nX+1, nX+1) = 0;
R_lqr = eye(nU, nU);
Q_lqr_final = Q_lqr;

[u_LQR, A, B] = tvLQR(f,x_target,u_target,Q_lqr_final,R_lqr,sat1.dT);

x_sim_cl(:,1) = x_tentative(:,1);
u_sim_cl = zeros(nU,T);
for t=1:T-1
    u_sim_cl(:,t) = u_LQR{t}*([x_sim_cl(:,t);1]-[x_target(:,t);0])+u_target(:,t);
    x_sim_cl(:,t+1) = f(x_sim_cl(:,t), u_sim_cl(:,t), sat1.dT);
end
fprintf('Done Creating CL Trajectory\r\n');

%% VISUALIZE TARGET TRAJECTORY

evaluateTraj(sats,x_target,u_target,'target',fig_num,replayInterval)

%% VISUALIZE OL TRAJECTORY

evaluateTraj(sats,x_sim,u_target,'OL',fig_num+1,replayInterval)

%% VISUALIZE CL TRAJECTORY

evaluateTraj(sats,x_sim_cl,u_sim_cl,'CL',fig_num+2,replayInterval)

%% Save Results
% [sat1_sim_cl, sat2_sim_cl] = repack_to_sat(x_sim_cl,u_sim_cl,{sat1 sat2});
% %     save longRun.mat
% sat_cfg.th0 = sat1_sim_cl.traj.nondim.theta(end);
% sat_cfg.B0 = [sat1_sim_cl.traj.B.y(end);
%     sat1_sim_cl.traj.B.p(end);
%     sat1_sim_cl.traj.B.r(end);
%     sat1_sim_cl.traj.B.dy(end);
%     sat1_sim_cl.traj.B.dp(end);
%     sat1_sim_cl.traj.B.dr(end)];
% sat_cfg.M0 = u_sim_cl(:,end);