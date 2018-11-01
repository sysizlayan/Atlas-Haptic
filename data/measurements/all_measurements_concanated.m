close all
clear
clc

last_direction = 1;
load('measurement_30_09_2018_sinus_0_3.mat')
trim_to_zeros
disp(last_direction);
t_all = t;
position_unfiltered_all = pedal.position_unfiltered;
velocity_all = pedal.velocity;

load('measurement_30_09_2018_sinus_0_5.mat')
trim_to_zeros
disp(last_direction);
t = t + t_all(end) + dt;
t_all = [t_all;t];
position_unfiltered_all = [position_unfiltered_all;pedal.position_unfiltered];
velocity_all = [velocity_all;pedal.velocity];

load('measurement_30_09_2018_sinus_0_8.mat')
trim_to_zeros
disp(last_direction);
t = t + t_all(end) + dt;
t_all = [t_all;t];
position_unfiltered_all = [position_unfiltered_all;pedal.position_unfiltered];
velocity_all = [velocity_all;pedal.velocity];

load('measurement_30_09_2018_sinus_1_0.mat')
trim_to_zeros
disp(last_direction);
t = t + t_all(end) + dt;
t_all = [t_all;t];
position_unfiltered_all = [position_unfiltered_all;pedal.position_unfiltered];
velocity_all = [velocity_all;pedal.velocity];

load('measurement_30_09_2018_sinus_1_1.mat')
trim_to_zeros
disp(last_direction);
t = t + t_all(end) + dt;
t_all = [t_all;t];
position_unfiltered_all = [position_unfiltered_all;pedal.position_unfiltered];
velocity_all = [velocity_all;pedal.velocity];

load('measurement_30_09_2018_sum_of_sines.mat')
trim_to_zeros
t = t + t_all(end) + dt;
t_all = [t_all;t];
position_unfiltered_all = [position_unfiltered_all;pedal.position_unfiltered];
velocity_all = [velocity_all;pedal.velocity];

close all

t=t_all;
pedal.position_unfiltered = position_unfiltered_all;
pedal.velocity = velocity_all;
N = length(t);

figure
plot(t_all, position_unfiltered_all);

figure
plot(t_all, velocity_all);
