function plot_function(intervals, sofa_score, sepsis_flag, counter)

    

    
    constant_sepsis = zeros(intervals);
    constant_severe_sepsis = zeros(intervals);
    constant_septic_shock = zeros(intervals);
    constant_sepsis(:) = 2;
    constant_severe_sepsis(:) = 8;
    constant_septic_shock(:) = 12;
    %plot(1:intervals, constant_sepsis)
    %plot(1:intervals, constant_severe_sepsis)
    %plot(1:intervals, constant_septic_shock)
    %legend('Sofa Score/time','sepsis clasic','severe sepsis','septic shock'); 
    
%% Plot the values and save the PDF
    fontSize = 15;
    lineWidth = 2;
    aspectRatio = 1.5;
    %Title = 'Creatinine values over tiem';
    Title = 'Applying SIRS criteria under doctors assumption';
    xLab = 'Samples x15 minutes';
    %yLab = 'mg/dl';
    yLab = 'SIRS score';
    count = int2str(counter);
    fileName = 'figure';
    fileName = strcat(fileName,count);

    figure('Name','Fig. 1','NumberTitle','off')
    plotAspect =[aspectRatio 1 1];
    
    plot(1:intervals, sofa_score);
    
    %scatter(X,Y,'filled');
    hold on;
%     plot(X,S1);
%     plot(X,S2); 
%     plot(X,S3);
%     plot(X,S4);
%     legend('Sampled data','> +1 SOFA', '> +2 SOFA', '> +3 SOFA', '> +4 SOFA');
%legend('Sampled data');

legend('SIRS values through time')
    
    title(Title, 'Interpreter', 'LaTeX');
    xlabel(xLab, 'Interpreter', 'LaTeX', 'FontSize', fontSize);
    ylabel(yLab, 'Interpreter', 'LaTeX', 'FontSize', fontSize);
    % Change font size of axis labels
    set(gca, 'FontSize', fontSize);
    pbaspect(plotAspect);
    axis( [0 intervals 0 5] );
    % Correct the number of ticks
    set(gca, 'YTick', -1:1:5);
    % Relate the size of the figure to its actual size (21cm -> A4 width)
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperSize', [21 21/aspectRatio]); % [Width Height]
    set(gcf, 'PaperPosition', [0 0 21 21/aspectRatio]); % [Left Bottom Width Height]
    % Print to PDF
    print(fileName,'-dpdf')


end