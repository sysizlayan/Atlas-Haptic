global N
global dt
global angPos
global filtered_angPos
global gyro_angVel
global t

x_limiting = [2 3];
y_limiting = [100 450];
diff_function = figure;
plot(t(2:end),diff(angPos)./dt)
hold on;
plot(t,gyro_angVel)
xlim([0,14])
ylim([-550 550])
title('Backward Difference from Measurement');

set(diff_function,'PaperPositionMode','auto');         
set(diff_function,'PaperOrientation','landscape');
set(diff_function,'Position',[50 50 1200 800]);
print(diff_function, '-dpdf', strcat('./Figures/',num2str(measurement_number),'/diff_',num2str(measurement_number),'.pdf'))

diff_sized = figure;
plot(t(2:end),diff(angPos)./dt)
hold on;
plot(t,gyro_angVel)
xlim(x_limiting);
ylim(y_limiting);
title('Angular Velocities');
legend('Center Diff w/ measurement','Gyroscope Measuremet');


set(diff_sized,'PaperPositionMode','auto');         
set(diff_sized,'PaperOrientation','landscape');
set(diff_sized,'Position',[50 50 1200 800]);
print(diff_sized, '-dpdf', strcat('./Figures/',num2str(measurement_number),'/diffSized_',num2str(measurement_number),'.pdf'))



center_diff = figure;
plot(t(3:end),(angPos(3:end)-angPos(1:end-2))./(2*dt))
hold on;
% plot(t(3:end),(filtered_angPos(3:end)-filtered_angPos(1:end-2))./(2*dt));
% hold on
plot(t,gyro_angVel)
xlim([0,14])
ylim([-550 550])
title('Angular Velocities');
legend('Center Diff w/ measurement','Gyroscope Measuremet');


set(center_diff,'PaperPositionMode','auto');         
set(center_diff,'PaperOrientation','landscape');
set(center_diff,'Position',[50 50 1200 800]);
print(center_diff, '-dpdf', strcat('./Figures/',num2str(measurement_number),'/centerDiff_',num2str(measurement_number),'.pdf'))



center_diff_sized = figure;
plot(t(3:end),(angPos(3:end)-angPos(1:end-2))./(2*dt))
hold on;
% plot(t(3:end),(filtered_angPos(3:end)-filtered_angPos(1:end-2))./(2*dt));
% hold on
plot(t,gyro_angVel)
xlim(x_limiting);
ylim(y_limiting);
title('Angular Velocities');
legend('Center Diff w/ measurement','Gyroscope Measuremet');


set(center_diff_sized,'PaperPositionMode','auto');         
set(center_diff_sized,'PaperOrientation','landscape');
set(center_diff_sized,'Position',[50 50 1200 800]);
print(center_diff_sized, '-dpdf', strcat('./Figures/',num2str(measurement_number),'/centerDiffSized_',num2str(measurement_number),'.pdf'))

clc