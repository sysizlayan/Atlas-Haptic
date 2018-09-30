close all;
% clear all;
clc;

%% Data Import

global z
global N
global dt
global u
global angPos
global gyro_angVel
global t

measurement_number = input('Which measurement do you want to import?');
filename = strcat('../Measurements/measurement_',num2str(measurement_number),'.csv');
display(filename, 'Opened File');

M = csvread(filename);

t = M(:,1)*1e-6;
angPos = M(:,2);
gyro_angVel = M(:,3);
t = t-t(1);
dt = 9/8000;
z = [angPos';gyro_angVel'];
u = gyro_angVel';
% dt = t(2:end)-t(1:end-1);
% dt = mode(dt);

%% Number of samples and time vector
N = length(gyro_angVel);

%%Load optimized values
% load variance2.mat
%% Plots
clear M
figure
subplot(2,1,1)
plot(t,angPos)
xlabel('time(s)')
ylabel('\theta(\circ)')
title('Angular Position')

subplot(2,1,2)
plot(t,gyro_angVel)
xlabel('time(s)')
ylabel('$$\dot{\theta} (^\circ /s)$$','Interpreter','latex')
title('Angular Velocity')

% 
% angPoses = angPos(1:NUMBER_OF_SAMPLES);
% gyroVels = gyro_angVel(1:NUMBER_OF_SAMPLES);
% t_s = t(1:NUMBER_OF_SAMPLES);
% 
% for i=0:NUMBER_OF_SAMPLES:floor(N/NUMBER_OF_SAMPLES)*NUMBER_OF_SAMPLES-1
%     angPoses=[angPoses,angPos(i+1:i+NUMBER_OF_SAMPLES)];
%     gyroVels=[gyroVels,gyro_angVel(i+1:i+NUMBER_OF_SAMPLES)];
%     t_s=[t_s,t(i+1:i+NUMBER_OF_SAMPLES)];
% end
% for i=1:floor(N/NUMBER_OF_SAMPLES)
%     figure;
%     subplot(2,1,1)
%     plot(t_s(:,i),angPoses(:,i))
%     subplot(2,1,2)
%     plot(t_s(:,i),gyroVels(:,i))
%     hold on;
%     plot(t_s(2:end,i), diff(angPoses(:,2))./t_s(2:end,i));
% end