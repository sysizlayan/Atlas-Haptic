%Seyit Yiðit SIZLAYAN / 1876861

%%INIT
clc;
global N
global dt
global t
global pedal

% System Model
A = 1;
B = dt;

% Output Model
C1 = 1;
C2 = 0;
d = 0;


% Measurements
theta_measurements = pedal.position_unfiltered;
thetaDot_measurements = pedal.velocity;

% Noise models
q_model = 1000;%0.000658536602603968;%0.000557541965438186;
r_enc = 1000; %0.0027; % Output model noise

for emIterations = 1:100
    filteredTheta_values=zeros(1,N);
    predictedTheta_values=zeros(1,N);

    kalmanGain_values = zeros(1,N);

    filteredCovarience_values = zeros(1,N);
    predictedCovarience_values = zeros(1,N);

    predictionError_values = zeros(1,N);
    % Initial values
    filteredCoverience = r_enc;
    predictedCovarience = r_enc;
    filteredCovarience_values(1) = r_enc;
    predictedCovarience_values(1) = r_enc;

    filteredTheta = theta_measurements(1);
    filteredTheta_values(1) = theta_measurements(1);
    for k=2:N
        %% Transition update
        predictedTheta = A * filteredTheta+ B * thetaDot_measurements(k);  % system model output
        predictedCovarience = A * filteredCoverience * A' + q_model;  % Covarience prediction

        %% Measurement Update
        if(theta_measurements(k-1) == theta_measurements(k)) % If the position did not change
            % Since C2 = 0, the Kalman gain will be 0!
            kalmanGain = 0;
            err = 0;
            filteredTheta = predictedTheta;
            filteredCoverience = predictedCovarience;
        else
            kalmanGain = predictedCovarience * C1' * pinv(C1 * predictedCovarience * C1' + r_enc);  % Kalman gain
            err = theta_measurements(k) - C1 * predictedTheta - d;

            filteredTheta = predictedTheta + kalmanGain * err;
            filteredCoverience = (eye(1)-kalmanGain*C1)*predictedCovarience;
        end
        filteredTheta_values(k) = filteredTheta;
        predictedTheta_values(k) = predictedTheta;

        kalmanGain_values(k) = kalmanGain;

        predictedCovarience_values(k) = predictedCovarience;
        filteredCovarience_values(k) = filteredCoverience;

        predictionError_values(k) = err;
    end

    smoothedTheta_values = zeros(1, N);
    smoothedTheta_values(end) = filteredTheta(end);
    smoothedTheta = filteredTheta(end);

    smoothedCovarience_values = zeros(1, N);
    smoothedCovarience_values(end) = filteredCovarience_values(end);
    smoothedCovarience = filteredCovarience_values(end);

    smootingGain_values= zeros(1, N-1);
    for k=N-1:-1:2
        smoothingGain = filteredCovarience_values(k) * A' / predictedCovarience_values(k+1);
        smoothedTheta = filteredTheta_values(k) + smoothingGain * (smoothedTheta - predictedTheta_values(k+1));
        smoothedCovarience = filteredCovarience_values(k) + smoothingGain * (smoothedCovarience - predictedCovarience_values(k+1)) * smoothingGain';

        smoothedCovarience_values(k) = smoothedCovarience;
        smoothedTheta_values(k) = smoothedTheta;
        smoothingGain_values(k) = smoothingGain;
    end

    covarianceBetweenStates_values = zeros(1,N);
    for k=2:N
        covarianceBetweenStates_values(k) = smoothedCovarience_values(k) ...
                                          * smoothingGain_values(k-1)';
    end

    sum = 0;
    for k=1:N-1
        error = smoothedTheta_values(k+1) ... 
                - A * smoothedTheta_values(k) ...
                - B * thetaDot_measurements(k);

        minusTerm = covarianceBetweenStates_values(k+1) * A';
        sum = sum + (error * error') ...
                  + (A * smoothedCovarience_values(k) * A') ...
                  + smoothedCovarience_values(k+1) ...
                  - minusTerm ...
                  - minusTerm';
    end
    q_new = 1/N * sum;
    display(q_new);

    sum = 0;
    numberOfNewMeasurements = 0;
    for k=1:N-1
        if(theta_measurements(k) ~= theta_measurements(k+1)) % If the position did not change
            numberOfNewMeasurements = numberOfNewMeasurements + 1;
            error = theta_measurements(k) - C1 * smoothedTheta_values(k) - d;
            plusTerm1 = C1 * smoothedCovarience_values(k) * C1';
            sum = sum + ...
                  + error * error' ...
                  + plusTerm1;
        else
    %         sum = sum + theta_measurements(k) * thetaDot_measurements(k)';
        end
    end
    r_new = 1/(numberOfNewMeasurements) * sum;
    display(r_new);
    
    clear sum
    normalized_diff = sum(smoothedTheta_values - filteredTheta_values) / length(filteredTheta_values);
    
    q_diff = q_new-q_model;
    r_diff = r_enc-r_new;
%     displaylay(q_diff);
%     displaylay(r_diff);
    display(normalized_diff)
    if(abs(q_diff) < 1e-7 || abs(r_diff) < 1e-7)
        break;
    end
    q_model = q_new;
    r_enc = r_new;
   
end

figure
plot(t,filteredTheta_values);
hold on
plot(t,theta_measurements);
hold on
plot(t, smoothedTheta_values);
legend('Filtered Output', 'Actual Measurement', 'Smoothed Output')
title('Angular Position')

figure
plot(t,predictionError_values);
title('Prediction errors')

figure
plot(t,kalmanGain_values);
title('Kalman Gains')