fig1 = figure;
plot(t(2:N),filteredState_vectors(1,2:N))
hold on
plot(t(2:N-20),smoothedState_vectors(1,2:N-20))
hold on
plot(t, theta_measurements)
xlim([20.194, 20.28])
ylim([92, 96.5])
% xlim([20 21])

set(fig1.CurrentAxes,'TickLabelInterpreter','latex');
set(fig1.CurrentAxes,'FontSize', 16);
leg1 = legend('Kalman Filter','Kalman Smoother', 'Encoder Measurement');
set(leg1, 'Interpreter', 'latex')
set(leg1, 'FontSize', 9)
ylabel('$$\theta (^\circ)$$', 'Interpreter', 'latex');
xlabel('Time (s)', 'Interpreter', 'latex')
title('Angular Position vs Time', 'Interpreter', 'latex')

set(fig1, 'PaperPositionMode', 'auto');
set(fig1, 'PaperOrientation','landscape');
set(fig1, 'Position', [50 50 1200 800]);
print(fig1, '-dpdf', './figures/1Hz_2000CPR_theta.pdf','-fillpage');

fig2 = figure;
plot(t(2:N), filteredState_vectors(2,2:N))
hold on
plot(t(2:N-20), smoothedState_vectors(2, 2:N-20))
hold on
plot(t, thetaDot_measurements)
% xlim([20.194, 20.28])
xlim([20, 21])
set(fig2.CurrentAxes,'TickLabelInterpreter','latex');
set(fig2.CurrentAxes,'FontSize', 16);
leg2 = legend('Kalman Filter','Kalman Smoother', 'Gyroscope Measurement');
set(leg2, 'Interpreter', 'latex')
set(leg2, 'FontSize', 9)

ylabel('$$\dot{\theta} (^\circ /s)$$', 'Interpreter', 'latex');
xlabel('Time (s)', 'Interpreter', 'latex')
title('Angular Velocity vs Time', 'Interpreter', 'latex')

set(fig2, 'PaperPositionMode', 'auto');
set(fig2, 'PaperOrientation','landscape');
set(fig2, 'Position', [50 50 1200 800]);
print(fig2, '-dpdf', './figures/1Hz_400CPR_thetaDot.pdf','-fillpage');