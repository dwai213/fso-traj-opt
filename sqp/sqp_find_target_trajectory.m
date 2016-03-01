function [x_target, u_target] = sqp_find_target_trajectory(f, x_tentative, u_tentative, u_min, u_max, q_min, q_max,sats)

x_init = x_tentative(:,1);
u_init = u_tentative(:,1);
nX = length(x_init);
nU = length(u_min);
T = size(x_tentative,2);
nXUT = (nX+nU)*T;


user_cfg = struct();
user_cfg.control_handle = figure(10);
user_cfg.sats= sats;
user_cfg.nX = nX;
user_cfg.nU = nU;
user_cfg.T = T;
user_cfg.improve_ratio_threshold = .5;
user_cfg.min_approx_improve = 1e-1;
user_cfg.min_trust_box_size = 1e-3;
user_cfg.full_hessian = true;
user_cfg.g_use_numerical = false;
user_cfg.h_use_numerical = false; %%for speed, you'll want to be provide an implementation of the gradient computation for h 
user_cfg.initial_trust_box_size = 1;
user_cfg.max_merit_coeff_increases = 3;
user_cfg.initial_penalty_coeff = 100;

traj_dynamics_cfg = struct();
traj_dynamics_cfg.nX = nX;
traj_dynamics_cfg.nU = nU;
traj_dynamics_cfg.T = T;
traj_dynamics_cfg.f = f;
traj_dynamics_cfg.dt = sats{1}.dT;

%% YOUR CODE HERE

x0 = [reshape(x_tentative,nX*T,1); reshape(u_tentative,nU*T,1)];

q = -2*x0';
Q = diag([ones(1,nX*T) ones(1,nU*T)]); % eye(nXUT);
Q = 2*Q; %in anticipation of the .5 implicitly defined in penalty

% linear objective function    
f0 = @(x) 0;

%control bounds ineq constraint
A_ineq = [zeros(2*nU*T,nX*T) [eye(nU*T); -eye(nU*T)]];
b_ineq = [repmat(u_max,T,1); repmat(-u_min,T,1)];

% %joint ineq constraints
% [A, B] = h_formJointConstraints(nX,nU,T,q_min,q_max);
% A_ineq = [A_ineq;A];
% b_ineq = [b_ineq;B];

%x_init; u_init equality constraint
A_eq = [eye(nX) zeros(nX,nXUT-nX)];
b_eq = x_init;
%u_init

if (~user_cfg.g_use_numerical)
    %Use this function to precompute the more efficient jach
    %check if numerical and precomputed results are the same
    g = @(x) g_allConstraintsJach(x,traj_dynamics_cfg,sats);
else
    % g = @(x) g_nadirConstraint(x,traj_dynamics_cfg,sats);
end

%nonlinear equality constraint for dynamics
h = @(x) h_trajectory_dynamics(x, traj_dynamics_cfg); %YOURS TO IMPLEMENT

[xu_trajectory, success] = sqp_penalty(x0, Q, q, f0, A_ineq, b_ineq, A_eq, b_eq, g, h, user_cfg);

% assuming your xu_trajectory has first all states and then all control
% inputs, code below will get back out x_target and u_target in desired
% format
fprintf('Finished Trajectory Feasibility Optimization\n');
fprintf('Success? : %d\n\n',success);
x_target = reshape(xu_trajectory(1:T*nX),nX, T);
u_target = reshape(xu_trajectory(T*nX+1:end), nU, T);
