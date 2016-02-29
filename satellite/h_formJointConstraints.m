function [A, B] = h_formJointConstraints(nX,nU,T,q_min,q_max)

A = zeros(4*T,(nX+nU)*T);

for t = 1:T
    A(4*(t-1)+1:4*t,nX*(t-1)+10:nX*(t-1)+11) = [eye(2);-eye(2)];    
end
B = repmat([q_max;-q_min],T,1);

end