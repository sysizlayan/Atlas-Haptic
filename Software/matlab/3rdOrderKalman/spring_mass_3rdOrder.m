%Seyit Yiðit SIZLAYAN / 1876861

%%INIT
clc;
% close all;
haptic_experiment;

N = length(angPos); % Number of samples
% z = [angPos';gyro_angVel']; % Measured signal
angPos = angPos - mean(angPos); % around zero
r = 0.3; %m
xPedal = r*sind(angPos);
xPedalDot = r.*cosd(angPos).*gyro_angVel;

X_hat=zeros(3,N); % State Estimates

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x[k+1] = x[k] + x'[k]*dt + 0.5*acc*(dt)^2 + w
% x'[k+1] = x'[k] + acc*dt
% State X = [x[k];x'[k]];
% X[k+1] = [1 dt; 0 1]*X[k] + [dt^2/2 dt] * acc
% Acc is nomally distributed acceleration
% Measurement 
%

k_spring = 10;
M_mass = 100;
b_damper = 100;

A_Cont = [0 1 0; -k_spring/M_mass -b_damper/M_mass k_spring/M_mass; 0 0 0]; % System Model
B_Cont = [0;b_damper/M_mass;1]; % Input Model
C_Cont = [1 0 0];
D_Cont = 0;
Ts = dt;
sys_disc = c2d(ss(A_Cont,B_Cont,C_Cont,D_Cont), Ts,'zoh');
A = sys_disc.A;
B = sys_disc.B;
C = sys_disc.C;
D = sys_disc.D;
H = [0 0 1];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% y[k] = z[k] - H * x_hat_minus
% H = [1 0 0; 0 1 0]; % Measurement Model

%% Error Covariences
% [0.000389505033597700 0.0811968722941481 46.4451692700302 0.00213268728414804 11.5413083199588]
% modelVar = 10^-1
% Q = B'*B*modelVar
Q = diag([1e-1, 1e-1, 0.000557541965438186])
R = diag([0, 0, 0.0027])
% R = diag([0.0024, 0.0093]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kalman
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialisation
X_hat(:,1) = [100, 0, xPedal(1)];
X_hat_plus = X_hat(:,1); %Take first measurement as initial state
P_plus = R; % Starting covarience
previous_encoder = angPos(1);

for k=2:N
    %% Prediction
    X_hat_minus = A*X_hat_plus + B*xPedalDot(k)'; % Model Output
    P_minus = A*P_plus*A' + Q; % Covarience Estimation
    
    if(xPedal(k-1) ~= xPedal(k))
        y = H*X_hat_minus; % Measurement Model
        y_err = xPedal(k) - y; % error

        K = (P_minus*H')*pinv(H*P_minus*H'+R(3,3));

        X_hat_plus = X_hat_minus + K * y_err;
        P_plus = (eye(3)-K*H)*P_minus;
    else
        X_hat_plus = X_hat_minus;
        P_plus = P_minus;
    end
    X_hat(:,k)=X_hat_plus;
end
t_Lsim = 0:dt:(N-1)*dt;
lsimResult = lsim(sys_disc, xPedalDot, t_Lsim, [100 0 0]);

filtered_xMass = X_hat(1,:);
filtered_xMassDot = X_hat(2,:);
filtered_xPedal = X_hat(3,:);

figure
plot(t(2:N),filtered_xMass(2:N))
title('Mass Position (Kalman)')

figure
plot(t_Lsim, lsimResult);
title('Mass Position (Lsim)')

figure
plot(t(2:N),filtered_xMassDot(2:N))
title('Mass Velocity')

figure
plot(t(2:N),filtered_xPedal(2:N));
hold on
plot(t(2:N),xPedal(2:N));
title('Pedal Position')

figure
plot(t(2:N),xPedalDot(2:N));
title('Pedal Velocity');


