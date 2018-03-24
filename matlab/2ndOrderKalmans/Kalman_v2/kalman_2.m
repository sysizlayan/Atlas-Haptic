%Seyit Yiðit SIZLAYAN / 1876861

%%INIT
clc;
close all;

variance_index = 22; % minimum error index
q_enc_enc=variances(variance_index,1);
q_enc_gyro=variances(variance_index,2);
q_gyro_gyro=variances(variance_index,3);
r_enc=variances(variance_index,4);
r_gyro=variances(variance_index,5);

N = length(angPos); % Number of samples
z = [angPos';gyro_angVel']; % Measured signal
% t_temp = t_s(:,i);
x_hat=zeros(2,N); % State Estimates

K_array = zeros(2, 2, N-1);   %# Creates a 2X2XN tensor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x[k+1] = x[k] + x'[k]*dt + 0.5*acc*(dt)^2 + w
% x'[k+1] = x'[k] + acc*dt
% State X = [x[k];x'[k]];
% X[k+1] = [1 dt; 0 1]*X[k] + [dt^2/2 dt] * acc
% Acc is nomally distributed acceleration
% Measurement 
%

F = [1 dt; 0 1]; % System Model
B = [dt*dt/2 dt]; % Input Model

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% y[k] = z[k] - H * x_hat_minus

H = [1 0; 0 1]; % Measurement Model
% In robot there will be 2 different H matrix
% H1 = [1 0]; -> When position measurement is taken
% H2 = [0 1]; -> When gyrometer measurement is taken

%% Error Covariences
Q = [q_enc_enc, q_enc_gyro;q_enc_gyro,q_gyro_gyro];
R = diag([r_enc, r_gyro]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kalman
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialisation
x_hat(:,1) = z(:,1);
x_hat_plus = x_hat(:,1); %Take first measurement as initial state
P_plus = diag([100^2 200^2]); % Starting covarience

for k=2:N
%     F = [1 dt(k-1); 0 1]; % System Model
%     B = [dt(k-1)*dt(k-1)/2 dt(k-1)]; % Input Model
    %% Prediction
    x_hat_minus = F*x_hat_plus; % Model Output
    P_minus = F*P_plus*F' + Q; % Covarience Estimation

    %% Measurement Update
    y = H*x_hat_minus; % Measurement Model
    y_err = z(:,k) - y; % error

    K = (P_minus*H')*pinv(H*P_minus*H'+R);

    x_hat_plus = x_hat_minus + K * y_err;
    P_plus = (eye(2)-K*H)*P_minus;

    x_hat(:,k)=x_hat_plus;
    K_array(:,:,k) = K;
%     display(K)
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

% angPos = angPostmp;


