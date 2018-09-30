%Seyit Yiðit SIZLAYAN / 1876861

%%INIT
clc;
x = [angPos(1:N)';ones(1,N)*0]; % Signal
u = gyro_angVel;
%% THRUTH MODEL for constan acc
A = [1 -mean(dt); 0 1]; %system model
B= [mean(dt);0]; % input model

%output model
C = [1 0];

% Noise model
sigma_gyro = 0.05;
Q_angle = 1e-1;%0.001;
Q_gyroBias = 0.0003;

Q = [Q_angle 0; 
    0 Q_gyroBias];
% 
% Q = Q*mean(dt);

R = 0.0027; % Output model noise

x_hat=zeros(2,N);

%P_plus=eye(2)*100000;  % large covarience init
P_plus=diag([100000, 100000]);
x_hat_plus=x(:,1);
K_array = zeros(2, 1, N-1);
for k=2:N
    
    %% Prediction
%     A = [1 -dts(k); 0 1];
%     B= [dts(k);0];
    x_hat_minus = A*x_hat_plus+B*u(k);  % system model output
    P_minus = A*P_plus*A' + Q;  % Covarience prediction
    
    %% Measurement Update
    y = C*x_hat_minus;  % output of the system
    y_err = x(1,k) - y; % error of the angle
    
    K = P_minus*C'/(C*P_minus*C'+R);  % Kalman gain
    K_array(:,:,k) = K;
    display(K)
    x_hat_plus = x_hat_minus + K * y_err;
    P_plus = (eye(2)-K*C)*P_minus;
    
    x_hat(:,k)=x_hat_plus;
end
SSKalmanGain = K_array(:,:,end); % Last element of kalman gain history

filtered_angPos = x_hat(1,:);
figure
plot(t(1:N),filtered_angPos);
hold on
plot(t(1:N),angPos(1:N))
legend('Kalman Output','Measurement')
title('Angular Position')

gyro_bias = x_hat(2,:);
figure
plot(t(1:N),gyro_bias)
title('Gyro Bias')

filtered_angVel = gyro_angVel - gyro_bias';