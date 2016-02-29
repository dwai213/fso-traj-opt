function score = score_nadir(x_tentative,u_tentative,sats)

    [nX,T] = size(x_tentative);
    nU = size(u_tentative,1);
    cfg.nX = nX;    cfg.nU = nU;    cfg.T = T;
    xp = [reshape(x_tentative,nX*T,1); reshape(u_tentative,nU*T,1)];
    scores = g_nadirConstraint(xp,cfg,sats);
    
    score = [scores(1:2:(2*T)) scores(2:2:(2*T))];
end