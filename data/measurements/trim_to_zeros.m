for i=1:length(pedal.position_unfiltered)
    if pedal.position_unfiltered(i) == 0
        
        %decreasing
        if (pedal.position_unfiltered(i+1) - pedal.position_unfiltered(i) < 0 && last_direction == 1) || (pedal.position_unfiltered(i+1) - pedal.position_unfiltered(i) > 0 && last_direction == 0) 
            pedal.position_unfiltered = pedal.position_unfiltered(i:end);
            t = t(i:end);
            pedal.velocity = pedal.velocity(i:end);
            break;
        end
    end
end
for i=length(pedal.position_unfiltered):-1:1
    if pedal.position_unfiltered(i) == 0
        % position increasing
        if(pedal.position_unfiltered(i) - pedal.position_unfiltered(i-10) < 0)
            last_direction = 1;
        else
            last_direction = 0;
        end
        
        pedal.position_unfiltered = pedal.position_unfiltered(1:i);
        t = t(1:i);
        pedal.velocity = pedal.velocity(1:i);
        break;
    end
end