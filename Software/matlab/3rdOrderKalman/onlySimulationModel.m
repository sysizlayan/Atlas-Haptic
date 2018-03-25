%%INIT
clc;
% close all;
haptic_experiment_with_filter;

N = length(filtered_angPos); % Number of samples
% z = [angPos';gyro_angVel']; % Measured signal
filtered_angPos1 = filtered_angPos - mean(filtered_angPos); % around zero
r = 0.3; %m
xPedal = r*sind(filtered_angPos1);
xPedalDot = r.*cosd(filtered_angPos1).*gyro_angVel;

X_hat=zeros(3,N); % State Estimates

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

X_hat(:,1) = [10, 0, xPedal(1)];
for k=2:N
    X_hat(:,k) = A*X_hat(:,k-1) + B*xPedalDot(k)';
end

figure
subplot(4,1,1)
plot(t(2:N),X_hat(1,2:N))
xlabel("Mass Position(m)")
title("Mass Position");
subplot(4,1,2)
plot(t(2:N),X_hat(2,2:N))
xlabel("Mass Velocity(m)")
title("Mass Velocity");
subplot(4,1,3)
plot(t(2:N),X_hat(3,2:N))
xlabel("Pedal Position(m)")
title("Pedal Position");
subplot(4,1,4)
plot(t,xPedal);
xlabel("Calculated pedal position");
ylabel("Time(s)");
title("Calculated pedal position");


figure
subplot(2,1,2)
plot(t,xPedalDot);
title("Pedal Velocity");

subplot(2,1,1)
plot(t,xPedal);
title("Pedal Position");
