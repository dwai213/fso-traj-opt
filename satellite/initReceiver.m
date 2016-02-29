function receiver = initReceiver(cfg)

%Creates basic satellite body
disp('Receiver:');
planet = initEarth();
receiver = initSatellite(planet,cfg);
receiver.name = 'receiver';

%For drawing purposes, define a satellite geometry
Sx = 1; Sy = .5; %the dimension of the rectangle
v_scaling = 6e5; %scaling factor to make the satellite appear visible in the plot
receiver.v_scaling = v_scaling;

% the four corners of the drawn rectangle
receiver.v_body = .5*v_scaling*[0 0 0 0; Sx Sx -Sx -Sx; Sy -Sy -Sy Sy];
receiver.v_nadir = .5*v_scaling*[0 -Sx 0]'; %left middle point of rectangle
receiver.v_tool = .5*v_scaling*[Sx 0 0]'; %out of page, middle point of rectangle, receptor

% the actual geometry of the satellite
receiver.body = receiver.v_body/v_scaling;
receiver.nadir = receiver.v_nadir/v_scaling;
receiver.tool = receiver.v_tool/v_scaling; %out of page, middle point of rectangle, receptor

receiver.traj = generateSatelliteOrbit(receiver);

end