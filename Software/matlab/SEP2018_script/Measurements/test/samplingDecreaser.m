clc

global N
global dt
global angPos
global angPos_decreased
global gyro_angVel
global t

angPos = posP_unfiltered;
gyro_angVel = velP;
N = length(angPos);
dt = 0.001;

angPos_decreased = angPos;
decreaseRate = 4;
resolution = 2000/decreaseRate;

degreee = -180+360/resolution:360/resolution:180;
for i=1:length(degreee)
    degreee(i) = round(degreee(i), 3);
end

angPos_decreased = zeros(N,1);
prevPos = 0;
for i=1:N
    for j=1:length(degreee)
        if(angPos(i) == degreee(j))
            angPos_decreased(i) = angPos(i);
            prevPos = angPos(i);
        else
            angPos_decreased(i) = prevPos;
        end
    end
end

figure
plot(t, angPos_decreased);
hold on
plot(t, angPos);
legend(strcat("Decreased Resolution, 1:", num2str(decreaseRate)), "Actual Measruement")