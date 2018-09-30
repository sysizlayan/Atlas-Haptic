%Seyit Yiðit SIZLAYAN / 1876861

%%INIT
clc;
close all;

%% Data Import
global N
global dt
global pedal
global t

N = length(angPos); % Number of samples
z = [pedal.position_unfiltered', pedal.velocityFromEncoder'];% Measured signal
x_hat=zeros(2,N); % State Estimates

modelVar = 3e6;
rEncoder = 0.0027;

F = [1 dt; 0 1]; % System Model
B = [dt*dt/2 dt]; % Input Model

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% y[k] = z[k] - H * x_hat_minus

H = [1 0; 0 1]; % Measurement Model

%% Error Covariences
Q = B'*B*modelVar;
R = diag([rEncoder, 3e8]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kalman
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialisation
x_hat(:,1) = z(:,1);
x_hat_plus = x_hat(:,1); %Take first measurement as initial state
P_plus = R; % Starting covarience

for k=2:N
    %% Prediction
    x_hat_minus = F*x_hat_plus; % Model Output
    P_minus = F*P_plus*F' + Q; % Covarience Estimation

    %% Measurement Update
    if(pedal.position_unfiltered(k-1) == pedal.position_unfiltered(k))
        x_hat_plus = x_hat_minus;
        P_plus = P_minus;
    else
        y = H*x_hat_minus; % Measurement Model
        y_err = z(:,k) - y; % error

        K = (P_minus*H')*pinv(H*P_minus*H'+R);

        x_hat_plus = x_hat_minus + K * y_err;
        P_plus = (eye(2)-K*H)*P_minus;
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
plot(t, pedal.velocity) %, t, angVel_fromEncoder )
legend('Kalman Output', 'Measurement Gyro', 'Measurement Encoder')

% angPos = angPostmp;


