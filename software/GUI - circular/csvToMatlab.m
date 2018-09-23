clc
clear all

M = csvread('lastReadData.csv');
t = M(:,1);
t = (t- t(1));
t = t(1000, :);
pedal_theta = M(:, 2);
target_theta = M(:, 3);

pedal_theta = pedal_theta(1000:end);
target_theta = target_theta(1000:end);

pedal_theta_dot = M(:, 4);
target_theta_dot = M(:, 5);

pedal_theta_dot = pedal_theta_dot(1000:end);
target_theta_dot = target_theta_dot(1000:end);

clear M

figure
subplot(2,1,1)
plot(t,pedal_theta);
title("Pedal Angular Position");
ylim([-90,90]);

subplot(2,1,2)
plot(t,pedal_theta_dot);
title("Pedal Angular Velocity");
ylim([-500,500]);


figure
subplot(2,1,1)
plot(t,target_theta);
title("Target Angular Position");
ylim([-90,90]);

subplot(2,1,2)
plot(t,target_theta_dot);
title("Target Angular Velocity");
ylim([-2*pi,2*pi]);