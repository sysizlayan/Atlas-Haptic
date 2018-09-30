global N
global dt
global angPos
global filtered_angPos
global gyro_angVel
global t
Fs = 1/dt;
[bButter,aButter] = butter(2,20*pi/Fs);
[bFIR,aFIR] = fir1(10,20*pi/Fs);
filteredDifferenceButter = filter(bButter,aButter,diff(angPos)./dt);
filteredDifferenceFIR = filter(bFIR,aFIR,diff(angPos)./dt);
filterOut = figure;
% plot(t(2:end),filteredDifferenceButter)
% hold on
plot(t,gyro_angVel)
hold on
plot(t(2:end),filteredDifferenceButter);
xlim([2,3])
ylim([100,450])
legend('20 Hz Kesme Frekanslý Butterworth Filtresi','Jiroskop Ölçümü');%,'FIR filtered Difference');
xlabel('Zaman(s)');
ylabel('$$\dot{\theta} (^\circ /s)$$','Interpreter','latex');
title('Filtrelenmiþ Geriye Dönük Hýz Kestirimi ve Jiroskop Karþýlaþtýrmasý');
set(filterOut,'PaperPositionMode','auto');         
set(filterOut,'PaperOrientation','landscape');
set(filterOut,'Position',[50 50 1200 800]);
print(filterOut, '-dpdf', strcat('butter.pdf'))

