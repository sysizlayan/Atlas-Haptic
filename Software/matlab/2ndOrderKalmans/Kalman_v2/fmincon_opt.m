if max(size(gcp)) == 0 % parallel pool needed
    parpool % create the parallel pool
end
NUMBER_OF_TRIALS = 1;
variances = zeros(NUMBER_OF_TRIALS,5);
fvals = zeros(NUMBER_OF_TRIALS,1);
fval_min = realmax;
minimumCostIndex = 0;
for i=1:NUMBER_OF_TRIALS
%     options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton','MaxFunEvals',600,'TolX',1e-9,'TolFun',1e-9);
%     options = optimoptions(@lsqnonlin,'TolX',1e-9);
% options = optimset('Display','iter','PlotFcns',@optimplotfval);
    options = optimoptions(@fmincon,'Display','iter');%,'Algorithm','quasi-newton','MaxFunEvals',600,'TolX',1e-9,'TolFun',1e-9);

%     q_enc_enc_init = rand*1e-4;
%     q_enc_gyro_init = rand*1e-1;
%     q_gyro_gyro_init = rand*1e-1;
%     
%     r_enc_init = rand*1e-2;
%     r_gyro_init = rand*1e2;
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    lb=[0,0,0,0,0];
    ub = [];
    nonlcon = [];
    
    q_enc_enc_init = 1.91969443157105e-05;
    q_enc_gyro_init = 0.0341279010057076;
    q_gyro_gyro_init = 60.6718240101468;
    
    r_enc_init = 0.00241964233561027;
    r_gyro_init = 61.7644610357888;
    
    fcn_1(z,N,dt);
    [variances(i,:),fvals(i)]=fmincon(@costForMLE,[q_enc_enc_init, q_enc_gyro_init, q_gyro_gyro_init, r_enc_init, r_gyro_init],A,b,Aeq,beq,lb,ub,nonlcon,options);
    disp(i);
%     if(fval<fval_min)
%         fval_min=fval;
%         minimumCostIndex = i;
%     end
end

save('variance_unc_kasa.mat');


