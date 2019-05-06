t = 0:1e-5:0.25;
pedal.groundTruthTheta = 70 * sin(2*pi*1*t);%70 * chirp(t,0.5,10,1);%70 * sin(2*pi*1*t);
% figure
% plot(t, pedal.groundTruthTheta);
% title("Base Angular Position")

CPR = 2000;

% t_interp = t(1):1e-4:t(end);
% signal_itself = interp1(t, pedal.groundTruthTheta, t_interp);
signal_itself = pedal.groundTruthTheta;

N = length(signal_itself);

samplePoints = -180+360/CPR:360/CPR:180;
N_samplePoints = length(samplePoints);

reSampledSignal = zeros(N,1);
reSampledSignal(1) = signal_itself(1);

point = 0;
lowerBound = 0;
upperBound = 0;
upperBound_index = 0;
lowerBound_index = 0;
maximumOfInput = max(signal_itself);
minimumOfInput = min(signal_itself);

for i=2:N
    for j=1:N_samplePoints-1
        if(signal_itself(i) > samplePoints(j) && signal_itself(i) < samplePoints(j+1))
            if(signal_itself(i) == samplePoints(j))
                lowerBound = signal_itself(i);
                upperBound = signal_itself(i);
                point = signal_itself(i);
            else
                lowerBound = samplePoints(j);
                lowerBound_index = j;
                upperBound = samplePoints(j+1);
                upperBound_index = j+1;
                point = signal_itself(i);
            end
            break;
        end
    end
%     A = [lowerBound upperBound point];
%     disp(A)
    if(lowerBound == point && upperBound == point)
        reSampledSignal(i) = point;
    else
        if(signal_itself(i) >= signal_itself(i-1))
            reSampledSignal(i) = lowerBound;
            if(lowerBound<minimumOfInput)
                reSampledSignal(i) = samplePoints(lowerBound_index +1);
            else
                reSampledSignal(i) = lowerBound;
            end
        elseif(signal_itself(i) < signal_itself(i-1))
            if(upperBound > maximumOfInput)
                reSampledSignal(i) = samplePoints(upperBound_index-1);
            else
                reSampledSignal(i) = upperBound;
            end
        else
            reSampledSignal(i) = reSampledSignal(i-1);
        end
    end
end

encoderSimWithoutNoise = reSampledSignal;

figure
plot(t, encoderSimWithoutNoise);
hold on
plot(t, pedal.groundTruthTheta);
title("W/O Noise");
legend(strcat("CPR: ", num2str(CPR)), "Actual Measruement")



noiseSignal = normrnd(0, 0.09, [length(samplePoints),1]);
% figure
% histogram(noiseSignal);
% 
samplePoints = samplePoints + noiseSignal';

reSampledSignal = zeros(N,1);
reSampledSignal(1) = signal_itself(1);

point = 0;
lowerBound = 0;
upperBound = 0;
upperBound_index = 0;
lowerBound_index = 0;
maximumOfInput = max(signal_itself);
minimumOfInput = min(signal_itself);

for i=2:N
    for j=1:N_samplePoints-1
        if(signal_itself(i) > samplePoints(j) && signal_itself(i) < samplePoints(j+1))
            if(signal_itself(i) == samplePoints(j))
                lowerBound = signal_itself(i);
                upperBound = signal_itself(i);
                point = signal_itself(i);
            else
                lowerBound = samplePoints(j);
                lowerBound_index = j;
                upperBound = samplePoints(j+1);
                upperBound_index = j+1;
                point = signal_itself(i);
            end
            break;
        end
    end
%     A = [lowerBound upperBound point];
%     disp(A)
    if(lowerBound == point && upperBound == point)
        reSampledSignal(i) = point;
    else
        if(signal_itself(i) >= signal_itself(i-1))
            reSampledSignal(i) = lowerBound;
            if(lowerBound<minimumOfInput)
                reSampledSignal(i) = samplePoints(lowerBound_index +1);
            else
                reSampledSignal(i) = lowerBound;
            end
        elseif(signal_itself(i) < signal_itself(i-1))
            if(upperBound > maximumOfInput)
                reSampledSignal(i) = samplePoints(upperBound_index-1);
            else
                reSampledSignal(i) = upperBound;
            end
        else
            reSampledSignal(i) = reSampledSignal(i-1);
        end
    end
end
% 
encoderSimWithNoise = reSampledSignal;
% 
figure
plot(t, encoderSimWithNoise);
hold on
plot(t, pedal.groundTruthTheta);
title("Noisy")
legend(strcat("CPR: ", num2str(CPR)), "Actual Measruement")
% 
% % figure
% % plot(t, pedal.groundTruthTheta-encoderSimWithoutNoise')
% % title("Error with noisy encoder")
% 
% % figure
% % plot(t, pedal.groundTruthTheta-encoderSimWithNoise')
% % title("Error with noiseless encoder")
[p_woNoise,x_woNoise] = hist(pedal.groundTruthTheta-encoderSimWithoutNoise', 20); 
[p_wNoise,x_wNoise] = hist(pedal.groundTruthTheta-encoderSimWithNoise', 20); 

figure
subplot(1,2,1)
plot(x_woNoise,p_woNoise./sum(p_woNoise), 'o'); %PDF
title("PDF of noiseless encoder")
xlim([-0.3,0.3])
ylim([0, 0.16])
grid on
subplot(1,2,2)
plot(x_wNoise,p_wNoise./sum(p_wNoise), 'o'); %PDF
title("PDF of noisy encoder")
xlim([-0.3,0.3])
ylim([0, 0.16])
grid on


[f_woNoise,x1_woNoise] = ecdf(pedal.groundTruthTheta-encoderSimWithoutNoise'); 
[f_wNoise,x1_wNoise] = ecdf(pedal.groundTruthTheta-encoderSimWithNoise');
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
% figure
% a = histogram(pedal.groundTruthTheta-encoderSimWithoutNoise');
% 
% figure
% b = histogram(pedal.groundTruthTheta-encoderSimWithNoise');

