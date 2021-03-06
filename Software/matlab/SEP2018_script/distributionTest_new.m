t = 0:1e-5:0.245;
signal_itself = 90 * sin(2*pi*1*t);
downSampled_signal_itself = downsample(signal_itself, 100);

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
downSampled_encoderSimWithoutNoise = downsample(encoderSimWithoutNoise, 100);

% figure
% plot(t, encoderSimWithoutNoise);
% hold on
% plot(t, signal_itself);
% legend(strcat("CPR: ", num2str(CPR)), "Actual Measruement")
% title("W/O Noise")


noiseSignal = normrnd(0, 45/CPR, [length(samplePoints),1]);
figure
plot(noiseSignal)
title("Noise")
%display(max(abs(noiseSignal)))
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
downSampled_encoderSimWithNoise = downsample(encoderSimWithNoise, 100);

figure
plot(t, encoderSimWithNoise, t, encoderSimWithoutNoise);
hold on
plot(t, signal_itself);
set(gca,'ytick',samplePoints)
grid on
legend("w/ noise", "w/o noise", "Actual Measurement")
title("w/ noise")

errorWithoutNoise1 = signal_itself-encoderSimWithoutNoise';
errorWithoutNoise = errorWithoutNoise1(100:end-100)-180/CPR;
errorWithNoise1 = signal_itself-encoderSimWithNoise';
errorWithNoise = errorWithNoise1(100:end-100)-180/CPR;
t = t(100:end-100);

error1 = downSampled_signal_itself - downSampled_encoderSimWithoutNoise';
error2 = downSampled_signal_itself - downSampled_encoderSimWithNoise';

figure
plot(t, errorWithoutNoise, t, errorWithNoise);
title("Errors");
legend("W/o Noise", "w/ noise");

[p_woNoise,x_woNoise] = hist(errorWithoutNoise, 20); 
[p_wNoise,x_wNoise] = hist(errorWithNoise, 20); 

pmfFig = figure;
subplot(1,2,1)
plot(x_woNoise,p_woNoise./sum(p_woNoise),"o"); %PDF
title("PDF of noiseless encoder")
xlim([-0.2,0.2])
ylim([0, 0.1])
grid on
subplot(1,2,2)
plot(x_wNoise,p_wNoise./sum(p_wNoise), "o"); %PDF
title("PDF of noisy encoder")
xlim([-0.2,0.2])
ylim([0, 0.1])
grid on

set(pmfFig.CurrentAxes,'TickLabelInterpreter','latex');
set(pmfFig, 'PaperPositionMode', 'auto');
set(pmfFig, 'PaperOrientation','landscape');
set(pmfFig, 'Position', [50 50 1200 800]);
print(pmfFig, '-dpdf', './pmfTest.pdf','-fillpage');



[ds_p_woNoise,ds_x_woNoise] = hist(error1, 50); 
[ds_p_wNoise,ds_x_wNoise] = hist(error2, 50);

pmfFig2 = figure;
subplot(1,2,1)
plot(ds_x_woNoise,ds_p_woNoise./sum(ds_p_woNoise),"o"); %PDF
title("PDF of noiseless encoder-downSampled")
% xlim([-0.2,0.2])
% ylim([0, 0.1])
grid on
subplot(1,2,2)
plot(ds_x_wNoise,ds_p_wNoise./sum(ds_p_wNoise), "o"); %PDF
title("PDF of noisy encoder-downSampled")
% xlim([-0.2,0.2])
% ylim([0, 0.1])
grid on

set(pmfFig2.CurrentAxes,'TickLabelInterpreter','latex');
set(pmfFig2, 'PaperPositionMode', 'auto');
set(pmfFig2, 'PaperOrientation','landscape');
set(pmfFig2, 'Position', [50 50 1200 800]);
print(pmfFig2, '-dpdf', './pmfTest.pdf2','-fillpage');


[f_woNoise,x1_woNoise] = ecdf(errorWithoutNoise); 
[f_wNoise,x1_wNoise] = ecdf(errorWithNoise);
% 
cdfFig = figure;
subplot(1,2,1)
plot(x1_woNoise, f_woNoise); %CDF
title("CDF of noiseless encoder")
grid on
subplot(1,2,2)
plot(x1_wNoise, f_wNoise)
title("CDF of noisy encoder")
grid on

set(cdfFig.CurrentAxes,'TickLabelInterpreter','latex');
set(cdfFig, 'PaperPositionMode', 'auto');
set(cdfFig, 'PaperOrientation','landscape');
set(cdfFig, 'Position', [50 50 1200 800]);
print(cdfFig, '-dpdf', './cdfTest.pdf','-fillpage');
