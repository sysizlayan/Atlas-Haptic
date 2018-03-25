close all;
clear all;
clc;

%% Data Import
global N
global dt
global angPos
global filtered_angPos
global gyro_angVel
global t

measurement_number = input('Which measurement do you want to import?');
filename = strcat('../Measurements/measurementWithFilter_',num2str(measurement_number),'.csv');
display(filename, 'Opened File');

M = csvread(filename);
t = M(:,1)*1e-6;
angPos = M(:,2);
gyro_angVel = M(:,3);
filtered_angPos = M(:,4);
t = t-t(1);
dt = 1e-3;

%% Number of samples and time vector
N = length(gyro_angVel);

%%Load optimized values
% load variance2.mat
%% Plots
clear M
experiment = figure;
subplot(2,1,1)
plot(t,angPos,t,filtered_angPos)
xlabel('time(s)')
ylabel('\theta(\circ)')
title('Angular Position')
legend('Without Filter','With Filter');
subplot(2,1,2)
plot(t,gyro_angVel)
xlabel('time(s)')
ylabel('$$\dot{\theta} (^\circ /s)$$','Interpreter','latex')
title('Angular Velocity')


set(experiment,'PaperPositionMode','auto');         
set(experiment,'PaperOrientation','landscape');
set(experiment,'Position',[50 50 1200 800]);
print(experiment, '-dpdf', strcat('./Figures/measurement_',num2str(measurement_number),'.pdf'))
