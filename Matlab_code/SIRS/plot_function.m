function plot_function(intervals, sofa_score, sepsis_flag, counter)
    figure();
    plot(1:intervals, sofa_score)
    hold on;
    xlabel('time')
    ylabel('Sofa Score')
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
    if sepsis_flag == 1
       title(['Patient',num2str(counter),' with sepsis'])
    else
       title(['Patient',num2str(counter)]) 
    end
    ylim([-1,20])
    hold off;

end