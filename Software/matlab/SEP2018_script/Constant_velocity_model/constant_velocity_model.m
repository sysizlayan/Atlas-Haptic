%Seyit Yiðit SIZLAYAN / 1876861

%%INIT
clc;
global N
global dt
global t
global pedal

modelOrder = 2;
% System Model
A = [1 dt ; 0 1];
B = [dt^2/2 ; dt];

% Output Model
C1 = [1 0; 0 1];
C2 = [0 1];
d = 0;


% Measurements
theta_measurements = pedal.position_unfiltered;
thetaDot_measurements = pedal.velocity;
measurements = [theta_measurements';thetaDot_measurements']; % 2xN

% Noise models
q_model = 1e12;
r_enc = 0.0027;
r_gyro = 0.0025;

Q = 100*eye(modelOrder);%B * B' * q_model; % 2x2
R = [r_enc 0; 0 r_gyro]; % 2x2

for emIterations = 1:10
    filteredState_values=zeros(modelOrder,N);
    predictedState_values=zeros(modelOrder,N);

    kalmanGain_values = zeros(modelOrder,modelOrder,N);

    filteredCovarience_values = zeros(modelOrder,modelOrder,N);
    predictedCovarience_values = zeros(modelOrder,modelOrder,N);

    predictionError_values = zeros(modelOrder,N);
    % Initial values
    filteredCoverience = R;
    predictedCovarience = R;
    filteredCovarience_values(:,:,1) = R;
    predictedCovarience_values(:,:,1) = R;

    filteredState = measurements(:,1);
    filteredState_values(:, 1) = measurements(:, 1);
    for k=2:N
        %% Transition update
        predictedState = A * filteredState;  % system model output
        predictedCovarience = A * filteredCoverience * A' + Q;  % Covarience prediction

        %% Measurement Update
        if(theta_measurements(k-1) == theta_measurements(k)) % If the position did not change
            kalmanGain = predictedCovarience * C2' / (C2 * predictedCovarience * C2' + R(2,2)); % 2x2
            err = measurements(2,k) - C2 * predictedState; %1x1
            
            filteredState = predictedState + kalmanGain * err;
            filteredCoverience = (eye(modelOrder) - kalmanGain * C2) * predictedCovarience;
        else
            kalmanGain = predictedCovarience * C1' / (C1 * predictedCovarience * C1' + R);  % Kalman gain
            err = measurements(:,k) - C1 * predictedState;

            filteredState = predictedState + kalmanGain * err;
            filteredCoverience = (eye(modelOrder) - kalmanGain * C1) * predictedCovarience;
        end
        filteredState_values(:,k) = filteredState;
        predictedState_values(:,k) = predictedState;

%         kalmanGain_values(:,:,k) = kalmanGain;

        predictedCovarience_values(:,:,k) = predictedCovarience;
        filteredCovarience_values(:,:,k) = filteredCoverience;

        predictionError_values(:, k) = err;
    end

    smoothedState_values = zeros(modelOrder, N);
    smoothedState_values(end) = filteredState(end);
    smoothedState = filteredState(end);

    smoothedCovarience_values = zeros(modelOrder, modelOrder, N);
    smoothedCovarience_values(:,:,end) = filteredCovarience_values(:,:, end);
    smoothedCovarience = filteredCovarience_values(:,:, end);

    smoothingGain_values= zeros(modelOrder, modelOrder, N-1);
    for k=N-1:-1:2
        smoothingGain = filteredCovarience_values(:,:,k) * A' / predictedCovarience_values(:,:,k+1);
        smoothedState = filteredState_values(:, k) + smoothingGain * (smoothedState - predictedState_values(:,k+1));
        smoothedCovarience = filteredCovarience_values(:,:,k) + smoothingGain * (smoothedCovarience - predictedCovarience_values(:,:,k+1)) * smoothingGain';

        smoothedCovarience_values(:,:,k) = smoothedCovarience;
        smoothedState_values(:,k) = smoothedState;
        smoothingGain_values(:,:,k) = smoothingGain;
    end

    covarianceBetweenStates_values = zeros(modelOrder, modelOrder, N);
    for k=2:N
        covarianceBetweenStates_values(:,:, k) = smoothedCovarience_values(:,:, k) ...
                                          * smoothingGain_values(:,:, k-1)';
    end

    sum = zeros(modelOrder);
    for k=1:N-1
        error = smoothedState_values(k+1) ... 
                - A * smoothedState_values(k);

        minusTerm = covarianceBetweenStates_values(:,:,k+1) * A';
        sum = sum + (error * error') ...
                  + (A * smoothedCovarience_values(:,:,k) * A') ...
                  + smoothedCovarience_values(:,:,k+1) ...
                  - minusTerm ...
                  - minusTerm';
    end
    Q = 1/N * sum;
    disp(Q);
% 
%     sum = 0;
%     numberOfNewMeasurements = 0;
%     for k=1:N-1
%         if(theta_measurements(k) ~= theta_measurements(k+1)) % If the position did not change
%             numberOfNewMeasurements = numberOfNewMeasurements + 1;
%             error = theta_measurements(k) - C1 * smoothedTheta_values(k) - d;
%             plusTerm1 = C1 * smoothedCovarience_values(k) * C1';
%             sum = sum + ...
%                   + error * error' ...
%                   + plusTerm1;
%         else
%     %         sum = sum + theta_measurements(k) * thetaDot_measurements(k)';
%         end
%     end
%     r_new = 1/(numberOfNewMeasurements) * sum;
%     disp(r_new);
%     
%     q_model = q_new;
%     r_enc = r_new;
end

figure
plot(t,filteredState_values(1,:)');
hold on
plot(t,theta_measurements);
hold on
plot(t, smoothedState_values(1,:)');
legend('Filtered Output', 'Actual Measurement', 'Smoothed Output')
title('Angular Position')


figure
plot(t,filteredState_values(2,:)');
% hold on
% plot(t,thetaDot_measurements);
% hold on
% plot(t, smoothedState_values(2,:)');
% legend('Filtered Output', 'Actual Measurement')
title('Angular Velocity')