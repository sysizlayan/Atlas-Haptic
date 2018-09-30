%Seyit Yiðit SIZLAYAN / 1876861

%%INIT
clc;
close all;

%% Data Import
global N
global dt
global angPos
global gyro_angVel
global t

N = length(angPos); % Number of samples

z = [angPos'; gyro_angVel'];% Measured signal
x_hat=zeros(2,N); % State Estimates

qPos_Pos    = 0.001;
qPos_Vel    = 0.001;
qVel_Vel    = 0.001;
 
rEncoder    = 0.0027;
rGyro       = 0.0025;

A = [1+dt -dt; 0 1]; % System Model

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% y[k] = z[k] - H * x_hat_minus

C1 = [1 0; 1/dt -1/dt]; % Measurement Model when encoder has come
C2 = [1/dt -1/dt];

%% Error Covariences
Q = [qPos_Pos, qPos_Vel; qPos_Vel, qVel_Vel];
R = diag([rEncoder, rGyro]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kalman
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialisation
x_hat(:,1) = z(:,1);
x_hat_plus = x_hat(:,1); %Take first measurement as initial state
P_plus = R; % Starting covarience

for k=2:N
    %% Prediction
    x_hat_minus = A*x_hat_plus; % Model Output
    P_minus = A*P_plus*A' + Q; % Covarience Estimation

    %% Measurement Update
    if(angPos(k-1) == angPos(k))
        y = C2 * x_hat_minus; % output model
        gyro_current = z(2,k);
        y_err = gyro_current - y; % error
        K = (P_minus(2,2)*C2')*pinv(C2*P_minus(2,2)*C2'+R(2,2));
        x_hat_plus = x_hat_minus + K * y_err;
        P_plus = (eye(2)-K*C2)*P_minus;
    else
        y = C1*x_hat_minus;  % Output Model
        y_err = z(:,k) - y; % error

        K = (P_minus*C1')*pinv(C1*P_minus*C1'+R);

        x_hat_plus = x_hat_minus + K * y_err;
        P_plus = (eye(2)-K*C1)*P_minus;
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
plot(t,gyro_angVel) %, t, angVel_fromEncoder )
legend('Kalman Output', 'Measurement Gyro', 'Measurement Encoder')

% angPos = angPostmp;


