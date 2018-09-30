% clc;
% clear all;
haptic_experiment;

N = length(angPos); % Number of samples
% z = [angPos';gyro_angVel']; % Measured signal
angPos = angPos - mean(angPos); % around zero
r = 0.3; %m
xPedal = r*sind(angPos);
xPedalDot = r.*cosd(angPos).*gyro_angVel;


k_spring = 1;
M_mass = 10;
b_damper = 10;

A = [0 1 0; -k_spring/M_mass -b_damper/M_mass k_spring/M_mass; 0 0 0];
B = [0;b_damper/M_mass;1];
C = [1 0 0];
D = 0;
Ts = dt;

pedal_mass_system_Cont = ss(A,B,C,D);
pedal_mass_system_disc = c2d(pedal_mass_system_Cont, Ts, 'zoh');

t = 0:Ts:53536*dt;
% u = 100*sin(1*t);
% u = 

% step(pedal_mass_system_Cont);
y = lsim(pedal_mass_system_disc, xPedalDot, t, [100 0 0]);
figure(1)
plot(t, y)
% hold on
% plot(t, xPedalDot)