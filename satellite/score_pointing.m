function score = score_pointing(x_tentative,u_tentative,sats)

[nX,T] = size(x_tentative);
nU = size(u_tentative,1);
cfg.nX = nX; cfg.nU = nU; cfg.T = T;
xu_trajectory = [reshape(x_tentative,nX*T,1); reshape(u_tentative,nU*T,1)];
score = g_pointingConstraint(xu_trajectory,cfg,sats);


end