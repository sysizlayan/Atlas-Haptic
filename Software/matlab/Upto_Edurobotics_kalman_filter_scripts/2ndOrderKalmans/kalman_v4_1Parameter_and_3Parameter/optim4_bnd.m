if max(size(gcp)) == 0 % parallel pool needed
    parpool % create the parallel pool
end
NUMBER_OF_TRIALS = 4;
variances = zeros(NUMBER_OF_TRIALS,1);
fvals = zeros(NUMBER_OF_TRIALS,1);

options = optimset('Display','iter');
options.MaxIter = 1000;
options.MaxFunEvals = 5000;
options.TolX = 1e-15;
parfor i=1:NUMBER_OF_TRIALS
    
%     options.UseParallel = true;
    modelVar_init = rand*1e8;

    fcn_1(z,N,dt);
    [variances(i,:),fvals(i)]=fminbnd(@costForMLE_4,0,1e10,options);
    disp(i);
end

save('kalman_v4\variance_unc.mat');



