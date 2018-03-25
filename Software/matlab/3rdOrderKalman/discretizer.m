%%INIT
clc;
close all;
% haptic_experiment_with_filter;

% N = length(filtered_angPos); % Number of samples
% filtered_angPos1 = filtered_angPos - mean(filtered_angPos); % around zero
% R = 18; %cm

% X_hat=zeros(2,N); % State Estimates

%%%%%%%%% CONTINOUS SYSTEM MODELS

%%%%  Over damped : Cut-off frequency 5.03Hz (31.6 rad/s)
%%%%  x[t] = E^(-50.0*t) * ( 115 * E^(38.7*t) + (-14.5) * E^(-38.7*t) ) cm
k_spring = 100; % N/m
M_mass = 0.1; % kg
b_damper = 2; % N*s/m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Under damped : Cut-off frequency 15.9Hz (100 rad/s)
%%%% x[t] = Exp[-5.00*t]*( 100*Cos[99.9*t] + (5.01)*Sin[99.9*t] ) cm 
% k_spring = 1; % N/cm
% M_mass = 10; % g
% b_damper = 0.001; % N*s/cm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 

A_Cont = [0 1; -k_spring/M_mass -b_damper/M_mass]; % System Model
B_Cont = [0 0 ;k_spring/M_mass b_damper/M_mass]; % Input Model
C_Cont = [1 1];
D_Cont = 0;
Ts = 0.000726;
sys_disc = c2d(ss(A_Cont,B_Cont,C_Cont,D_Cont), 0.000726, 'zoh');
A = sys_disc.A;
B = sys_disc.B;
C = sys_disc.C;
D = sys_disc.D;
% 
% X_hat(:,1) = [100; 0]; % initial position is 100cm
% for k=2:N
%     X_hat(:,k) = A*X_hat(:,k-1) + B*[R*filtered_angPos1(k); R*gyro_angVel(k)];
% end
% 
% figure
% subplot(2,1,1)
% plot(t,X_hat(1,:))
% xlabel("Mass Position(m)")
% title("Mass Position");
% subplot(2,1,2)
% plot(t,X_hat(2,:))
% xlabel("Mass Velocity(m)")
% title("Mass Velocity");
