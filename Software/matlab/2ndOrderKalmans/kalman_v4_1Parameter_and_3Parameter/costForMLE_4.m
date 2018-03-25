function [ cost ] = costForMLE_4( modelVar )
%COSTFORMLE Summary of this function goes here
%   Detailed explanation goes here
%Seyit Yiðit SIZLAYAN / 1876861
    global z
    global N
    global dt
    
    r_enc=0.0024;
    r_gyro=0.0093;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % x[k+1] = x[k] + x'[k]*dt + 0.5*acc*(dt)^2 + w
    % x'[k+1] = x'[k] + acc*dt
    % State X = [x[k];x'[k]];
    % X[k+1] = [1 dt; 0 1]*X[k] + [dt^2/2 dt] * acc
    % Acc is nomally distributed acceleration
    % Measurement 
    %
%     display(dt)
    F = [1 dt; 0 1]; % System Model
    B = [dt*dt/2 dt]; % Input Model

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % y[k] = z[k] - H * x_hat_minus


    H = [1 0; 0 1]; % Measurement Model
    % In robot there will be 2 different H matrix
%     H1 = [1 0]; %-> When position measurement is taken
    H2 = [0 1]; %-> When gyrometer measurement is taken

    %% Error Covariences
%     Q = [q_enc_enc, q_enc_gyro;q_enc_gyro,q_gyro_gyro];
    
    Q = B'*B*modelVar;
    R = diag([r_enc, r_gyro]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Kalman
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Initialisation
%     x_hat(:,1) = z(:,1);
    x_hat(:,1) = z(:,1);
    x_hat_plus = x_hat(:,1); %Take first measurement as initial state
    P_plus = R;%diag([100^2 200^2]); % Starting covarience

    cost = 0;
    for k=2:N
    
    %% Prediction
       
    x_hat_minus = F*x_hat_plus; % Model Output
    P_minus = F*P_plus*F' + Q; % Covarience Estimation

    if(z(1,k-1) ~= z(1,k)) % If the position did not change
        H_current = H;
        
        %% Measurement Update
        y = H_current*x_hat_minus; % Measurement Model
        y_err = z(:,k) - y; % error
        
        SIGMA = H_current*P_minus*H_current'+R;
        SIGMA_INV = pinv(SIGMA);
        
        K = (P_minus*H_current')*SIGMA_INV;
        x_hat_plus = x_hat_minus + K * y_err;
        P_plus = (eye(2)-K*H_current)*P_minus;
    else
        H_current = H2; 

        %% Measurement Update
        y = H_current*x_hat_minus; % Measurement Model
        y_err = z(2,k) - y; % error
        
        SIGMA = H_current*P_minus*H_current'+r_gyro;
        SIGMA_INV = pinv(SIGMA);
        
        K = (P_minus*H_current')*SIGMA_INV;

        x_hat_plus = x_hat_minus + K * y_err;
        P_plus = (eye(2)-K*H_current)*P_minus;
    end
        cost = cost + (log(det(SIGMA))+y_err'*SIGMA_INV*y_err);
%         disp(cost)
%         if ~isreal(cost)
%             display(cost)
%         end
    end
end

