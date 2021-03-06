if max(size(gcp)) == 0 % parallel pool needed
    parpool % create the parallel pool
end
NUMBER_OF_TRIALS = 100;
variances = zeros(NUMBER_OF_TRIALS,5);
fvals = zeros(NUMBER_OF_TRIALS,1);
fval_min = realmax;

minimumCostIndex = 0;
for i=2:NUMBER_OF_TRIALS+1
    options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton','MaxIterations',1000,'MaxFunctionEvaluations',5000,'ObjectiveLimit',1000,'StepTolerance',1e-9,'FunctionTolerance',1e-9);%,'UseParallel',true);
%     options = optimoptions(@lsqnonlin,'TolX',1e-9);
% options = optimset('Display','iter','PlotFcns',@optimplotfval);

%     q_enc_enc_init = rand*1e-4;
%     q_enc_gyro_init = rand*1e-1;
%     q_gyro_gyro_init = rand*1e-1;
%     
%     r_enc_init = rand*1e-2;
%     r_gyro_init = rand*1e2;
    q_enc_enc_init = rand;
    q_enc_gyro_init = rand;
    q_gyro_gyro_init = rand;
    
    r_enc_init = rand;
    r_gyro_init = rand;
    
    result1 = costForMLE_3([q_enc_enc_init, q_enc_gyro_init, q_gyro_gyro_init, r_enc_init, r_gyro_init]);
    if isreal(result1)
        fcn_1(z,N,dt);
        [variances(i-1,:),fvals(i-1)]=fminunc(@costForMLE_3,[q_enc_enc_init, q_enc_gyro_init, q_gyro_gyro_init, r_enc_init, r_gyro_init],options);
        disp(i);
%     if(fval<fval_min)
%         fval_min=fval;
%         minimumCostIndex = i;
%     end
    else
        i=i-1;
    end
    save('kalman_v3\variance_unc.mat');
end




