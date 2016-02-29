function sqp_view_progress(xp,cfg,sqp_iter)
% Assuming
% xp = current scp candidate solution
% cfg = simulation params

% Repackage candidate solution to time series form
[x_target, u_target] = repack_to_timeSeries(xp,cfg);

% Compute performance scores
[nadir_score point_score] = score_allConstraints(x_target,u_target,cfg.sats);

figure(cfg.control_handle), clf
subplot(3,2,1)
plot([x_target(4,:)' x_target(4+9,:)']); title(sprintf('Yaw at iter %d',sqp_iter));
legend('sat1','sat2')
subplot(3,2,2)
plot([x_target(3,:)' x_target(3+9,:)']); title(sprintf('Theta at iter %d',sqp_iter));
subplot(3,2,[4 6])
plot(u_target'); title(sprintf('Controls at iter %d',sqp_iter));
legend('1','2','3','4','5','6')           
subplot(3,2,3)
plot(nadir_score); title(sprintf('Nadir Score at iter %d',sqp_iter));
subplot(3,2,5)
plot(point_score); title(sprintf('Pointing Score at iter %d',sqp_iter));
pause(.1)

end