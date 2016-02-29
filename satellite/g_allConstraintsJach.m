function [gval, jach] = g_allConstraintsJach(xu_trajectory,cfg,sats)

[g1, j1] = g_nadirConstraintJach(xu_trajectory,cfg,sats);
% [g2, j2] = g_pointingConstraintJach(xu_trajectory,cfg,sats);

gval = g1;
jach = j1;
% gval = [g1;g2];
% jach = [j1;j2];

end