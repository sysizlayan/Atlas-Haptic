%Seyit Yiðit SIZLAYAN / 1876861

%%INIT
clc;
close all;

x = [angPos(1:N)';gyro_angVel(1:N)']; % Signal

x_hat=zeros(2,N);

K_array = zeros(2, 2, N-1);   %# Creates a 20x10x3 matrix

%% THRUTH MODEL for constan acc
F = [1 dt; 
    0 1]; %system model
B= [dt*dt/2 0;
    0 dt]; % input model

%output model
H = [1 0;
    0 1];

% Noise model
Q = [1e8 0; 
    0 1e10]; % Process noise

R = [4e-5 0; 
    0 50]; % Measurement noise

P_plus=diag([100^2, 1000^2]);

x_hat_plus=x(:,1);
for k=2:N
%     A = [1 dts(k); 0 1]; %system model
%      B= [dts(k)*dts(k)/2 0;
%            0 dts(k)]; % input model
    %% Prediction
    x_hat_minus = F*x_hat_plus; %system model output
    P_minus = F*P_plus*F' + B*Q*B';
    
    %% Measurement Update
    y = H*x_hat_minus;  % output of the system
    y_err = x(:,k) - y; % error of the angle
    
    K = P_minus*H'/(H*P_minus*H'+R);

    K_array(:,:,k) = K;
%     display(K)
    x_hat_plus = x_hat_minus + K * y_err;
    P_plus = (eye(2)-K*H)*P_minus;
    
    
    x_hat(:,k)=x_hat_plus;
end
SSKalmanGain = K_array(:,:,end); % Last element of kalman gain history

filtered_angPos = x_hat(1,:);

filtered_angVel = x_hat(2,:);

figure
plot(t(2:N),filtered_angPos(2:N))
title('Angular Position')
hold on
plot(t,angPos)
legend('Kalman Output','Measurement')

figure
plot(t(2:N),filtered_angVel(2:N))
title('Angular Velocity')
hold on
plot(t,gyro_angVel)
legend('Kalman Output', 'Measurement')