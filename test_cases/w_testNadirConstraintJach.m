%%
clear all, clc
%%
dT = 1;
earth = initEarth();
sat_cfg.dT = dT;
sat_cfg.M = 600; sat_cfg.R = 2000e3; sat_cfg.T = 127; sat_cfg.incl = 5;
sat_cfg.T_final = pi/32;
sat_cfg.th0 = -pi/4; sat_cfg.B0 = [pi/2+pi/4;0;0;0;0;0];
sat_cfg.M0 = [0;0;0];
sat1 = createEmitter(earth,sat_cfg);

sat_cfg.th0 = -pi/8; sat_cfg.M0 = [0;0;0];
sat2 = createReceiver(earth,sat_cfg);

% initial condition for satellite system
x_init = [sat1.rho;0;sat1.th0;sat1.B0;
          sat2.rho;0;sat2.th0;sat2.B0];

[x_tentative, u_tentative] = createTentativeTraj(x_init,sat1,sat2);

[cfg.nX, cfg.T] = size(x_tentative); [cfg.nU,~] = size(u_tentative);
xu_trajectory = [reshape(x_tentative,cfg.nX*cfg.T,1); reshape(u_tentative,cfg.nU*cfg.T,1)];
[gval, jach] = g_nadirConstraintJach(xu_trajectory,cfg,{sat1 sat2});