function [x_tentative, u_tentative] = initTentativeTraj(emitter,receiver)

% This creates a (n_dim x T) tentative trajectory, where the first column is x_init

emitter_traj = emitter.traj;
receiver_traj = receiver.traj;

T = length(emitter_traj.E.t);

% x_init, then rest of trajector so a T+1 vector
x_tentative = [emitter_traj.nondim.rho';
    emitter_traj.nondim.drho';
    emitter_traj.nondim.theta';
    emitter_traj.B.y';
    emitter_traj.B.p';
    emitter_traj.B.r';
    emitter_traj.B.dy';
    emitter_traj.B.dp';
    emitter_traj.B.dr';
    receiver_traj.nondim.rho';
    receiver_traj.nondim.drho';
    receiver_traj.nondim.theta';
    receiver_traj.B.y';
    receiver_traj.B.p';
    receiver_traj.B.r';
    receiver_traj.B.dy';
    receiver_traj.B.dp';
    receiver_traj.B.dr'
%     zeros(1,T-1);
%     zeros(1,T-1);]    ]
    ];
u_tentative = repmat([emitter.M0;receiver.M0],1,T);



end