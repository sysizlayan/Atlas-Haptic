%Seyit Yiðit SIZLAYAN / 1876861

%%INIT
clc;
close all;
clear
load('measurement_30_09_2018_sinus_1_0.mat')
clear;
load('QOptimized_RfromDataSheet.mat'); % Add gryo input model
Gyro_Kalman
clc;
close all;

%% Data Import
global N
global dt
global pedal
global t

pedal.groundTruthTheta = smoothedState_vectors(1,:);

A = [1 dt; 0 1]; % System Model
B = [dt^2/2; dt];

H1 = eye(2); % Measurement Model when encoder has come

% Measurements
theta_measurements = sampleDecreaser(400);
velocityCalculator %% Just to get thetaDot measurements initially

%% Error Covariences
processVariance = var(diff(thetaDot_measurements)/dt);%(0.18/dt)^2/dt;
Q = [dt^3/3, dt^2/2 ; dt^2/2, dt] * processVariance;

encoderVariance = var(pedal.velocity - thetaDot_measurements);
R = diag([0.9^2/12 encoderVariance]);

for emIterations = 1:2
    display(emIterations);
    %State vectors
    predictedState_vectors = zeros(2,N);
    filteredState_vectors = zeros(2,N);
    
    %Store the kalman gains, predicted and filtered covariance matrices
    kalmanGain_matrices = zeros(2,2,N);
    filteredCovariance_matrices = zeros(2,2,N);
    predictedCovariance_matrices = zeros(2,2,N);
    
    predictionError_vectors = zeros(2,N);
    
    %Initialization
    filteredCovariance_matrix = R;
    predictedCovariance_matrix = R;
    
    filteredCovariance_matrices(:,:,1) = R;
    predictedCovariance_matrices(:,:,1) = R;
    
    % Initial position is measured value, velocity is a small number
    % To prevent numerical instability
    thetaDot_measurements = zeros(N, 1);
    thetaDot_measurements(1) = (theta_measurements(2)-theta_measurements(1))/dt;
    filteredState = [theta_measurements(1); thetaDot_measurements(1)];
    filteredState_vectors(:, 1) = filteredState;
    
    lastChangedMeasurement = theta_measurements(1);
    lastChangedMeasurementInstance = 1;
    
    kalmanGain = 0;
    velocityMeasurement = 0;
    for k=2:N
        
        %% Prediction
        predictedState = A * filteredState;
        predictedCovariance_matrix = A*filteredCovariance_matrix*A' + Q; % Covarience Estimation

        %% Correction
        if(theta_measurements(k-1) ~= theta_measurements(k))
            velocityMeasurement = (theta_measurements(k) - lastChangedMeasurement) / ...
                                  (dt*(k - lastChangedMeasurementInstance));
            lastChangedMeasurement = theta_measurements(k);
            lastChangedMeasurementInstance = k;

            measurementVector = [theta_measurements(k);velocityMeasurement];
            errorVector = measurementVector - (H1 * predictedState);

            kalmanGain = predictedCovariance_matrix * H1' * pinv(H1 * predictedCovariance_matrix * H1' + R);

            filteredState = predictedState + kalmanGain * errorVector;
            filteredCovariance_matrix = (eye(2) - kalmanGain*H1) * predictedCovariance_matrix;
        else
            filteredState = predictedState;
            filteredCovariance_matrix = predictedCovariance_matrix;
        end
        thetaDot_measurements(k)    = velocityMeasurement;
        filteredState_vectors(:,k)  = filteredState;
        predictedState_vectors(:,k) = predictedState;
        kalmanGain_matrices(:,:,k)  = kalmanGain;
        filteredCovariance_matrices(:,:,k)  = filteredCovariance_matrix;
        predictedCovariance_matrices(:,:,k) = predictedCovariance_matrix;
        
%         if(predictedCovariance_matrix(1,1) < 0 || predictedCovariance_matrix(1,2) < 0 ||predictedCovariance_matrix(2,1) < 0 || predictedCovariance_matrix(2,2) < 0)
%             display(predictedCovariance_matrix);
%         end
%         if(filteredCovariance_matrix(1,1) < 0 || filteredCovariance_matrix(1,2) < 0 ||filteredCovariance_matrix(2,1) < 0 || filteredCovariance_matrix(2,2) < 0)
%             display(predictedCovariance_matrix);
%         end
    end % End of forward kalman loop
    
    %Kalman Smoother
    smoothedState_vectors = zeros(2,N);
    smoothedState_vectors(:, end) = filteredState_vectors(:,end);
    
    smoothedState = filteredState_vectors(:,end);
    
    smoothedCovariance_matrices = zeros(2,2,N);
    smoothedCovariance_matrices(:,:,end) = ...
        filteredCovariance_matrices(:,:,end);
    
    smoothedCovariance = filteredCovariance_matrices(:,:,end);
    
    smoothedGain_matrices = zeros(2,2,N-1);
    for k=N-1:-1:1
        smoothingGain = filteredCovariance_matrices(:,:,k) * ...
            A' * pinv(predictedCovariance_matrices(:,:,k+1));
        smoothedState = filteredState_vectors(:, k) + ...
                        smoothingGain * ...
                        (smoothedState - predictedState_vectors(:, k+1));
        smoothedCovariance = filteredCovariance_matrices(:,:,k) + ...
                             smoothingGain * ...
                             (smoothedCovariance - predictedCovariance_matrices(:,:,k+1)) * ...
                             smoothingGain';
                         
        smoothedCovariance_matrices(:,:,k) = smoothedCovariance;
        smoothedState_vectors(:,k) = smoothedState;
        smoothedGain_matrices(:,:,k) = smoothingGain;
    end % End of smoother loop
    sumQ = zeros(2,2);
    for k=1:N-1
        stateError = smoothedState_vectors(:, k+1) ...
                   - A * smoothedState_vectors(:, k);
        sumQ = sumQ + stateError * stateError';
        sumQ = sumQ + A * smoothedCovariance_matrices(:,:,k) * A';
        sumQ = sumQ + smoothedCovariance_matrices(:,:,k+1);
        minus1 = (smoothedCovariance_matrices(:,:,k+1) * smoothedGain_matrices(:,:,k)' * A');
        sumQ = sumQ - minus1;
        sumQ = sumQ - minus1';
    end
    Qnew = sumQ ./ N;
    display(Qnew);
    Q = Qnew;
    
    sumR = zeros(2,2);
    numberOfEncoderMeasurements = 0;
    for k=2:N
        if(theta_measurements(k-1) ~= theta_measurements(k))
            numberOfEncoderMeasurements = numberOfEncoderMeasurements + 1;
            error = [theta_measurements(k); thetaDot_measurements(k)] - H1 * smoothedState_vectors(:,k);
            sumR = sumR + error * error';
            sumR = sumR + H1 * smoothedCovariance_matrices(:,:,k) * H1'; 
        end
    end
    Rnew = sumR ./ (numberOfEncoderMeasurements+1);
    display(Rnew);
    R=Rnew;
    display(R(1,1))
end

fig1 = figure;
plot(t(2:N),filteredState_vectors(1,2:N))
hold on
plot(t(2:N-20),smoothedState_vectors(1,2:N-20))
hold on
plot(t, theta_measurements)

set(fig1.CurrentAxes,'TickLabelInterpreter','latex');
set(fig1.CurrentAxes,'FontSize', 16);
leg1 = legend('Kalman Filter','Kalman Smoother', 'Encoder Measurement');
set(leg1, 'Interpreter', 'latex')
set(leg1, 'FontSize', 9)
ylabel('$$\theta (^\circ)$$', 'Interpreter', 'latex');
xlabel('Time (s)', 'Interpreter', 'latex')
title('Angular Position vs Time', 'Interpreter', 'latex')


figure
plot(t(2:N), filteredState_vectors(2,2:N))
title('Angular Velocity')
hold on
plot(t(2:N-20), smoothedState_vectors(2,2:N-20))
hold on
plot(t(2:N), thetaDot_measurements(2:N))
legend('Filtered Velocity', 'Smoothed Velocity', 'Measurement')

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


