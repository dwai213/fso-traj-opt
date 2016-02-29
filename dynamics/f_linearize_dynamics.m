function [A, B, c] = f_linearize_dynamics(f, x_ref, u_ref, dt, my_eps, x_ref_tplus1)

% meaning: x(:,t+1) - x_ref_tplus1  to-first-order-equal-to A*( x(:,t)-x_ref ) + B* ( u(:,t) - u_ref ) + c
%  if we pick an equilibrium x_ref and u_ref, then x_ref = f(x_ref, u_ref),
%  and c == 0, and x_ref_tplus1 = x_ref and per check below does not need
%  to be passed in; for question 1 this is the case, but for later
%  questions you'll also need x_ref_tplus1 (when trajectory stabilizing
%  with LQ control)

if(nargin == 6)
	c = f(x_ref,u_ref,dt) - x_ref_tplus1;
else
	c = 0;
end

n_states = length(x_ref);
n_inputs = length(u_ref);
A = zeros(n_states);
B = zeros(n_states,n_inputs);

for i = 1:n_states
    %A
    for j = 1:n_states
        delta = zeros(n_states,1);
        delta(j) = .5*my_eps;
        F_prev = f(x_ref-delta,u_ref,dt);
        F_next = f(x_ref+delta,u_ref,dt);
        A(i,j) = (F_next(i)-F_prev(i))/my_eps;             
    end
    
    %B
    for j = 1:n_inputs
        delta = zeros(n_inputs,1);
        delta(j) = .5*my_eps;     
        F_prev = f(x_ref,u_ref-delta,dt);
        F_next = f(x_ref,u_ref+delta,dt);
        B(i,j) = (F_next(i)-F_prev(i))/my_eps;
    end
end