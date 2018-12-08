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

H1 = [1 0]; % Measurement Model when encoder has come

% Measurements
theta_measurements = pedal.position_unfiltered;

%% Error Covariences
processVariance = 1e100;
Q = [dt^4/4 0; 0 1];%[dt^4/4, dt^3/2; dt^3/2 dt^2] * processVariance;
R = 0.0027;
for emIterations = 1:10
    %State vectors
    predictedState_vectors = zeros(2,N);
    filteredState_vectors = zeros(2,N);
    
    %Store the kalman gains, predicted and filtered covariance matrices
    kalmanGains = zeros(2,N);
    filteredCovariance_matrices = zeros(2,2,N);
    predictedCovariance_matrices = zeros(2,2,N);
    
    predictionError_vectors = zeros(1,N);
    
    %Initialization
    filteredCovariance_matrix = R;
    predictedCovariance_matrix = R;
    
    filteredCovariance_matrices(:,:,1) = Q;
    predictedCovariance_matrices(:,:,1) = Q;
    
    % Initial position is measured value, velocity is a small number
    % To prevent numerical instability
    initialVelocity = 1e-6;
    filteredState = [theta_measurements(1); initialVelocity];
    filteredState_vectors(:, 1) = filteredState;
        
    kalmanGain = 0;
    for k=2:N
        %% Prediction
        predictedState = A * filteredState;
        predictedCovariance_matrix = A*filteredCovariance_matrix*A' + Q; % Covarience Estimation

        %% Correction
        if(theta_measurements(k-1) ~= theta_measurements(k))
            errorVector = theta_measurements(k) - H1 * predictedState;
            kalmanGain = predictedCovariance_matrix * H1' .\ (H1 * predictedCovariance_matrix * H1' + R);

            filteredState = predictedState + kalmanGain * errorVector;
            filteredCovariance_matrix = (eye(2) - kalmanGain*H1) * predictedCovariance_matrix;
        else
            filteredState = predictedState;
            filteredCovariance_matrix = predictedCovariance_matrix;
        end
        filteredState_vectors(:,k)  = filteredState;
        predictedState_vectors(:,k) = predictedState;
        kalmanGains(:,k)  = kalmanGain;
        filteredCovariance_matrices(:,:,k)  = filteredCovariance_matrix;
        predictedCovariance_matrices(:,:,k) = predictedCovariance_matrix;
    end % End of forward kalman loop
    
    %Kalman Smoother
    smoothedState_vectors = zeros(2,N);
    smoothedState_vectors(:, end) = filteredState_vectors(end);
    
    smoothedState = filteredState_vectors(end);
    
    smoothedCovariance_matrices = zeros(2,2,N);
    smoothedCovariance_matrices(:,:,end) = ...
        filteredCovariance_matrices(:,:,end);
    
    smoothedCovariance = filteredCovariance_matrices(:,:,end);
    
    smoothedGain_matrices = zeros(2,2,N-1);
    for k=N-1:-1:2
        smoothingGain = filteredCovariance_matrices(:,:,k) * ...
            A' / predictedCovariance_matrices(:,:,k+1);
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
    
    covarianceBetweenStates_matrices = zeros(2,2,N);
    for k=2:N
        covarianceBetweenStates_matrices(:,:,k) = smoothedCovariance_matrices(:,:,k) * ...
                                                   smoothedGain_matrices(k-1)';
    end
    
    sumSum = zeros(2,2);
    for k=1:N-1
        error = smoothedState_vectors(:, k+1) ...
                - A * smoothedState_vectors(:, k);
        minusTerm = covarianceBetweenStates_matrices(:,:, k+1) * A';
        sumSum = sumSum + (error * error') ...
                        + (A * smoothedCovariance_matrices(:,:,k) * A')...
                        + smoothedCovariance_matrices(:,:,k+1) ...
                        - minusTerm ...
                        - minusTerm';
    end
    Q_prev = Q;
    Q_new = 1/N .* sumSum;
    Q(2,2) = Q_new(2,2);
    display(Q)
    
%     sumSum = 0;
%     numberOfNewMeasurements = 0;
%     for k=1:N-1
%         if(theta_measurements(k)~=theta_measurements(k+1))
%             numberOfNewMeasurements = numberOfNewMeasurements + 1;
%             error = theta_measurements(k) - H1 * smoothedState_vectors(:,k);
%             plusTerm1 = H1 * smoothedCovariance_matrices(:,:,k) * H1';
%             sumSum = sumSum + ...
%                     + error * error' ...
%                     + plusTerm1;
%         end
%     end
%     R_prev = R;
%     R = 1/numberOfNewMeasurements .* sumSum;
%     display(R);
    
    difference_vector = smoothedState_vectors - filteredState_vectors;
    normalized_diff = (difference_vector * difference_vector') / N;
    display(normalized_diff);
end

figure
plot(t(2:N),filteredState_vectors(1,2:N))
title('Angular Position')
hold on
plot(t(2:N),smoothedState_vectors(1,2:N))
hold on
plot(t,pedal.position_unfiltered)
legend('Kalman Output','Smoothed Output', 'Measurement')

figure
plot(t(2:N), filteredState_vectors(2,2:N))
title('Angular Velocity')
hold on
plot(t(2:N), smoothedState_vectors(2,2:N))
% hold on
% plot(t(2:N), thetaDot_measurements(2:N))
legend('Filtered Velocity', 'Smoothed Velocity');%, 'Measurement')
save('last_iteration_100.mat')
% hold on
% plot(t,pedal.velocity, t, velocityMeasurementVector )
% legend('Kalman Output', 'Measurement Gyro', 'Measurement Encoder')

% angPos = angPostmp;


