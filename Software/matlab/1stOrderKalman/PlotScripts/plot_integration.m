global N
global dt
global angPos
global filtered_angPos
global gyro_angVel
global t

integrated_positions = zeros(N,1);

% initial condition is taken from actual position
integrated_positions(1) = angPos(1);
temp_pos = angPos(1);
for i = 2:N
    temp_pos = temp_pos + dt* gyro_angVel(i-1);
    integrated_positions(i) = temp_pos;
end

figure;
% subplot(2,1,1)
plot(t,angPos);
hold on
% subplot(2,1,2)
plot(t,integrated_positions);
ylabel('Angular Position(deg)');
xlabel('Time(ms)');
title('Position');
legend('Measured','Integrated')

% 
% % initial condition is taken from actual position
% integrated_positions(1) = angPos(1);
% temp_pos = angPos(1);
% for i = 2:N
%     temp_pos = temp_pos + dts(i-1) * filtered_angVel(i-1);
%     integrated_positions(i) = temp_pos;
% end
% 
% positionGraph = figure;
% plot(t,angPos);
% ylabel('Measured Angular Position(deg)');
% xlabel('Time(ms)');
% hold on;
% plot(t,integrated_positions);
% ylabel('Integrated Filtered Angular Position(deg)');
% xlabel('Time(ms)');
% title('Position');