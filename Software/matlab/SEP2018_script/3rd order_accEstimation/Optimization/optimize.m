NUMBER_OF_TRIALS = 1;
values = zeros(NUMBER_OF_TRIALS, 1);
fvals = zeros(NUMBER_OF_TRIALS,1);

% options = optimoptions(@fminbnd,'Display','iter');
% options.MaxIterations = 1000;
% options.MaxFunctionEvaluations = 10000;
% options.ObjectiveLimit = 1e-20;
% options.StepTolerance= 1e-20;
% options.FunctionTolerance = 1e-20;
% options.OptimalityTolerance = 1e-20;
% options.UseParallel = true;

options = optimset('Display','iter');
options.MaxIter = 1000;
options.MaxFunEvals = 100000;
options.TolX = 1e-20;

for i=1:NUMBER_OF_TRIALS
    qModel_init = 10^(rand*10);
%     q3_3_init = 10^(rand*10);
%     rGyro_init  = 10^(rand*10);
%     optim_init=[qModel_init, q3_3_init, rGyro_init];
    optim_init = qModel_init;
%     x = fmincon(fun,x0,[],[],[],[],zeros(N,1),inf*ones(N,1))
%     [values(i,:),fvals(i)]=fmincon(@optimizationFunction, optim_init, [], [], [], [],zeros(1,1),inf*ones(1,1), [], options);
    [values(i),fvals(i)]=fminbnd(@optimizationFunction,0,1e12,options);
    disp(i);
    save('trialOnlyCov_1.mat');
end





