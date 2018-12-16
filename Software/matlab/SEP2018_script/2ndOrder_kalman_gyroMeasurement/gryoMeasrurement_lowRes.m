%Seyit Yiðit SIZLAYAN / 1876861

%%INIT
clc;
close all;

% load('measurement_30_09_2018_sinus_1_0.mat');
% load('QOptimized_RfromDataSheet.mat');
clear;
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
H2 = [0 1]; % Gyro gives just angular velocity 
% Measurements
theta_measurements = sampleDecreaser(400);
thetaDot_measurements = pedal.velocity;

%% Error Covariences
processVariance = var(diff(pedal.velocity)/dt);
% Q = [dt^3/3, dt^2/2 ; dt^2/2, dt] * processVariance;

R = diag([0.9^2/12 0.0025]); % Gyro variance is taken from datasheet

for emIterations = 1:10
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
    
    filteredState = [theta_measurements(1); thetaDot_measurements(1)];
    filteredState_vectors(:, 1) = filteredState;
        
    kalmanGain = 0;
    velocityMeasurement = 0;
    for k=2:N
        
        %% Prediction
        predictedState = A * filteredState;
        predictedCovariance_matrix = A*filteredCovariance_matrix*A' + Q; % Covarience Estimation

        %% Correction
        if(theta_measurements(k-1) ~= theta_measurements(k))
            measurementVector = [theta_measurements(k);thetaDot_measurements(k)];
            errorVector = measurementVector - (H1 * predictedState);

            kalmanGain = predictedCovariance_matrix * H1' * pinv(H1 * predictedCovariance_matrix * H1' + R);

            filteredState = predictedState + kalmanGain * errorVector;
            filteredCovariance_matrix = (eye(2) - kalmanGain*H1) * predictedCovariance_matrix;
        else
            measurementVector = thetaDot_measurements(k);
            errorVector = measurementVector - H2*predictedState;
            
            kalmanGain = predictedCovariance_matrix * H2' * pinv(H2*(predictedCovariance_matrix+R)*H2');
            
            filteredState = predictedState + kalmanGain * errorVector;
            filteredCovariance_matrix = (eye(2) - kalmanGain*H2) * predictedCovariance_matrix;
        end
        filteredState_vectors(:,k)  = filteredState;
        predictedState_vectors(:,k) = predictedState;
        filteredCovariance_matrices(:,:,k)  = filteredCovariance_matrix;
        predictedCovariance_matrices(:,:,k) = predictedCovariance_matrix;
    end % End of forward kalman loop
    
    %Kalman Smoother
    smoothedState_vectors = zeros(2,N);
    smoothedState_vectors(:, N) = filteredState_vectors(:,N);
    
    smoothedState = filteredState_vectors(:,N);
    
    smoothedCovariance_matrices = zeros(2,2,N);
    smoothedCovariance_matrices(:,:,N) = ...
        filteredCovariance_matrices(:,:,N);
    
    smoothedCovariance = filteredCovariance_matrices(:,:,N);
    
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
end

figure
plot(t(2:N),filteredState_vectors(1,2:N))
hold on
plot(t(2:N-20),smoothedState_vectors(1,2:N-20))
hold on
plot(t,theta_measurements)
legend('Kalman Output','Smoothed Output', 'Measurement')
title('Angular Position')

figure
plot(t(2:N), filteredState_vectors(2,2:N))
hold on
plot(t(2:N-20), smoothedState_vectors(2, 2:N-20))
hold on
plot(t, thetaDot_measurements)
legend('Filtered Velocity','Smoothed Velocity', 'Gyroscope')

