global N
global dt
global angPos
global gyro_angVel

NUMBER_OF_TRIALS = 10;
variances = zeros(NUMBER_OF_TRIALS,2);
fvals = zeros(NUMBER_OF_TRIALS,1);

options = optimoptions(@fminunc,'Display','iter');
options.Algorithm = 'quasi-newton';
options.MaxIterations = 1000;
options.MaxFunctionEvaluations = 10000;
options.ObjectiveLimit = 1e-20;
options.StepTolerance= 1e-20;
options.FunctionTolerance = 1e-20;
options.OptimalityTolerance = 1e-20;
% options.UseParallel = true;

for i=1:NUMBER_OF_TRIALS
    modelVar_init = 10^(rand*10);
    r_enc_init = 10^(rand*10);
    optim_init=[modelVar_init,r_enc_init];
    fcn_1(angPos,gyro_angVel,N,dt);
    [variances(i,:),fvals(i)]=fminunc(@costForMLE_firstOrder_unc,optim_init,options);
    disp(i);
end
save(strcat('OptimizedValues\variance_unc_',num2str(NUMBER_OF_TRIALS),'.mat'));





