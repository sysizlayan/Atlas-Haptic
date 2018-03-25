
figure
plot(t(2:end),diff(angPos)./dt)
hold on;
plot(t,gyro_angVel)
title('Measured diff Difference');


figure
plot(t(3:end),(angPos(3:end)-angPos(1:end-2))./(2*dt))
hold on;
plot(t,gyro_angVel)
title('Measured center Difference');

% figure
% plot(t(2:end),diff(filtered_angPos)./dt,t,gyro_angVel);
% title('Filtered Difference');