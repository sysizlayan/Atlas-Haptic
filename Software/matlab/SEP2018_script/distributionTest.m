t = 0:1e-3:100;
pedal.groundTruthTheta = 100 * sin(2*pi*1*t);
% figure
% plot(t, pedal.groundTruthTheta);
% title("Base Angular Position")

CPR = 2000;

t_interp = t(1):1e-4:t(end);
signal_itself = interp1(t, pedal.groundTruthTheta, t_interp);

N = length(signal_itself);

samplePoints = -180+360/CPR:360/CPR:180;

reSampledSignal = zeros(N,1);
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
reSampledSignal = downsample(reSampledSignal, 10);

encoderSimWithoutNoise = reSampledSignal;

figure
plot(t, encoderSimWithoutNoise);
hold on
plot(t, pedal.groundTruthTheta);
title("W/O Noise");
legend(strcat("CPR: ", num2str(CPR)), "Actual Measruement")



noiseSignal = normrnd(0, 0.02, [length(samplePoints),1]);
% figure
% histogram(noiseSignal);

samplePoints = samplePoints + noiseSignal';

reSampledSignal = zeros(N,1);
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
reSampledSignal = downsample(reSampledSignal, 10);

encoderSimWithNoise = reSampledSignal;

% figure
% plot(t, encoderSimWithNoise);
% hold on
% plot(t, pedal.groundTruthTheta);
% title("Noisy")
% legend(strcat("CPR: ", num2str(CPR)), "Actual Measruement")

% figure
% plot(t, pedal.groundTruthTheta-encoderSimWithoutNoise')
% title("Error with noisy encoder")

% figure
% plot(t, pedal.groundTruthTheta-encoderSimWithNoise')
% title("Error with noiseless encoder")
figure
[p,x] = hist(pedal.groundTruthTheta-encoderSimWithoutNoise'); 
plot(x,p/sum(p)); %PDF
title("PDF of noiseless encoder")
xlim([-0.3,0.3])
ylim([0, 0.15])

figure
[f,x] = ecdf(pedal.groundTruthTheta-encoderSimWithoutNoise'); 
plot(x,f); %CDF
title("CDF of noiseless encoder")

figure
[p,x] = hist(pedal.groundTruthTheta-encoderSimWithNoise'); plot(x,p/sum(p)); %PDF
title("PDF of noisy encoder")
xlim([-0.3,0.3])
ylim([0, 0.15])

figure
[f,x] = ecdf(pedal.groundTruthTheta-encoderSimWithNoise'); plot(x,f); %CDF
title("CDF of noisy encoder")

% figure
% a = histogram(pedal.groundTruthTheta-encoderSimWithoutNoise');

% figure
% b = histogram(pedal.groundTruthTheta-encoderSimWithNoise');

