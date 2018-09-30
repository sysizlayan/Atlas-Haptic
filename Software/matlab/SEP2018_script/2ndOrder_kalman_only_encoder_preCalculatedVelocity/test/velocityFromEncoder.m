global N
global dt
global angPos
global gyro_angVel
global t
global angVel_fromEncoder

prevMeasInstance = 1;
angVel_fromEncoder = zeros(N,1);
estimatedVelocity = 0;
for i=2:N
    prevMeasurement = angPos(prevMeasInstance);
    currentMeasurement = angPos(i);
    if(angPos(i-1) ~= currentMeasurement)
        estimatedVelocity = (currentMeasurement-prevMeasurement) / (i-prevMeasInstance) * 1e3;
        angVel_fromEncoder(i) = estimatedVelocity;
        prevMeasInstance = i;
    else
        angVel_fromEncoder(i) = estimatedVelocity;
    end
end

figure
plot(t,angVel_fromEncoder, t, gyro_angVel)
legend("Encoder Velocity", "Gyrometer")