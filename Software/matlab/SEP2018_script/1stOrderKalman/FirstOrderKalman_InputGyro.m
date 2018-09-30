%Seyit Yiðit SIZLAYAN / 1876861

%%INIT
clc;
global N
global dt
global t
global pedal

K_array = [];
K=0;
P_array = [];

angPos_underTest = pedal.position_unfiltered;
velocity_underTest = pedal.velocity;

% Noise model
q_model = 0.000557541965438186;

r_enc = 0.0027; % Output model noise

x_hat=zeros(1,N);

P_plus=r_enc;

x_hat_plus = angPos_underTest(1);
for k=2:N
    x_hat_minus = x_hat_plus+dt*velocity_underTest(k);  % system model output
    P_minus = P_plus + q_model;  % Covarience prediction
    
    %% Measurement Update
    if(angPos_underTest(k-1) == angPos_underTest(k)) % If the position did not change
        x_hat_plus = x_hat_minus;
        P_plus = P_minus;
    else
        y = x_hat_minus;  % output of the system
        y_err = angPos_underTest(k) - y; % error of the angle

        K = P_minus/(P_minus+r_enc);  % Kalman gain
        x_hat_plus = x_hat_minus + K * y_err;
        P_plus = (1-K)*P_minus;
    end
    x_hat(k)=x_hat_plus;
    K_array = [K_array;K];
    P_array = [P_array;P_plus];
end

filtered_angPos = x_hat;
figure
plot(t,filtered_angPos);
hold on
plot(t,angPos_underTest);
legend('Kalman Output','Measurement, decreased', "Actual Measurement")
title('Angular Position')