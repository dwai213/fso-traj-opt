function [nadir_score point_score] = score_allConstraints(x, u, sats)

nadir_score = score_nadir(x,u,sats);
% point_score = score_pointing(x,u,sats);
point_score = zeros(size(nadir_score));


end