% if max(size(gcp)) == 0 % parallel pool needed
%     parpool % create the parallel pool
% end
NUMBER_OF_TRIALS = 1;
variances = zeros(NUMBER_OF_TRIALS,1);
fvals = zeros(NUMBER_OF_TRIALS,1);

options = optimset('Display','iter');
options.MaxIter = 1000;
options.MaxFunEvals = 100000;
options.TolX = 1e-20;
for i=1:NUMBER_OF_TRIALS
    modelVar_init = 10^(rand*10);

    [variances(i),fvals(i)]=fminbnd(@costForMLE_firstOrder_bnd,0,1e10,options);
    disp(i);
end
save(strcat('OptimizedValues\variance_bnd_',num2str(NUMBER_OF_TRIALS),'.mat'));



