function [ cost ] = costForMLE_firstOrder_unc( noise_params )
    
    global angPos
    global gyro_angVel
    global N
    global dt
    
    q_model = noise_params(1);
    r_enc = noise_params(2); % Output model noise

    P_plus=r_enc;

    x_hat_plus=angPos(1);

    cost = 0;
    for k=2:N
        %% Prediction

        x_hat_minus = x_hat_plus+dt*gyro_angVel(k);  % system model output
        P_minus = P_plus + q_model;  % Covarience prediction

        if(angPos(k-1) == angPos(k)) % If the position did not change
            x_hat_plus = x_hat_minus;
            P_plus = P_minus;
            SIGMA = P_minus+r_enc;
            cost = cost + log(det(SIGMA));
        else
            y = x_hat_minus;  % output of the system
            y_err = angPos(k) - y; % error of the angle
            SIGMA = P_minus+r_enc;
            SIGMA_INV=1/SIGMA;
            K = P_minus/(P_minus+r_enc);  % Kalman gain
            x_hat_plus = x_hat_minus + K * y_err;
            P_plus = (1-K)*P_minus;
            cost = cost + (log(det(SIGMA))+y_err'*SIGMA_INV*y_err);
        end
        
    end
    cost = cost/100000;
end

