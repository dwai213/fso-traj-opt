function sat = initSatellite(planet,sat_cfg)
% createSatellite(planet,mass,orbit_height,orbital_period,th_incl,dT)


cfg = {};
cfg.dT = 25;
cfg.M = 600; cfg.R = 2000e3; cfg.T = 127; cfg.incl = 5;
cfg.th0 = pi/16;
cfg.T_final = pi/64;
cfg.B0 = [pi/2;0;0;0;0;0];
cfg.M0 = [0;0;0];

sat_cfg = load_user_cfg(cfg, sat_cfg);

disp('Satellite parameters:');
disp(sat_cfg)

%unpack satellite initial conditions
orbit_height = sat_cfg.R;
orbital_period = sat_cfg.T;
th_incl = sat_cfg.incl;
mass = sat_cfg.M;
sat.B0 = sat_cfg.B0;
sat.th0 = sat_cfg.th0;

%satellite orbit nondim properties
r_orbit = planet.R+orbit_height; %orbit radius of satellite
th_orbit = (2*pi)/(orbital_period*60); %orbital period in minutes
sat.th_orbit = th_orbit;

h_hat = mass*r_orbit^2*th_orbit; %preserved angular momentum
r_nom = (h_hat^2)/(planet.G*planet.M*mass^2);

%For orbit Cartesian coordinates simulations 
sat.w_kepler = h_hat/(mass*r_nom^2);
sat.rho = r_orbit/r_nom;
sat.m = mass;
sat.T = orbital_period;
sat.h_hat = h_hat;
sat.r_nom = r_nom;
sat.T_final = sat_cfg.T_final/sat.w_kepler;
sat.dT = sat_cfg.dT;
sat.incl = th_incl/180*pi;

%units of meters, create inertias
Lx = 1.5; Ly = 1.1; Lz = .78;
Ix = mass*(Ly^2+Lz^2)/12;
Iy = mass*(Lx^2+Ly^2)/12;
Iz = mass*(Lx^2+Lz^2)/12;
sat.J = diag([Ix,Iy,Iz]);

sat.M0 = sat_cfg.M0;

end

function full_cfg = load_user_cfg(full_cfg, user_cfg)
userkeys = fieldnames(user_cfg);
for iuserkey = 1:numel(userkeys)
    userkey = userkeys{iuserkey};
    if isfield(full_cfg, userkey)
        full_cfg.(userkey) = user_cfg.(userkey);
    else
        error(['Unknown parameter: ' userkey])
    end
end
end