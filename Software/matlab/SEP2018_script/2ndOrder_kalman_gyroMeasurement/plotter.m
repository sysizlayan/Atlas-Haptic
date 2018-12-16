fig1 = figure;
plot(t(2:N),filteredState_vectors(1,2:N))
hold on
plot(t(2:N-20),smoothedState_vectors(1,2:N-20))
hold on
plot(t, theta_measurements)
xlim([20.194, 20.28])
ylim([92, 96.5])
set(fig1.CurrentAxes,'TickLabelInterpreter','latex');
set(fig1.CurrentAxes,'FontSize', 16);
leg1 = legend('Kalman Filter','Kalman Smoother', 'Encoder Measurement');
set(leg1, 'Interpreter', 'latex')
set(leg1, 'FontSize', 9)
ylabel('$$\theta (^\circ)$$', 'Interpreter', 'latex');
xlabel('Time (s)', 'Interpreter', 'latex')
title('Angular Position vs Time', 'Interpreter', 'latex')

fig2 = figure;
plot(t(2:N), filteredState_vectors(2,2:N))
hold on
plot(t(2:N-20), smoothedState_vectors(2, 2:N-20))
hold on
plot(t, pedal.velocity)

set(fig2.CurrentAxes,'TickLabelInterpreter','latex');
set(fig2.CurrentAxes,'FontSize', 16);
leg2 = legend('Kalman Filter','Kalman Smoother', 'Gyroscope Measurement');
set(leg2, 'Interpreter', 'latex')
set(leg2, 'FontSize', 9)

ylabel('$$\dot{\theta} (^\circ /s)$$', 'Interpreter', 'latex');
xlabel('Time (s)', 'Interpreter', 'latex')
title('Angular Velocity vs Time', 'Interpreter', 'latex')