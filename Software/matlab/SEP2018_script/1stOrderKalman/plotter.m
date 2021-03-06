fig1 = figure;
plot(t,filteredTheta_values);
hold on
plot(t, smoothedTheta_values);
hold on
plot(t,theta_measurements);
% xlim([20.194, 20.28])
% ylim([92, 96.5])
xlim([20, 21])

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
print(fig1, '-dpdf', './figures/1Hz_2000CPR_full.pdf','-fillpage');