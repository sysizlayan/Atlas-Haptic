if max(size(gcp)) == 0 % parallel pool needed
    parpool % create the parallel pool
end
variances = zeros(25,3);
fvals = zeros(25,1);
fval_min = realmax;
minimumCostIndex = 0;
parfor i=1:25
    options = optimoptions(@fminunc,'Algorithm','quasi-newton','MaxFunEvals',600,'TolX',1e-9,'TolFun',1e-9);
%     options = optimoptions(@lsqnonlin,'TolX',1e-9);
% options = optimset('Display','iter','PlotFcns',@optimplotfval);

    q_init = rand*1e8;
    r_enc_init = rand*1e-3;
    r_gyro_init = rand;
    fcn_1(z,N,dt);
    [variances(i,:),fvals(i)]=fminunc(@costForMLE,[q_init, r_enc_init,r_gyro_init],options);
    display(i);
%     if(fval<fval_min)
%         fval_min=fval;
%         minimumCostIndex = i;
%     end
end

save('variance_unc.mat');


