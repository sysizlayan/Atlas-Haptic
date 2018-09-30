close all;
clear all;
clc;

%% Data Import
measurement_number = 4; % input('Which measurement do you want to import?');

filename = strcat('./Measurements/measurement_',num2str(measurement_number),'.csv');
display(filename, 'Opened File');

M = csvread(filename);
angPos = M(:,2);
angPos = angPos - angPos(1);
gyro_angVel = M(:,1);
dts = M(:,3)/1e6;

%% Number of samples and time vector
N = length(gyro_angVel);
t = cumsum(dts);
dt = 1e-3;
