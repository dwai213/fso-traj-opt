clc, clear all
cd /Users/dwai/Documents/Box/MATLAB/Research/trajopt-orbit-dynamics

%%
load longRun.mat
sat_cfg.th0 = -pi/4; sat_cfg.B0 = [pi/2+pi/4;0;0;0;0;0];
sat_cfg.M0 = [0;0;0];
earth = initEarth();
dT = .1;
sat_cfg.dT = dT;
sat_cfg.M = 600; sat_cfg.R = 2000e3; sat_cfg.T = 127; sat_cfg.incl = 5;
sat_cfg.T_final = pi/360;
sat1 = createEmitter(earth,sat_cfg);

% initial condition for satellite system
x_init = [sat1.rho;0;sat1.th0;...
    sat1.B0];

[nU,~] = size(total_LQR{1});
T = length(total_LQR);
x_sim_cl(:,1) = x_init;
u_sim_cl = zeros(nU,T);
for t=1:T
    u_sim_cl(:,t) = total_LQR{t}*([x_sim_cl(:,t);1]-[total_x_target(:,t);0])+total_u_target(:,t);
    x_sim_cl(:,t+1) = f(x_sim_cl(:,t), u_sim_cl(:,t), dT);
end

[sat1_sim_cl, sat2_sim_cl] = repack_to_sat(x_sim_cl,u_sim_cl,{sat1 sat1});
sat1_sim_cl.traj.E.t = 1:T;
earth = initEarth();
visualizeOrbits(earth,{sat1_sim_cl},75);

%%
nadir_score = nadirScore(x_sim_cl(:,1:end-1),u_sim_cl,sat1);
%%
figure(1),clf, fontSize = 20;
hh = plot(nadir_score);
title('Constraint Violation Score Tentative','FontSize',fontSize);
% h = line([0 2.129e4],[0 0]);
% set(h,'LineStyle','--');
% set(h,'Color',[0 0 0])
% axis([0 2.129e4 -1e-3 1e-3]);
h = line([0 7.668e4],[0 0]);
set(h,'LineStyle','--');
set(h,'Color',[0 0 0])
axis([0 7.668e4 -.1 2]);
xlabel('Time step','FontSize',fontSize), ylabel('Score','FontSize',fontSize)

%%
nadir_score = nadirScore(total_x_target(:,1:end),total_u_target,sat1);
%%
figure(2),clf, fontSize = 20;
hh = plot(nadir_score);
title('Constraint Violation Score','FontSize',fontSize);
h = line([0 2.129e4],[0 0]);
set(h,'LineStyle','--');
set(h,'Color',[0 0 0])
axis([0 2.129e4 -1e-3 1e-3]);
xlabel('Time step','FontSize',fontSize), ylabel('Score','FontSize',fontSize)