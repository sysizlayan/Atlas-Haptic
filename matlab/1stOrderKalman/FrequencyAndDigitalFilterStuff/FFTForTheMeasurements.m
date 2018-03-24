global N
global dt
global angPos
global filtered_angPos
global gyro_angVel
global t

Fs = 1/dt;
Y= fft(diff(angPos)./dt);

P2 = abs(Y/N);
P1 = P2(1:floor(N/2)+1);
P1(2:end-1) = 2*P1(2:end-1);
f_vector= Fs*(0:floor(N/2))/N;
figure
plot(f_vector,P1);
xlabel('Frequency (Hz)');
ylabel('Power Spectrum')
title(strcat('Frequency Power Spectra of Measurement #',num2str(measurement_number)));