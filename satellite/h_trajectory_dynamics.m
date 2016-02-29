function [hval, jach] = h_trajectory_dynamics(xu_trajectory, cfg)

%xu_traj = [x0 x1 ... xT-1 u0 u1 ... uT-1];

T = cfg.T; nX = cfg.nX; nU = cfg.nU; dt = cfg.dt;
nXUT = (nU+nX)*T;

x_traj = reshape(xu_trajectory(1:T*nX),nX, T);
u_traj = reshape(xu_trajectory(T*nX+1:end), nU, T);

f = cfg.f; %dynamics model x_t_plus_1 = f(x_t, u_t, dt);

%% YOUR CODE HERE

% Compute the T-1 of h_i constraints
hval = zeros(nX*(T-1),1);
for i = 1:T-1
    idx = nX*(i-1)+1;
    hval(idx:idx+nX-1) = x_traj(:,i+1)-f(x_traj(:,i),u_traj(:,i),dt);
end

% Compute the non-zero elements of the gradient
jach = zeros(nX*(T-1),nXUT);
eps = 1e-6;

for t = 1:T-1
    idx = nX*(t-1)+1;
    %Variations on x_t
    for j = 1:nX
        delta = zeros(nX,1);
        delta(j) = .5*eps;
        h_prev = -f(x_traj(:,t)-delta,u_traj(:,t),dt);
        h_next = -f(x_traj(:,t)+delta,u_traj(:,t),dt);
        jach(idx:idx+nX-1,j+nX*(t-1)) = (h_next-h_prev)/eps;
    end
    
    %Variations on x_t+1
    jach(idx:idx+nX-1,1+nX*t:(nX*(t+1))) = eye(nX);
    
    %Variations on u_t
    for j = 1:nU
        delta = zeros(nU,1);
        delta(j) =.5*eps;
        h_prev = -f(x_traj(:,t),u_traj(:,t)-delta,dt);
        h_next = -f(x_traj(:,t),u_traj(:,t)+delta,dt);
        jach(idx:idx+nX-1,j+nX*T+nU*(t-1)) = (h_next-h_prev)/eps;
    end

end

end
