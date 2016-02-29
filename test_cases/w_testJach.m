%%
clc, clear all
cd /Users/dwai/Documents/Box/MATLAB/Research/trajopt-orbit
addpath dynamics/
addpath satellite/
addpath sqp/

%%
sat_cfg.T_final = pi/64;
sat_cfg.th0 = -pi/4; sat_cfg.B0 = [pi/2+pi/4;0;0;0;0;0];
sat1 = initEmitter(sat_cfg);

sat_cfg.th0 = -pi/8; sat_cfg.B0 = [pi/2+pi/8;0;0;0;0;0];
sat2 = initReceiver(sat_cfg);
sats = {sat1,sat2};

%%
nX = 18; nU = 6; T = 60;
[x_tentative, u_tentative] = initTentativeTraj(sat1,sat2);
xu_trajectory = [reshape(x_tentative,nX*T,1); reshape(u_tentative,nU*T,1)];

cfg = struct();
cfg.nX = nX;
cfg.nU = nU;
cfg.T = T;
cfg.f = @(x,u,dt) f_DT_sat_dynam(x,u,dt,{sat1 sat2});
cfg.dt = sat1.dT;

[gval, exp_jach] = g_nadirConstraintJach(xu_trajectory,cfg,sats);

ff = @(x) g_nadirConstraint(x,cfg,sats);
num_jach = numerical_jac(ff,xu_trajectory);

% fff = @(x) g_nadirConstraint2(x,cfg,sats);
% num_jach2 = numerical_jac(fff,xu_trajectory);

%%
figure(5); imagesc(exp_jach); title('Derived Jach');
figure(6); imagesc(num_jach); title('Numerical Jach1');
sum(sum(abs(num_jach-exp_jach)))
figure(8); imagesc(num_jach-exp_jach); title('Difference');

