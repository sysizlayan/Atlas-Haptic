%Seyit Yiðit SIZLAYAN / 1876861

%%INIT
clc;
close all;

N = length(angPos); % Number of samples
z = [angPos';gyro_angVel']; % Measured signal
% t_temp = t_s(:,i);
x_hat=zeros(2,N); % State Estimates
K_array = zeros(2, 2, N-1);   %# Creates a 2X2XN tensor

[minVal, I] = min(fvals)
variance = variances(I,:);
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
H1 = [1 0]; %-> When position measurement is taken
H2 = [0 1]; %-> When gyrometer measurement is taken

%% Error Covariences
% [0.000389505033597700 0.0811968722941481 46.4451692700302 0.00213268728414804 11.5413083199588]
modelVar = variance(1)
Q = B'*B*modelVar
R = diag([variance(2),variance(3)])
% R = diag([0.0024, 0.0093]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kalman
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialisation
x_hat(:,1) = z(:,1);
x_hat_plus = x_hat(:,1); %Take first measurement as initial state
P_plus = R;%diag([100^2 200^2]); % Starting covarience
previous_encoder = angPos(1);

for k=2:N
    %% Prediction
    
    x_hat_minus = F*x_hat_plus; % Model Output
    P_minus = F*P_plus*F' + Q; % Covarience Estimation
%     debugg = [z(1,k-1),z(1,k), k];
%     disp(debugg)

    if(z(1,k-1) ~= z(1,k)) % If the position did not change
        H_current = H;
        
        %% Measurement Update
        y = H_current*x_hat_minus; % Measurement Model
        y_err = z(:,k) - y; % error

        K = (P_minus*H_current')*pinv(H_current*P_minus*H_current'+R);

        x_hat_plus = x_hat_minus + K * y_err;
        P_plus = (eye(2)-K*H_current)*P_minus;
    else
        H_current = H2; 

        %% Measurement Update
        y = H_current*x_hat_minus; % Measurement Model
        y_err = z(2,k) - y; % error

        K = (P_minus*H_current')*pinv(H_current*P_minus*H_current'+H_current*R*H_current');

        x_hat_plus = x_hat_minus + K * y_err;
        P_plus = (eye(2)-K*H_current)*P_minus;
    end
    x_hat(:,k)=x_hat_plus;
end

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


