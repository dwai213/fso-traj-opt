function emitter = initEmitter(cfg)

%Creates basic satellite body
disp('Emitter:');
planet = initEarth();
emitter = initSatellite(planet,cfg);
emitter.name = 'emitter';

%For drawing purposes, define a satellite geometry
Sx = 1; Sz = .5; %the dimension of the rectangle, centered at (0,0)
Sy = .5; %tool distance from spacecraft
v_scaling = 7e5;
emitter.v_scaling = v_scaling; %scaling factor to make rectangle be visible

% the four corners of the rectangle
emitter.v_body = .5*v_scaling*[Sx Sx -Sx -Sx; 0 0 0 0; Sz -Sz -Sz Sz]; %looking from +z, the craft will be a thin line that runs along x-axis
emitter.v_nadir = .5*v_scaling*[-Sx 0 0]'; %left middle point of rectangle
emitter.v_tool = .5*v_scaling*[0 Sy 0]'; %out of page, middle point of rectangle, emitter

emitter.body = emitter.v_body/emitter.v_scaling;
emitter.nadir = emitter.v_nadir/emitter.v_scaling;
emitter.tool = emitter.v_tool/emitter.v_scaling;

emitter.traj = generateSatelliteOrbit(emitter);


end