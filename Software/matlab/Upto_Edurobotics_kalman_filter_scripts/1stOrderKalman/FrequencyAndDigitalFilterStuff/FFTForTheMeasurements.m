global N
global dt
global angPos
global filtered_angPos
global gyro_angVel
global t

Fs = 1/dt;
Y= fft(diff(angPos)./dt);
Y1 = fft(gyro_angVel);
P2 = abs(Y1/N);

P1 = P2(1:floor(N/2)+1);
P1(2:end-1) = 2*P1(2:end-1);
f_vector= Fs*(0:floor(N/2))/N;
experiment = figure;
plot(f_vector,P1);
xlabel('Frequency (Hz)');
ylabel('Power Spectrum');
xlim([0,500])
title(strcat('Frequency Power Spectra of Measurement #',num2str(measurement_number)));

set(experiment,'PaperPositionMode','auto');         
set(experiment,'PaperOrientation','landscape');
set(experiment,'Position',[50 50 1200 800]);
print(experiment, '-dpdf', strcat('./Figures/measurement_',num2str(measurement_number),'__fft_gyro.pdf'))

