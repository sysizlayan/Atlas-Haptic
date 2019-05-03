t = -0.25:1e-5:0.25;
signal_itself = 100 * sin(2*pi*1*t);
CPR = 2000;

N = length(signal_itself);

samplePoints = -180+360/CPR:360/CPR:180;
reSampledSignal = zeros(N,1);
reSampledSignal(1) = signal_itself(1);
lastIndex = 0;
for j=2:length(samplePoints)
     if(signal_itself(1) == samplePoints(j))
        lastIndex = j;
     elseif(signal_itself(1)>samplePoints(j-1) && signal_itself(1)<samplePoints(j))
         lastIndex = j;
     end
end
for i=2:N
    derivative = signal_itself(i) - signal_itself(i-1);
    if(derivative == 0)
        reSampledSignal(i) = reSampledSignal(i-1);
    elseif(derivative > 0)
        if(signal_itself(i) > samplePoints(lastIndex+1))
            reSampledSignal(i) = samplePoints(lastIndex+1);
            lastIndex = lastIndex + 1;
        else
            reSampledSignal(i) = samplePoints(lastIndex);
        end
        
    else
        if(signal_itself(i) < samplePoints(lastIndex-1))
            reSampledSignal(i) = samplePoints(lastIndex-1);
            lastIndex = lastIndex - 1;
        else
            reSampledSignal(i) = samplePoints(lastIndex);
        end
    end
end
encoderSimWithoutNoise = reSampledSignal;

figure
plot(t, encoderSimWithoutNoise);
hold on
plot(t, signal_itself);
legend(strcat("CPR: ", num2str(CPR)), "Actual Measruement")



noiseSignal = normrnd(0, 0.02, [length(samplePoints),1]);
% figure
% histogram(noiseSignal);
% 
samplePoints = samplePoints + noiseSignal';

reSampledSignal = zeros(N,1);
reSampledSignal(1) = signal_itself(1);
lastIndex = 0;
for j=2:length(samplePoints)
     if(signal_itself(1) == samplePoints(j))
        lastIndex = j;
     elseif(signal_itself(1)>samplePoints(j-1) && signal_itself(1)<samplePoints(j))
         lastIndex = j;
     end
end
for i=2:N
    derivative = signal_itself(i) - signal_itself(i-1);
    if(derivative == 0)
        reSampledSignal(i) = reSampledSignal(i-1);
    elseif(derivative > 0)
        if(signal_itself(i) > samplePoints(lastIndex+1))
            reSampledSignal(i) = samplePoints(lastIndex+1);
            lastIndex = lastIndex + 1;
        else
            reSampledSignal(i) = samplePoints(lastIndex);
        end
        
    else
        if(signal_itself(i) < samplePoints(lastIndex-1))
            reSampledSignal(i) = samplePoints(lastIndex-1);
            lastIndex = lastIndex - 1;
        else
            reSampledSignal(i) = samplePoints(lastIndex);
        end
    end
end
encoderSimWithNoise = reSampledSignal;
figure
plot(t, encoderSimWithNoise);
hold on
plot(t, signal_itself);
legend(strcat("CPR: ", num2str(CPR)), "Actual Measruement")

figure
plot(signal_itself-encoderSimWithoutNoise')
[p_woNoise,x_woNoise] = hist(signal_itself-encoderSimWithoutNoise', 100); 
[p_wNoise,x_wNoise] = hist(signal_itself-encoderSimWithNoise', 100); 

figure
subplot(1,2,1)
plot(x_woNoise,p_woNoise./sum(p_woNoise), "o"); %PDF
title("PDF of noiseless encoder")
xlim([-0.2,0.4])
ylim([0, 0.03])
grid on
subplot(1,2,2)
plot(x_wNoise,p_wNoise./sum(p_wNoise), "o"); %PDF
title("PDF of noisy encoder")
xlim([-0.2,0.4])
ylim([0, 0.03])
grid on


[f_woNoise,x1_woNoise] = ecdf(signal_itself-encoderSimWithoutNoise'); 
[f_wNoise,x1_wNoise] = ecdf(signal_itself-encoderSimWithNoise');
% 
figure
subplot(1,2,1)
plot(x1_woNoise, f_woNoise); %CDF
title("CDF of noiseless encoder")
grid on
subplot(1,2,2)
plot(x1_wNoise, f_wNoise)
title("CDF of noisy encoder")
grid on
