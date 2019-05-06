function [signal_decreased] = sampleDecreaser(signal_itself, currentResolution, decreaseRate)

global t

N = length(signal_itself);
resolution = currentResolution/decreaseRate;

degreee = -180+360/resolution:360/resolution:180;
for i=1:length(degreee)
    degreee(i) = round(degreee(i), 3);
end

signal_decreased = zeros(N,1);

prevPos = 0;
for i=1:N
    for j=1:length(degreee)
        if(signal_itself(i) == degreee(j))
            signal_decreased(i) = signal_itself(i);
            prevPos = signal_itself(i);
        else
            signal_decreased(i) = prevPos;
        end
    end
end

figure
plot(t, signal_decreased);
hold on
plot(t, signal_itself);
legend(strcat("Decreased Resolution, 1:", num2str(decreaseRate)), "Actual Measruement")
end

