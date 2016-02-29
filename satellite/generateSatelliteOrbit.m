function trajectories = generateSatelliteOrbit(sat)
% generateSatelliteOrbit(sat)
% E is states in E_x, E_y coordinates (Cartesian space) (orbital plane)
% EE is states in E_1, E_2 coordinates (equatorial plane)

%This is in real time, sufficient for one full orbit
tspan = 0:sat.dT:sat.T_final;
%Cartesian orbit sim
[TOUT, YOUT] = ode45(@f_orbit_nondim,sat.w_kepler*tspan,[sat.rho;0;sat.th0]);
%YOUT: \rho, dRho/dTau, \theta in equatorial plane coordinates

%Body angle sim
[TBODY, YBODY] = ode45(@f_sat_dynam,tspan,sat.B0,[],sat,sat.M0);
%YBODY: yaw, pitch, roll and their rates in body coordinates (6x1) vector

%Reconstruction in Real Space
%Nondim units
nondim.t = TOUT;
nondim.rho = YOUT(:,1);
nondim.drho = YOUT(:,2);
nondim.theta = YOUT(:,3);

%Body Angles
B.t = TBODY;
B.y = YBODY(:,1);
B.p = zeros(size(YBODY(:,2)));
B.r = zeros(size(YBODY(:,3)));
B.dy = YBODY(:,4);
B.dp = zeros(size(YBODY(:,5)));
B.dr = zeros(size(YBODY(:,6)));

%Generates coordinates in equatorial and orbital plane
[E,EE] = f_nondim2cart(sat,TOUT,YOUT);

trajectories.E = E;
trajectories.EE = EE;
trajectories.B = B;
trajectories.nondim = nondim;

end