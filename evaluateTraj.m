function evaluateTraj(sats,x,u,traj_type,fig_num,interval)
% expect x and u to be nX x T

sat1 = sats{1};
sat2 = sats{2};
[nadir_score, point_score] = score_allConstraints(x,u,{sat1 sat2});
[newSat1, newSat2] = repack_to_sat(x,u,{sat1 sat2});
visualizeOrbits({newSat1, newSat2},interval,traj_type);

figure(fig_num)
subplot(2,2,2)
plot([x(4,:)' x(9+4,:)']); title(['Yaw' ' ' traj_type])
subplot(2,2,1)
plot(nadir_score); title(['Nadir Score'  ' ' traj_type])
subplot(2,2,3)
plot(point_score); title(['Point Score' ' ' traj_type])
subplot(2,2,4)
plot([u(1,:)' u(3+1,:)']); title(['Control' ' ' traj_type])

end