clc

global N
global dt
global angPos
global angPos_decreased
global gyro_angVel
global t

angPos_decreased = angPos;
decreaseRate = 10
k = 1 + decreaseRate;
for i=1:N
  if(i<k)
    angPos_decreased(i) = angPos(k-decreaseRate);
  elseif(i==k)
    k = k + decreaseRate;
  endif
endfor

figure
plot(t, angPos_decreased, t, angPos);
legend(strcat("Decreased Resolution, 1:", num2str(decreaseRate)), "Actual Measruement")