function emitter = initEmitter(cfg)

%Creates basic satellite body
disp('Emitter:');
planet = initEarth();
emitter = initSatellite(planet,cfg);
emitter.name = 'emitter';

%For drawing purposes, define a satellite geometry
Sx = 1; Sy = .5; %the dimension of the rectangle, centered at (0,0)
emitter.v_scaling = 7e5; %scaling factor to make rectangle be visible

% the four corners of the rectangle
emitter.v_body = .5*emitter.v_scaling*[0 0 0 0; Sx Sx -Sx -Sx; Sy -Sy -Sy Sy];
emitter.v_nadir = .5*emitter.v_scaling*[0 -Sx 0]'; %left middle point of rectangle
emitter.v_tool = .5*emitter.v_scaling*[-Sx 0 0]'; %into the page, middle point of rectangle, laser

emitter.body = emitter.v_body/emitter.v_scaling;
emitter.nadir = emitter.v_nadir/emitter.v_scaling;
emitter.tool = emitter.v_nadir/emitter.v_scaling;

emitter.traj = generateSatelliteOrbit(emitter);

end