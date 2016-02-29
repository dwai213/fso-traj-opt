function [x_target, u_target] = repack_to_timeSeries(xp,cfg)
	%Takes in a scp candidate solution (nXUT x 1) and spits out the time series

nU = cfg.nU; nX = cfg.nX; T = cfg.T;
x_target = reshape(xp(1:T*nX),nX, T);
u_target = reshape(xp(T*nX+1:end), nU, T);

end