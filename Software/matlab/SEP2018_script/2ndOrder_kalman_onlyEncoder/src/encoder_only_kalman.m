%Seyit Yiðit SIZLAYAN / 1876861

%%INIT
clc;
close all;

%% Data Import
global N
global dt
global pedal
global t

A = [1 dt; 0 1]; % System Model
B = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% y[k] = z[k] - H * x_hat_minus

H1 = eye(2); % Measurement Model when encoder has come

%% Error Covariences
Q = 1e6*eye(2);
R = diag([0.0027, 0.0025]);
for emIterations = 1:1
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kalman
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialisation
% Take first theta value as initial point and assume it is in rest
x_hat(:,1) = [z(1);1e-3]; 
x_hat_plus = x_hat(:,1); %Take first measurement as initial state
P_plus = R; % Starting covarience

lastChangedMeasurement = z(1);
lastChangedMeasurementInstance = 1;
velocityMeasurementVector = zeros(N,1);
velociyMeasurement = 0;
for k=2:N
    %% Prediction
    x_hat_minus = A*x_hat_plus; % Model Output
    P_minus = A*P_plus*A' + Q; % Covarience Estimation

    %% Correction
    if(z(k-1) ~= z(k))
        velocityMeasurement = (z(k) - lastChangedMeasurement) / ...
                              (dt*(k - lastChangedMeasurementInstance));
        lastChangedMeasurement = z(k);
        lastChangedMeasurementInstance = k;
        
        measurementVector = [z(k);velocityMeasurement];
        errorVector = measurementVector - H1 * x_hat_minus;
        
        kalmanGain = P_minus * H1' \ (H1 * P_minus * H1' + R);
        x_hat_plus = x_hat_minus + kalmanGain * errorVector;
        P_plus = (eye(2) - kalmanGain*H1) * P_minus;
    else
        x_hat_plus = x_hat_minus;
        P_plus = P_minus;
    end
    velocityMeasurementVector(k) = velocityMeasurement;
    x_hat(:,k)=x_hat_plus;
end
end
filtered_angPos = x_hat(1,:);

filtered_angVel = x_hat(2,:);

figure
plot(t(2:N),filtered_angPos(2:N))
title('Angular Position')
hold on
plot(t,pedal.position_unfiltered)
legend('Kalman Output','Measurement')

figure
plot(t(2:N),filtered_angVel(2:N))
title('Angular Velocity')
% hold on
% plot(t,pedal.velocity, t, velocityMeasurementVector )
% legend('Kalman Output', 'Measurement Gyro', 'Measurement Encoder')

% angPos = angPostmp;


