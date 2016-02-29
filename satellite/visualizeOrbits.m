function visualizeOrbits(satellites, interval, record)
% visualizeOrbits(satellites,interval, record)

if nargin == 2
    record = 0;
end
planet = initEarth();
if length(get(get(planet.hh,'CurrentAxes'),'Children')) > 1
    planet = initEarth();
end

nn = length(satellites);
coordinates = cell(nn,1);
angles = cell(nn,1);
durations = zeros(nn,1);

for n = 1:nn
    trajectory = satellites{n}.traj;
    durations(n) = length(trajectory.E.t);
    coordinates{n} = trajectory.E;
    angles{n} = trajectory.B;
end

figure(planet.hh);
% zoom(planet.hh,1.25)
circ_handles = zeros(nn,1);
prev_line_handles = zeros(nn,1);
prev_nadir_handles = zeros(nn,1);
prev_satellites = zeros(2*nn,1);

%plotting aesthetics
craft1.color = 'ko';
craft1.trace = 'r--';
craft2.color = 'ko';
craft2.trace = 'b--';
craft3.color = 'ko';
craft3.trace = 'g--';
flair = {craft1,craft2,craft3};

%account for different orbital periods for spacecrafts
[sorted, sortedInd] = sort(durations,'descend');

for i = 1:interval:length(coordinates{sortedInd(1)}.t)
    if (i > sorted(end)) %handles removing the ith satellite once its trajectory has finished
        nn = nn-1;
        circ_handles = zeros(nn,1);
        prev_line_handles(end) = [];
        prev_nadir_handles(end) = [];
        prev_satellites(end) = [];
        prev_satellites(length(prev_satellites)/2) = [];
        sorted(end) = [];
    end
    for n = 1:nn
        E = coordinates{sortedInd(n)};
        circ_handles(n) = plot3(E.x(i),E.y(i),E.z(i),flair{sortedInd(n)}.color);
    end
    pause(.1)
    if record
        print(sprintf('orbit%s/orbit%d',datestr(now),i),'-dpng')
    end
    delete(circ_handles)
    
    if i ~= 1
        try
            delete([prev_satellites; prev_line_handles; prev_nadir_handles])
        catch ME
            % ME
            fprintf('Skipped %d\r\n',i);
        end
    end
    for n = 1:nn
        sat = satellites{sortedInd(n)};
        E = coordinates{sortedInd(n)};
        B = angles{sortedInd(n)};
        R = f_orbital2body(B.y(i),B.p(i),B.r(i));
        O = [E.x(i);E.y(i);E.z(i)];
        N = R*(sat.v_nadir); %nadir point on craft
        prev_line_handles(n) = plot3(E.x(1:i),E.y(1:i),E.z(1:i),flair{sortedInd(n)}.trace);
        prev_nadir_handles(n) = plot3(O(1)+N(1),O(2)+N(2),O(3)+N(3),flair{sortedInd(n)}.color);
        [newBody_1, newBody_2] = f_transformSatellite(sat,R,O,trajectory.nondim.theta(i));
        if strcmp(satellites{n}.name,'emitter')
            prev_satellites(n) = fill3(newBody_1(1,:),newBody_1(2,:),newBody_1(3,:),'g');
            prev_satellites(n+nn) = fill3(newBody_2(1,:),newBody_2(2,:),newBody_2(3,:),'c');
        else
            prev_satellites(n) = fill3(newBody_1(1,:),newBody_1(2,:),newBody_1(3,:),'c');
            prev_satellites(n+nn) = fill3(newBody_2(1,:),newBody_2(2,:),newBody_2(3,:),'g');
        end
    end
    % axis vis3d
    % moveCamera(planet.hh,satellites{1}.traj.E,interval,i);
    % pause(1)

%     camva(3);
%     axis([-6.7972e+06 9.1478e+06 -6378000 6378000 -4378000 4378000]);
%     axis equal
end
