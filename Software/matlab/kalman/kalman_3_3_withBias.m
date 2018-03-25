%Seyit Yiðit SIZLAYAN / 1876861

%%INIT
clc;
x = [angPos(1:N)';gyro_angVel(1:N)';ones(1,N)*0.1]; % Signal

%% THRUTH MODEL for constan acc
A = [1 dt 0; 0 1 0; 0 0 1]; %system model
B= [dt*dt/2 0;dt 0;0 1 ]; % input model
%u = gyro_angVel;

%output model
C = [1 0 0;0 1 -1];

% Noise model
Q = [1e3 0;
      0 1e-10];% Process noise

R = [1e-5 0; 
     0 1e-10]; % Output model noise

x_hat=zeros(3,N);

P_plus=diag([75e6, 1e6, 100]);%eye(3)*100;  % large covarience init
x_hat_plus=x(:,1);
K_array = zeros(3, 2, N-1);
for k=2:N
    
    %% Prediction
    A = [1 dts(k-1) 0; 
        0 1 0; 
        0 0 1]; %system model
    B= [dts(k-1)*dts(k-1)/2 0;
        dts(k) 0;
        0 1 ]; % input model

    
    x_hat_minus = A*x_hat_plus;  % system model output
    P_minus = A*P_plus*A' + B*Q*B';  % Covarience prediction
    
    %% Measurement Update
    y = C*x_hat_minus;  % output of the system
    y_err = [x(1,k);x(2,k)] - y; % error of the output
    
    K = P_minus*C'/(C*P_minus*C'+R);  % Kalman gain
    K_array(:,:,k) = K;
    display(K)
    x_hat_plus = x_hat_minus + K * y_err;
    P_plus = (eye(3)-K*C)*P_minus;
    x_hat(:,k)=x_hat_plus;
end
SSKalmanGain = K_array(:,:,end); % Last element of kalman gain history

filtered_angPos = x_hat(1,:);
figure
plot(t(1:N),filtered_angPos);
title('Angular Position')
hold on
plot(t(1:N),angPos(1:N))
legend('Kalman Output','Measurement')

filtered_angVel = x_hat(2,2:end);
figure
plot(t(1:N-1),filtered_angVel);
title('Angular Vel')
hold on
plot(t(1:N),gyro_angVel(1:N))
legend('Kalman Output','Measurement')

gyro_bias = x_hat(3,:);
figure
plot(t(1:N),gyro_bias)
title('Gyro Bias')