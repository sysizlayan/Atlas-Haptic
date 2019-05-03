clear
clc
load('firstOrder.mat')
load('secondOrder.mat')
load('secondOrderWithoutGyro.mat')

% 2nd order
diffTheta_2000 = secondOrder.CPR2000.smoothedTheta_values - secondOrder.CPR2000.filteredTheta_values(1:end-1);
second_rmsNoiseTheta_2000 = rms(diffTheta_2000(100:end-100))
second_maxNoiseTheta_2000 = max(diffTheta_2000(100:end-100))

diffTheta_400 = secondOrder.CPR2000.smoothedTheta_values - secondOrder.CPR400.filteredTheta_values(1:end-1);
second_rmsNoiseTheta_400 = rms(diffTheta_400(100:end-100))
second_maxNoiseTheta_400 = max(diffTheta_400(100:end-100))


% 1st order
diffTheta_2000 = secondOrder.CPR2000.smoothedTheta_values - firstOrder.CPR2000.filteredTheta_values(2:end-1);
first_rmsNoiseTheta_2000 = rms(diffTheta_2000(100:end-100))
first_maxNoiseTheta_2000 = max(diffTheta_2000(100:end-100))

diffTheta_400 = secondOrder.CPR2000.smoothedTheta_values - firstOrder.CPR400.filteredTheta_values(2:end-1);
first_rmsNoiseTheta_400 = rms(diffTheta_400(100:end-100))
first_maxNoiseTheta_400 = max(diffTheta_400(100:end-100))


% 2nd order
diffTheta_2000 = secondOrder.CPR2000.smoothedTheta_values - secondOrderWithoutGyro.CPR2000.filteredTheta_values(1:end-1);
rmsNoiseTheta_2000 = rms(diffTheta_2000)
maxNoiseTheta_2000 = max(diffTheta_2000)

diffTheta_400 = secondOrder.CPR2000.smoothedTheta_values - secondOrderWithoutGyro.CPR400.filteredTheta_values(1:end-1);
rmsNoiseTheta_400 = rms(diffTheta_400)
maxNoiseTheta_400 = max(diffTheta_400)

diffDot_2000 = secondOrder.CPR2000.thetaDot_measurements(1:end-1) - secondOrderWithoutGyro.CPR2000.filteredThetaDot_values';
rmsNoiseThetaDot_2000 = rms(diffDot_2000(100:end-100))
maxNoiseThetaDot_2000 = max(diffDot_2000(100:end-100))


diffDot_400 = secondOrder.CPR2000.thetaDot_measurements(1:end-1) - secondOrderWithoutGyro.CPR400.filteredThetaDot_values';
rmsNoiseThetaDot_400 = rms(diffDot_400(100:end))
maxNoiseThetaDot_400 = max(diffDot_400(100:end))