function [ cost ] = costForMLE( variances )
%COSTFORMLE Summary of this function goes here
%   Detailed explanation goes here
%Seyit Yiðit SIZLAYAN / 1876861
    global z
    global N
    global dt
    
%     x_hat=zeros(2,N); % State Estimates

%     K_array = zeros(2, 2, N-1);   %# Creates a 2X2XN tensor
q_model=variances(1);
r_enc=variances(2);
r_gyro=variances(3);
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
    % H1 = [1 0]; -> When position measurement is taken
    % H2 = [0 1]; -> When gyrometer measurement is taken

    %% Error Covariences
    model_var = q_model;
    % Q_enc = 1e-3; 
    % Q_gyro = 1e-1; 

    % Uniform distibution varience, (b-a)^2/12 -> b-a = 0.18 degree
    R_angle = r_enc;
    %  From gyro datasheet
    R_gyro = r_gyro;

    % Q = diag([Q_enc,Q_gyro]);
    Q = B'*B*model_var;
    R = diag([R_angle, R_gyro]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Kalman
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Initialisation
%     x_hat(:,1) = z(:,1);
    x_hat_plus = z(:,1); %Take first measurement as initial state
    P_plus = R;%diag([100^2 200^2]); % Starting covarience
    cost = 0;
    for k=2:N
    %     F = [1 dt(k-1); 0 1]; % System Model
    %     B = [dt(k-1)*dt(k-1)/2 dt(k-1)]; % Input Model
        %% Prediction
        x_hat_minus = F*x_hat_plus; % Model Output
        P_minus = F*P_plus*F' + Q; % Covarience Estimation

        %% Measurement Update
        y = H*x_hat_minus; % Measurement Model
        y_err = z(:,k) - y; % error
        SIGMA = H*P_minus*H'+R;
        SIGMA_INV = pinv(SIGMA);
        K = (P_minus*H')*SIGMA_INV;

        x_hat_plus = x_hat_minus + K * y_err;
        P_plus = (eye(2)-K*H)*P_minus;

%         x_hat(:,k)=x_hat_plus;
        K_array(:,:,k) = K;
        cost = cost + (log(det(SIGMA))+y_err'*SIGMA_INV*y_err);
%         if ~isreal(cost)
%             display(cost)
%         end
    end
end

