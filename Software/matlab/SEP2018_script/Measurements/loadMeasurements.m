close all;
clear all;
clc;

%% Data Import
global pedal
global target
global t
global dt
global N
global thesisPath

thesisPath = "C:\Users\Yigit\Desktop\workspace\Atlas-Haptic\data\measurement5_1.5hz\";


dt = 1e-3;

filenameSTR = "measurement5_1.5hz";%input('File Name?', 's');
filename = "C:\Users\Yigit\Desktop\workspace\Atlas-Haptic\data\measurement5_1.5hz\lastReadData.csv";
M = csvread(filename);

t                           = M(:,1);
pedal.position_unfiltered   = M(:, 2);
pedal.position_filtered     = M(:, 3);
pedal.velocity              = M(:, 4);

target.position             = M(:, 5);
target.velocity             = M(:, 6);

t = t-t(1);
t = t / 1000;

%% Number of samples and time vector
N = length(pedal.position_unfiltered);
clear M

%%Load optimized values
% load variance2.mat
%% Plots
experiment = figure;
subplot(2,1,1)
plot(t, pedal.position_unfiltered)
xlabel('time(s)')
ylabel('\theta(\circ)')
title('Angular Position')

subplot(2,1,2)
plot(t, pedal.velocity)
xlabel('time(s)')
ylabel('$$\dot{\theta} (^\circ /s)$$','Interpreter','latex')
title('Angular Velocity')

pedal.position_decreased = sampleDecreaser(pedal.position_unfiltered, 2000, 10);

set(experiment,'PaperPositionMode','auto');         
set(experiment,'PaperOrientation','landscape');
set(experiment,'Position',[50 50 1200 800]);
print(experiment, '-dpdf', strcat(thesisPath, 'figure/' , filenameSTR, '.pdf'));

saveas(experiment,strcat(thesisPath, 'figure/' , filenameSTR,'.pdf'),'pdf');
figurePath = strcat(thesisPath, 'figure/');

saveLocation = strcat(thesisPath, 'data/' , filenameSTR,'.mat');
dataPath = strcat(thesisPath, 'data/');

save(saveLocation);
clc
disp(figurePath);