function [tBody1, tBody2] = f_transformSatellite(sat,R,O,TH)

r = f_orbital2body(TH,0,0); %only a yaw rotation
gap = .0005*(sat.v_scaling)*[0 1 0]';

O1 = repmat(O-r*gap,1,4);
O2 = repmat(O+r*gap,1,4);

tBody1 = R*sat.v_body+O1;
tBody2 = R*sat.v_body+O2;

end