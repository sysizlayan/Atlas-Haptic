
% velocityGraph_diff = figure;
% title('Angular Velocity vs Time')
% subplot(2,1,1)
% plot(encoderVelocity);
% ylabel('Angular Velocity(deg/s)');
% xlabel('Time(ms)');
% subplot(2,1,2)
% plot(gyroscopeVelocity);
% ylabel('Angular Velocity(deg/s)');
% xlabel('Time(ms)');
angVel_graph = figure;
subplot(2,1,1)
plot(t, gyro_angVel);
ylabel('Angular Velocity(deg/s)');
xlabel('Time(s)');
title('Angular Velocity vs Time');
subplot(2,1,2)
plot(t, angPos);
ylabel('Angular Position(deg)');
xlabel('Time(s)');
title('Angular Position vs Time');