%% OPERATING WITH THE DATA

% The main idea is to check the hadm_id identificator which is sorted for
% each of the differe parameters and be able to check the SOFA scoring

% first of all you want to go through the posible adults that you want to
% evaluate. Together you want to be able to go through all the different
% parameters independently.

% ADULTS
[adults_rows, adults_columns] = size(adults_table); 
adults_counter = 0;

% Generating parameter counters
tic
% RESPIRATION
respiratory_rate_counter = 1;
pco2_counter = 1;

% TEMPERATURE
temperature_counter = 1;

% CARDIOVASCULAR
heart_rate_counter = 1;

% WHITE BLOOD CELLS
wbc_counter = 1;

% SEPSIS
sepsis_counter = 1;

% ADMISSION
admissions_counter = 1;

% WEIGHT
weight_counter = 1;

% We want to analyze it for all existing patients
i = 0;
counter = 0;
new_counter = 0;
% arrays to store flags and counters
flags = zeros(6);
counters = zeros(6);

FP = 0;
FP_counter = 0;
FN = 0;
FN_counter = 0;
TP = 0;
TP_counter = 0;
TN = 0;
TN_counter = 0;
ROC_stat = zeros(37590,9);
while(i == 0)
    % every loop adults increase in one, until we get to all of then
    adults_counter = adults_counter + 1;
    % charge adult under analysis
    hadm_id_under_analysis = adults_table(adults_counter,2).hadm_id;
    % check admission time for knowing admission interval
    [intervals, start_time, admissions_counter, out_time] ...
     =admission(hadm_id_under_analysis,admissions_counter,admission_table);
    % matrix to store measurements
    measurements = standard_measures(intervals);
    parfor all_the_different_parameters = 1:5
        % generate respiratory_rate data
        if all_the_different_parameters == 1
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)]...
                = general(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                respiratory_rate_counter, respiratory_rate_table, out_time);
        % generate pco2 data
        elseif all_the_different_parameters == 2
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)] ...
                = general(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                pco2_counter, pco2_table, out_time);
        % generate temperature data
        elseif all_the_different_parameters == 3
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)]...
                = general(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                temperature_counter , temperature_table, out_time);
        % generate heart_rate data
        elseif all_the_different_parameters == 4
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)] ...
                = general(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                heart_rate_counter, heart_rate_table, out_time);
        % generate wbc data
        elseif all_the_different_parameters == 5
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)] ...
                = general(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                wbc_counter, wbc_table, out_time);
        end
    end
    % Sepsis existance analysis
    % check if the patient wass diagnosed with any level of sepsis
    [flags(6),counters(6)] = sepsis(hadm_id_under_analysis,sepsis_counter, sepsis_table);
    % giving the values specific names
    [exists_repiratory_rate, repiratory_rate_counter,...
        exists_pco2, pco2_counter,...
        exists_temperature, temperature_counter,...
        exists_heart_rate,heart_rate_counter,...
        exists_wbc,wbc_counter,...
        sepsis_flag,sepsis_counter]...
        = parse_flags_counters(flags, counters);
    [respiratory_rate_values, pco2_vallues, ...
        temperature_values, heart_rate_values,...
        wbc_values]...
        = parse_measurements(measurements);
    [sirs_score, sirs_sepsis, position] = SIRS(intervals,start_time,out_time,...
        exists_repiratory_rate, exists_pco2,...
        exists_temperature, exists_heart_rate,...
        exists_wbc,...
        sepsis_flag,...
        respiratory_rate_values, pco2_vallues, ...
        temperature_values, heart_rate_values,...
        wbc_values);
    % analyse if the patient was diagnosed with Sepsis
    if sirs_sepsis == 1
        ROC_stat(adults_counter,1) = 1;
        ROC_stat(adults_counter,3) = position;
        if sepsis_flag == 1
           new_counter = new_counter + 1; 
           ROC_stat(adults_counter,2) = 1;
           TP = 1;
           TP_counter = TP_counter +1;
           ROC_stat(adults_counter,4) = FP_counter;
           ROC_stat(adults_counter,5) = TP_counter;
           ROC_stat(adults_counter,6) = FN_counter;
           ROC_stat(adults_counter,7) = TN_counter;
           ROC_stat(adults_counter,8) = TP_counter/(TP_counter + FN_counter);
           ROC_stat(adults_counter,9) = TN_counter/(TN_counter + FP_counter);
        else
           FP = 1;
           FP_counter = FP_counter +1;
           ROC_stat(adults_counter,4) = FP_counter;
           ROC_stat(adults_counter,5) = TP_counter;
           ROC_stat(adults_counter,6) = FN_counter;
           ROC_stat(adults_counter,7) = TN_counter;
           ROC_stat(adults_counter,8) = TP_counter/(TP_counter + FN_counter);
           ROC_stat(adults_counter,9) = TN_counter/(TN_counter + FP_counter);
        end
    else
        if sepsis_flag == 1
           new_counter = new_counter + 1; 
           ROC_stat(adults_counter,2) = 1;
           FN = 1;
           FN_counter = FN_counter +1;
           ROC_stat(adults_counter,4) = FP_counter;
           ROC_stat(adults_counter,5) = TP_counter;
           ROC_stat(adults_counter,6) = FN_counter;
           ROC_stat(adults_counter,7) = TN_counter;
           ROC_stat(adults_counter,8) = TP_counter/(TP_counter + FN_counter);
           ROC_stat(adults_counter,9) = TN_counter/(TN_counter + FP_counter);
        else
           TN = 1;
           TN_counter = TN_counter +1;
           ROC_stat(adults_counter,4) = FP_counter;
           ROC_stat(adults_counter,5) = TP_counter;
           ROC_stat(adults_counter,6) = FN_counter;
           ROC_stat(adults_counter,7) = TN_counter;
           ROC_stat(adults_counter,8) = TP_counter/(TP_counter + FN_counter);
           ROC_stat(adults_counter,9) = TN_counter/(TN_counter + FP_counter);
        end            
    end
    % plot results
    %plot_function(intervals, sirs_score, sepsis_flag, counter)
    % stop counter for debugging
    % if counter == 5
    %   i = 1; 
    % end
    % This is for finishing the analysis
    counter = counter + 1;
    if counter == 37590        
       i = 1; 
    end
end
save('saveROC_stat_SIRS.mat','ROC_stat');
toc
