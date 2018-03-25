% if max(size(gcp)) == 0 % parallel pool needed
%     parpool % create the parallel pool
% end
variances = zeros(100,3);
fvals = zeros(100,1);
fval_min = realmax;
minimumCostIndex = 0;
for i=1:100
%     options = optimoptions(@fminunc,'Algorithm','quasi-newton','TolX',1e-9,'MaxFunEvals',1000);
%     options = optimoptions(@lsqnonlin,'TolX',1e-9);
    options = optimset('Display','iter','MaxFunEvals',300,'MaxIter',300,'TolFun',1e1,'TolX',1e1);

    q_init = rand*1e3;
    r_enc_init = rand*1e3;
    r_gyro_init = rand*1e3;
%     fcn_1(z,N,dt);
    [variances(i,:),fvals(i)]=fminsearch(@costForMLE,[q_init, r_enc_init,r_gyro_init],options);
    save('variance_search.mat');
%     display(i);
%     if(fval<fval_min)
%         fval_min=fval;
%         minimumCostIndex = i;
%     end
end

% save('variance_search.mat');


