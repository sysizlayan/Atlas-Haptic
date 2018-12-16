function [reSampledSignal] = sampleDecreaser(CPR)

global t
global pedal

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

figure
plot(t, reSampledSignal);
hold on
plot(t, pedal.position_unfiltered);
legend(strcat("CPR: ", num2str(CPR)), "Actual Measruement")
end

