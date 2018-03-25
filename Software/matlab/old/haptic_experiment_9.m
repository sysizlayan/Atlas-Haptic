close all;
clear all;
clc;

%% Data Import
measurement_number = 9; % input('Which measurement do you want to import?');

filename = strcat('./Measurements/measurement_',num2str(measurement_number),'.csv');
display(filename, 'Opened File');

M = csvread(filename);
angPos = M(:,2)/1000;
gyro_angVel = M(:,1)/1000;
dts = M(:,3)/1e6;
dt_gyro = dts(1); % Only one delta t

%% Number of samples and time vector
N = length(gyro_angVel);
dt = 1e-3;
t = 0:dt:dt*(N-1);
