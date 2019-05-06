t = 0:1e-6:0.245;
signal_itself = 90 * sin(2*pi*1*t);
CPR = 2000;

N = length(signal_itself);

samplePoints = -180+360/CPR:360/CPR:180;
reSampledSignal = zeros(N,1);
% reSampledSignal(1) = signal_itself(1);
lastIndex = 0;
for j=2:length(samplePoints)
     if(signal_itself(1) == samplePoints(j) || signal_itself(1)>samplePoints(j-1) && signal_itself(1)<samplePoints(j) )
        lastIndex = j;
        break;
     end
end

reSampledSignal(1) = samplePoints(j-1);
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

% figure
% plot(t, encoderSimWithoutNoise);
% hold on
% plot(t, signal_itself);
% legend(strcat("CPR: ", num2str(CPR)), "Actual Measruement")
% title("W/O Noise")


noiseSignal = normrnd(0, /CPR, [length(samplePoints),1]);
figure
plot(noiseSignal)
title("Noise")
display(max(abs(noiseSignal)))
% figure
% histogram(noiseSignal);
% 
samplePointsWoNoise= samplePoints;
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
            reSampledSignal(i) = samplePointsWoNoise(lastIndex+1);
            lastIndex = lastIndex + 1;
        else
            reSampledSignal(i) = samplePointsWoNoise(lastIndex);
        end
        
    else
        if(signal_itself(i) < samplePoints(lastIndex-1))
            reSampledSignal(i) = samplePointsWoNoise(lastIndex-1);
            lastIndex = lastIndex - 1;
        else
            reSampledSignal(i) = samplePointsWoNoise(lastIndex);
        end
    end
end
encoderSimWithNoise = reSampledSignal;
figure
plot(t, encoderSimWithNoise, t, encoderSimWithoutNoise);
hold on
plot(t, signal_itself);
set(gca,'ytick',samplePoints)
grid on
legend("w/ noise", "w/o noise", "Actual Measurement")
title("w/ noise")

errorWithoutNoise = signal_itself-encoderSimWithoutNoise';
errorWithoutNoise = errorWithoutNoise(100:end-100);
errorWithNoise = signal_itself-encoderSimWithNoise';
errorWithNoise = errorWithNoise(100:end-100);
t = t(100:end-100);

figure
plot(t, errorWithoutNoise, t, errorWithNoise);
title("Errors");
legend("W/o Noise", "w/ noise");

[p_woNoise,x_woNoise] = hist(errorWithoutNoise, 20); 
[p_wNoise,x_wNoise] = hist(errorWithNoise, 20); 

figure
subplot(1,2,1)
plot(x_woNoise,p_woNoise./sum(p_woNoise),"o"); %PDF
title("PDF of noiseless encoder")
xlim([-2,2])
ylim([0, 0.2])
grid on
subplot(1,2,2)
plot(x_wNoise,p_wNoise./sum(p_wNoise), "o"); %PDF
title("PDF of noisy encoder")
xlim([-2,2])
ylim([0, 0.2])
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
