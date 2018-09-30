integrated_positions = zeros(N,1);

% initial condition is taken from actual position
integrated_positions(1) = angPos(1);
temp_pos = angPos(1);
for i = 2:N
    temp_pos = temp_pos - dts(i-1) * gyro_angVel(i-1);
    integrated_positions(i) = temp_pos;
end

figure;
subplot(2,1,1)
plot(t,angPos);
ylabel('Measured Angular Position(deg)');
xlabel('Time(ms)');
grid on;
subplot(2,1,2)
plot(t,integrated_positions);
ylabel('Integrated Angular Position(deg)');
xlabel('Time(ms)');
title('Position');
grid on;

% integrated_positions = zeros(N,1);
% gyro_angVel = gyro_angVel - mean(gyro_angVel);
% % initial condition is taken from actual position
% integrated_positions(1) = angPos(1);
% temp_pos = angPos(1);
% for i = 2:N
%     temp_pos = temp_pos - dts(i-1) * gyro_angVel(i-1);
%     integrated_positions(i) = temp_pos;
% end
% 
% figure;
% subplot(2,1,1)
% plot(t,angPos);
% ylabel('Measured Angular Position(deg)');
% xlabel('Time(ms)');
% subplot(2,1,2)
% plot(t,integrated_positions);
% ylabel('Integrated Angular Position(deg)');
% xlabel('Time(ms)');
% title('Position');

% 
% % initial condition is taken from actual position
% integrated_positions(1) = angPos(1);
% temp_pos = angPos(1);
% for i = 2:N
%     temp_pos = temp_pos - (dts(i-1)/1000) * filtered_angVel(i-1);
%     integrated_positions(i) = temp_pos;
% end
% 
% positionGraph = figure;
% subplot(2,1,1)
% plot(t,angPos);
% ylabel('Measured Angular Position(deg)');
% xlabel('Time(ms)');
% subplot(2,1,2)
% plot(t,integrated_positions);
% ylabel('Integrated Filtered Angular Position(deg)');
% xlabel('Time(ms)');
% title('Position');