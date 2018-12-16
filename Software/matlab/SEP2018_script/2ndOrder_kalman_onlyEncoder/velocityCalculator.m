 
global N
global dt
global pedal
global t

thetaDot_measurements = zeros(N, 1);
thetaDot_measurements(1) = (theta_measurements(2)-theta_measurements(1))/dt;
lastChangedMeasurement = theta_measurements(1);
lastChangedMeasurementInstance = 1;

 for k=2:N
     if(theta_measurements(k-1) ~= theta_measurements(k))
        velocityMeasurement = (theta_measurements(k) - lastChangedMeasurement) / ...
                              (dt*(k - lastChangedMeasurementInstance));
        lastChangedMeasurement = theta_measurements(k);
        lastChangedMeasurementInstance = k;
     end
     thetaDot_measurements(k)    = velocityMeasurement;
 end