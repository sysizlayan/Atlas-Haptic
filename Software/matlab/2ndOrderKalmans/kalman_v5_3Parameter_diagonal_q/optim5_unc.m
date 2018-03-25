if max(size(gcp)) == 0 % parallel pool needed
    parpool % create the parallel pool
end
NUMBER_OF_TRIALS = ;
variances = zeros(NUMBER_OF_TRIALS,2);
fvals = zeros(NUMBER_OF_TRIALS,1);

options = optimoptions(@fminunc,'Display','iter');
options.Algorithm = 'quasi-newton';
options.MaxIterations = 1000;
options.MaxFunctionEvaluations = 5000;
options.ObjectiveLimit = 0;
options.StepTolerance= 1e-9;
options.FunctionTolerance = 1e-9;
options.OptimalityTolerance = 1e-15;
for i=1:NUMBER_OF_TRIALS
    
%     options.UseParallel = true;
    q_enc_init = rand*1e-3;
    q_gyro_init = rand*1e3;
    q_init = [q_enc_init, q_gyro_init];
    fcn_1(z,N,dt);
    [variances(i,:),fvals(i)]=fminunc(@costForMLE_5,q_init,options);
    disp(i);
end

save('kalman_v5\variance_unc.mat');



