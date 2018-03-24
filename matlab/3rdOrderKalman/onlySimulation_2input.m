%%INIT
clc;
% close all;
haptic_experiment_with_filter;

N = length(filtered_angPos); % Number of samples
% z = [angPos';gyro_angVel']; % Measured signal
filtered_angPos1 = filtered_angPos - mean(filtered_angPos); % around zero
% r = 0.3; %m
% xPedal = r*sind(filtered_angPos1);
% xPedalDot = r.*cosd(filtered_angPos1).*gyro_angVel;

X_hat=zeros(2,N); % State Estimates

k_spring = 100000;
M_mass = 10000;
b_damper = 0;

A_Cont = [0 1; -k_spring/M_mass -b_damper/M_mass]; % System Model
B_Cont = [0 0 ;k_spring/M_mass b_damper/M_mass]; % Input Model
C_Cont = [1 1];
D_Cont = 0;
Ts = dt;
sys_disc = c2d(ss(A_Cont,B_Cont,C_Cont,D_Cont), Ts,'zoh');
A = sys_disc.A;
B = sys_disc.B;
C = sys_disc.C;
D = sys_disc.D;

X_hat(:,1) = [10; 0];
for k=2:N
    X_hat(:,k) = A*X_hat(:,k-1) + B*[angPos(k); gyro_angVel(k)];
end

figure
subplot(2,1,1)
plot(t,X_hat(1,:))
xlabel("Mass Position(m)")
title("Mass Position");
subplot(2,1,2)
plot(t,X_hat(2,:))
xlabel("Mass Velocity(m)")
title("Mass Velocity");
