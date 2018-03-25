global N
global dt
global angPos
global filtered_angPos
global gyro_angVel
global t



if  measurement_number < 5 
    x_limiting = [0 43];
    y_limiting = [45 110];
    
    FirstOrderKalman_InputGyro
    close all;

    
    angularPositionMeasurementFigure = figure;
    plot(t,angPos);
    hold on;
    xlim(x_limiting)
    ylim(y_limiting)
    title('Angular Position');
    legend('Encoder Measurement');
    % legend('Encoder Measurement','Kalman Result');
    % plot(t(2:end),filtered_angPos(2:end))
    set(angularPositionMeasurementFigure,'PaperPositionMode','auto');         
    set(angularPositionMeasurementFigure,'PaperOrientation','landscape');
    set(angularPositionMeasurementFigure,'Position',[50 50 1200 800]);
    print(angularPositionMeasurementFigure, '-dpdf', strcat('./Figures/',num2str(measurement_number),'//angularPositionMeasurementFigure_',num2str(measurement_number),'.pdf'));

    filteredFigureFromMatlab = figure;
    subplot(2,1,1)
    plot(t,angPos);
    hold on;
    plot(t(2:end),filtered_angPos(2:end))
    xlim([30 30.3]);
    % ylim([95 110]);
    legend('Encoder Measurement','Filtered Position in Matlab');
    subplot(2,1,2)
    plot(t, gyro_angVel);
    xlim([30 30.3]);
    legend('Gyroscope Measurement');
    title('Results');
    % legend('Encoder Measurement','Kalman Result');
    % plot(t(2:end),filtered_angPos(2:end))
    set(filteredFigureFromMatlab,'PaperPositionMode','auto');         
    set(filteredFigureFromMatlab,'PaperOrientation','landscape');
    set(filteredFigureFromMatlab,'Position',[50 50 1200 800]);
    print(filteredFigureFromMatlab, '-dpdf', strcat('./Figures/',num2str(measurement_number),'/filteredFigureFromMatlab_',num2str(measurement_number),'.pdf'))

    filteredFigureFromMatlabZoomed = figure;
    plot(t,angPos);
    hold on;
    plot(t(2:end),filtered_angPos(2:end))
    xlim([30.125 30.16]);
    ylim([104 107]);
    legend('Encoder Measurement','Filtered Position in Matlab');

    set(filteredFigureFromMatlabZoomed,'PaperPositionMode','auto');         
    set(filteredFigureFromMatlabZoomed,'PaperOrientation','landscape');
    set(filteredFigureFromMatlabZoomed,'Position',[50 50 1200 800]);
    print(filteredFigureFromMatlabZoomed, '-dpdf', strcat('./Figures/',num2str(measurement_number),'/filteredFigureFromMatlabZoomed',num2str(measurement_number),'.pdf'))

elseif measurement_number>=5
    
    angularPositionMeasurementFigure = figure;
    plot(t,angPos);
    hold on;
    xlim([0 t(end)])
%     ylim(y_limiting)
    title('Angular Position');
    legend('Encoder Measurement');
    % legend('Encoder Measurement','Kalman Result');
    % plot(t(2:end),filtered_angPos(2:end))
    set(angularPositionMeasurementFigure,'PaperPositionMode','auto');         
    set(angularPositionMeasurementFigure,'PaperOrientation','landscape');
    set(angularPositionMeasurementFigure,'Position',[50 50 1200 800]);
    print(angularPositionMeasurementFigure, '-dpdf', strcat('./Figures/',num2str(measurement_number),'//angularPositionMeasurementFigure_',num2str(measurement_number),'.pdf'));

    filteredFigureDirectlyMeasured = figure;
    subplot(2,1,1)
    plot(t,angPos);
    hold on;
    plot(t(2:end),filtered_angPos(2:end))
    xlim([5 5.5]);
    % ylim([95 110]);
    legend('Encoder Measurement','Filtered Position in Tiva C');
    subplot(2,1,2)
    plot(t, gyro_angVel);
    xlim([5 5.5]);
    legend('Gyroscope Measurement');
    title('Results');
    % legend('Encoder Measurement','Kalman Result');
    % plot(t(2:end),filtered_angPos(2:end))
    set(filteredFigureDirectlyMeasured,'PaperPositionMode','auto');         
    set(filteredFigureDirectlyMeasured,'PaperOrientation','landscape');
    set(filteredFigureDirectlyMeasured,'Position',[50 50 1200 800]);
    print(filteredFigureDirectlyMeasured, '-dpdf', strcat('./Figures/',num2str(measurement_number),'/filteredFigureDirectlyMeasured_',num2str(measurement_number),'.pdf'))

    filteredFigureDirectlyMeasured = figure;
    plot(t,angPos);
    hold on;
    plot(t(2:end),filtered_angPos(2:end))
    xlim([5.155 5.2]);
%     ylim([104 107]);
    legend('Encoder Measurement','Filtered Position in Tiva C');

    set(filteredFigureDirectlyMeasured,'PaperPositionMode','auto');         
    set(filteredFigureDirectlyMeasured,'PaperOrientation','landscape');
    set(filteredFigureDirectlyMeasured,'Position',[50 50 1200 800]);
    print(filteredFigureDirectlyMeasured, '-dpdf', strcat('./Figures/',num2str(measurement_number),'/filteredFigureDirectlyMeasuredZoomed',num2str(measurement_number),'.pdf'))
end

clc
