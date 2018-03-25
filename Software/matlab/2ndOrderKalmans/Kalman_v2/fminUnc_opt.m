if max(size(gcp)) == 0 % parallel pool needed
    parpool % create the parallel pool
end
NUMBER_OF_TRIALS = 200;
variances = zeros(NUMBER_OF_TRIALS,5);
fvals = zeros(NUMBER_OF_TRIALS,1);
fval_min = realmax;
minimumCostIndex = 0;
for i=2:NUMBER_OF_TRIALS+1
    options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton','MaxIterations',1000,'MaxFunctionEvaluations',5000,'ObjectiveLimit',1000,'StepTolerance',1e-9,'FunctionTolerance',1e-9,'UseParallel',true);
%     options = optimoptions(@lsqnonlin,'TolX',1e-9);
% options = optimset('Display','iter','PlotFcns',@optimplotfval);

%     q_enc_enc_init = rand*1e-4;
%     q_enc_gyro_init = rand*1e-1;
%     q_gyro_gyro_init = rand*1e-1;
%     
%     r_enc_init = rand*1e-2;
%     r_gyro_init = rand*1e2;
    q_enc_enc_init = 1.91969443157105e-05*rand;
    q_enc_gyro_init = 0.0341279010057076*rand;
    q_gyro_gyro_init = 60.6718240101468*rand;
    
    r_enc_init = 0.00241964233561027*rand;
    r_gyro_init = 61.7644610357888*rand;
    
    result1 = costForMLE([q_enc_enc_init, q_enc_gyro_init, q_gyro_gyro_init, r_enc_init, r_gyro_init]);
    if isreal(result1)
        fcn_1(z,N,dt);
        [variances(i,:),fvals(i)]=fminunc(@costForMLE,[q_enc_enc_init, q_enc_gyro_init, q_gyro_gyro_init, r_enc_init, r_gyro_init],options);
        disp(i);
%     if(fval<fval_min)
%         fval_min=fval;
%         minimumCostIndex = i;
%     end
    else
        i=i-1;
    end
end

save('variance_unc.mat');


