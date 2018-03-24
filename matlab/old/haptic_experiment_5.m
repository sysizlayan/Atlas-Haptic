close all;
clear all;
clc;

%% Data Import
measurement_number = 5; % input('Which measurement do you want to import?');

filename = strcat('./Measurements/measurement_',num2str(measurement_number),'.csv');
display(filename, 'Opened File');

M = csvread(filename);
angPos = M(:,3);
gyro_angVel = M(:,1);
encoder_angVel = M(:,2);
dts = M(:,4)/1e6;

pos1= 891;
pos2= 12980;

angPos = angPos(pos1:pos2);
gyro_angVel = gyro_angVel(pos1:pos2);
encoder_angVel = encoder_angVel(pos1:pos2);
dts = dts(pos1:pos2);


%% Number of samples and time vector
N = length(gyro_angVel);
t = cumsum(dts);
dt = 1e-3;
