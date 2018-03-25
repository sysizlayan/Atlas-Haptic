if max(size(gcp)) == 0 % parallel pool needed
    parpool % create the parallel pool
end
NUMBER_OF_TRIALS = 4;
variances = zeros(NUMBER_OF_TRIALS,1);
fvals = zeros(NUMBER_OF_TRIALS,1);

options = optimoptions(@fminunc,'Display','iter');
options.Algorithm = 'quasi-newton';
options.MaxIterations = 1000;
options.MaxFunctionEvaluations = 5000;
options.ObjectiveLimit = 0;
options.StepTolerance= 1e-9;
options.FunctionTolerance = 1e-9;
options.OptimalityTolerance = 1e-15;
parfor i=1:NUMBER_OF_TRIALS
    
%     options.UseParallel = true;
    modelVar_init = rand*1e8;

    fcn_1(z,N,dt);
    [variances(i,:),fvals(i)]=fminunc(@costForMLE_4,modelVar_init,options);
    disp(i);
end

save('kalman_v4\variance_unc.mat');



