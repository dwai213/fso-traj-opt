%%
clc, clear all
cd /Users/dwai/Documents/Box/MATLAB/Research/trajopt-orbit-2D
addpath dynamics/
addpath satellite/
addpath sqp/

%%
sat_cfg.T_final = pi/48;
sat_cfg.th0 = -pi/32/365; sat_cfg.B0 = [-sat_cfg.th0;0;0;0;0;0];
sat1 = initEmitter(sat_cfg);

sat_cfg.th0 = 0; sat_cfg.B0 = [0;0;0;0;0;0];
sat2 = initReceiver(sat_cfg);
sats = {sat1,sat2};

[x_tentative, u_tentative] = initTentativeTraj(sat1,sat2);

nX = 18; nU = 6; T = size(x_tentative,2);
cfg = struct(); cfg.nX = nX; cfg.nU = nU; cfg.T = T;
cfg.dt = sat1.dT;

x0 = [reshape(x_tentative,nX*T,1); reshape(u_tentative,nU*T,1)];
evaluateTraj(sats,x_tentative,u_tentative,'tentative',25,1)

%%

errors = g_pointingConstraint(x0,cfg,sats);
figure(1)
plot(errors), title('Pointing Error')
figure(20)
cd /Users/dwai/Documents/Box/MATLAB/Research/trajopt-orbit-2D/test_cases