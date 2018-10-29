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
q_model = 0.000557541965438186;
r_enc = 0.0027; % Output model noise

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
        err = theta_measurements(k) - C1 * predictedTheta + d;
        
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