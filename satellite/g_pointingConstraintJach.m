function [gval, jach] = g_pointingConstraintJach(xu_trajectory,cfg,sats)

gval = g_pointingConstraint(xu_trajectory,cfg,sats);

jach = computeJacobian(xu_trajectory,cfg,sats);

end

function jach = computeJacobian(xu_trajectory,cfg,sats)
    % Compute the Jacobian for gval for only certain variations in states
    % for pointing constraint
    % Namely, rho, theta, ypr    
    nX = cfg.nX; nU = cfg.nU; T = cfg.T;
    nXUT = (nX+nU)*T;
    f = @(state) f_DT_sat_dynam(state(1:nX),state(nX+1:end),1,sats); %HARDCODED MAKE THIS BETTER
    jach = zeros(T,nXUT);
    eps = 1e-3;
    delta = zeros(nX+nU,1);
    single_cfg.nX = nX; single_cfg.nU = nU; single_cfg.T = 1;
    g = @(x) g_pointingConstraint(x,single_cfg,sats);
    [x_traj,u_traj] = repack_to_timeSeries(xu_trajectory,cfg);
    for i = 1:nXUT
        if (i <= nX*T)
            %position, ypr 
            ind = mod(i,nX);
            if ~(ind == 1 || ind == 3 || ind == 4 || ind == 5 || ind == 6 ...
               || ind == 1+9 || ind == 3+9 || ind == 4+9 || ind == 5+9 || ind == 6+9)
                continue;
            else
                t = ceil(i/nX); xp = [x_traj(:,t); u_traj(:,t)];
                delta(ind) = eps/2;
                yhi = g(xp+delta); ylo = g(xp-delta);
                jach(t,i) = (yhi - ylo)/eps;
                delta(ind) = 0;
            end
        else
            %variations on u_t-1
            j = i-nX*T;
            t = ceil(j/nU);           
            if t ~= 1 %skip the first variations on u_1, they don't affect g_1
                ind = mod(j,nU)+nX; if (ind == 0); ind = nU+nX; end
                delta(ind) = eps/2;
                xp = [x_traj(:,t-1); u_traj(:,t-1)];
                temp_hi = f(xp+delta); temp_lo = f(xp-delta);
                temp = (temp_hi - temp_lo)/eps;
                delta(ind) = 0;
                var_x = jach(t,(t-1)*nX+1:t*nX); %variation on x_t
                jach(t,i) = var_x*temp;
            end
        end
    end
end