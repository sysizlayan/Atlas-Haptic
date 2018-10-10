%Seyit Yiðit SIZLAYAN / 1876861

%%INIT
clc;
close all;

%% Data Import
global N
global dt
global pedal

N = length(pedal.position_unfiltered);

z = [pedal.position_unfiltered'; pedal.velocity'];% Measured signals

x_hat=zeros(3,N); % Final state Estimates


%% Linear System Model
% X[n] = A*X[n-1]+B*u[n]
% Y[n] = C*X[n] + D*u[n]

% X = ( Theta[n], 
%       Theta_dot[n], 
%       Theta_dot[n-1])
% Outputs are position, velocity and acceleration
Ts = 0.001; % 1KHz
A = [1      (Ts + 0.5*Ts^2)     -0.5*Ts^2;
     0      1+Ts                -Ts;
     0      1                   0];
 
B = 0;

C = [1      0           0;
     0      1           0;
     0      1/Ts    -1/Ts];
 
D =  0;

% Measurement models
% Encoder and Gyro together
H1 = [1 0 0;
      0 1 0];

% Gyro only
H2 = [0 1 0];

qModel =  1.62414e+07;%[128114800600.2994234];
% q3_3   = 7.65096e+06;%[12808463000.5081312];
rGyro  = 100000;%0.0027*10;%[0.078522264652233];

Q1 = [Ts^4/4 Ts^3/2; Ts^3/2 Ts^2] * qModel;

%Covariance Matrices
Q = [Q1(1,1)    Q1(1,2)       0;
     Q1(2,1)    Q1(2,2)       0;
     0          0           Q1(2,2)];

R = diag([0.0027; rGyro]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kalman
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialisation
x_hat(:,1) = [z(:,1); 0];
x_hat_plus = x_hat(:,1); %Take first measurement as initial state
P_plus = diag([1, 1, 0]); % Starting covarience

for k=2:N
    %% Prediction
    x_hat_minus = A*x_hat_plus; % Model Output
    P_minus = A*P_plus*A' + Q; % Covarience Estimation

    %% Measurement Update
    % Gyro only
    if(pedal.position_unfiltered(k-1) == pedal.position_unfiltered(k))
        y = H2 * x_hat_minus; % output model
        z_now = H2 * z(2,k); % Measurement
        
        y_err = z_now - y; % error
        
        K = (P_minus*H2')*pinv(H2*P_minus*H2'+R(2,2));
        x_hat_plus = x_hat_minus + K * y_err;
        P_plus = (eye(3)-K*H2)*P_minus;
        
    % Encoder measurement has come
    else
        y = H1*x_hat_minus;  % Output Model
        y_err = z(:,k) - y; % error

        K = (P_minus*H1')*pinv(H1*P_minus*H1'+R);

        x_hat_plus = x_hat_minus + K * y_err;
        P_plus = (eye(3)-K*H1)*P_minus;
    end
   
    x_hat(1,k) = x_hat_plus(1);
    x_hat(2,k) = x_hat_plus(2);
    x_hat(3,k) = x_hat_plus(3);
%     x_hat(:,k)=x_hat_plus;
end

filtered_angPos = x_hat(1,:);

filtered_angVel = x_hat(2,:);

filtered_acc = x_hat(3,:);

figure
plot(t(2:N),filtered_angPos(2:N))
title('Angular Position')
hold on
plot(t, pedal.position_unfiltered)
legend('Kalman Output','Measurement')

figure
plot(t(2:N),filtered_angVel(2:N))
title('Angular Velocity')
hold on
plot(t, pedal.velocity)
legend('Kalman Output', 'Measurement Gyro')

figure
plot(t(2:N), filtered_acc(2:N))
title('Accleretation')

