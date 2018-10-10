function [ cost ] = optimizationFunction(noise_params)
    
    global pedal
    global N
    
    qModel = noise_params(1);
%     q3_3   = noise_params(1);%noise_params(2);
    rGyro  = 100000;%noise_params(3); % Output model noise
    
    N = length(pedal.position_unfiltered);
    z = [pedal.position_unfiltered'; pedal.velocity'];% Measured signals
    
    Ts = 0.001; % 1KHz
    A = [1      (Ts + 0.5*Ts^2)     -0.5*Ts^2;
         0      1+Ts                -Ts;
         0      1                   0];

%     B = 0;
% 
%     C = [1      0           0;
%          0      1           0;
%          0      1/Ts    -1/Ts];
% 
%     D =  0;

    % Measurement models
    % Encoder and Gyro together
    H1 = [1 0 0;
          0 1 0];

    % Gyro only
    H2 = [0 1 0];
    
    Q1 = [Ts^4/4 Ts^3/2; Ts^3/2 Ts^2] * qModel;

    %Covariance Matrices
    Q = [Q1(1,1)    Q1(1,2)       0;
         Q1(2,1)    Q1(2,2)       0;
         0          0           Q1(2,2)];

    R = diag([0.0027; rGyro]);


    x_hat(:,1) = [z(:,1); 0];
    x_hat_plus = x_hat(:,1); %Take first measurement as initial state
    P_plus = diag([1, 1, 0]); % Starting covarience
    
    cost = 0;
    for k=2:N
        %% Prediction
        x_hat_minus = A*x_hat_plus; % Model Output
        P_minus = A*P_plus*A' + Q; % Covarience Estimation

        %% Measurement Update
        % Gyro only
        if(pedal.position_unfiltered(k-1) == pedal.position_unfiltered(k))
            y = H2 * x_hat_minus; % output model
            %z_now = H2 * z(:,k); % Measurement

            y_err = z(2, k) - y; % error
            
            SIGMA = H2*P_minus*H2'+R(2,2);
            
            K = (P_minus*H2')*pinv(H2*P_minus*H2'+R(2,2));
            x_hat_plus = x_hat_minus + K * y_err;
            P_plus = (eye(3)-K*H2)*P_minus;
            
%             if(size(SIGMA) == [1,1])
%                 disp(SIGMA);
%             end

        % Encoder measurement has come
        else
            y = H1*x_hat_minus;  % Output Model
            y_err = z(:,k) - y; % error

            SIGMA = H1*P_minus*H1'+R;
            
            K = (P_minus*H1')*pinv(H1*P_minus*H1'+R);

            x_hat_plus = x_hat_minus + K * y_err;
            P_plus = (eye(3)-K*H1)*P_minus;
            
%             if(size(SIGMA) == [1,1])
%                 disp(SIGMA);
%             end
        end
        newLoss = (log(det(SIGMA))+y_err'/(SIGMA)*y_err);
%         if(newLoss < 0)
%             disp(newLoss);
%         end
        cost = cost + newLoss;
%         if(size(cost) ~= [1,1])
%             disp(SIGMA)
%         end
    end
end

