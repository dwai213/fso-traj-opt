function [K, A, B] = tvLQR(f,x_target,u_target,Q,R,dt)
T = size(u_target,2);
K = cell(T-1,1);
A = cell(T-1,1);
B = cell(T-1,1);
P = cell(T-1,1);
P{T-1} = Q;

for t = (T-1):-1:1
    x_opt = x_target(:,t);
    x_opt_next = x_target(:,t+1);
    u_opt = u_target(:,t);
    [A_nom, B_nom, c ] = f_linearize_dynamics(f,x_opt,u_opt,dt,1e-8,x_opt_next);
    A{t} = [A_nom c; zeros(1,size(A_nom,2)) 1];
    B{t} = [B_nom; zeros(1,size(B_nom,2))];

    K{t} = -(R+B{t}'*P{t}*B{t})^-1*B{t}'*P{t}*A{t};
    if t > 1
        P{t-1} = Q + K{t}'*R*K{t} + (A{t}+B{t}*K{t})'*P{t}*(A{t}+B{t}*K{t});    
    end
end
fprintf('Done computing LQR\n');