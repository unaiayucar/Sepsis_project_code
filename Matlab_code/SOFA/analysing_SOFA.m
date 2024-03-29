%% OPERATING WITH THE DATA

% The main idea is to check the hadm_id identificator which is sorted for
% each of the differe parameters and be able to check the SOFA scoring

% first of all you want to go through the posible adults that you want to
% evaluate. Together you want to be able to go through all the different
% parameters independently.

% ADULTS
[adults_rows, adults_columns] = size(adults_table); 
adults_counter = 0;
% Size of the tables
[bilirubin_rows, bilirubin_columns] = size(bilirubin_table);
% Generating parameter counters
tic
% RESPIRATION
fio2_counter = 1;
po2_counter = 1;
ventilation_counter = 1;
paofio_counter = 1;
paofio_vent_counter = 1;

% NEUROLOGICAL
gcs_counter = 1;
gcs_motor_counter = 1;
gcs_verbal_counter = 1;
gcs_eye_counter = 1;

% CARDIOVASCULAR
mbp_counter = 1;
dopamine_counter = 1;
norepinephrine_counter = 1;
epinephrine_counter = 1;
dobutamine_counter = 1;

% LIVER
bilirubin_counter = 1;

% COAGULATION
platelet_counter = 1;

% RENAL
creatinine_counter = 1;
urine_output_counter = 1;

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
flags = zeros(16);
counters = zeros(16);

FP = 0;
FP_counter = 0;
FN = 0;
FN_counter = 0;
TP = 0;
TP_counter = 0;
TN = 0;
TN_counter = 0;
ROC_stat = zeros(37590,9);
sp = 0;
counter2 = 3;
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
    parfor all_the_different_parameters = 1:15
        % generate creatinine data
        if all_the_different_parameters == 1
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)]...
                = general(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                creatinine_counter, creatinine_table, out_time);
        % generate bilirubin data
        elseif all_the_different_parameters == 2
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)] ...
                = general(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                bilirubin_counter, bilirubin_table, out_time);
        % generate gcs_motor data
        elseif all_the_different_parameters == 3
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)]...
                = general(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                gcs_motor_counter, gcs_motor_table, out_time);
        % generate gcs_verbal data
        elseif all_the_different_parameters == 4
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)] ...
                = general(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                gcs_verbal_counter, gcs_verbal_table, out_time);
        % generate gcs_eye data
        elseif all_the_different_parameters == 5
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)] ...
                = general(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                gcs_eye_counter, gcs_eye_table, out_time);
        % generate dopamine data
        elseif all_the_different_parameters == 6
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)] ...
                = general(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                dopamine_counter, dopamine_table, out_time);
        % generate dobutamine data
        elseif all_the_different_parameters == 7
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)] ...
                = general(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                dobutamine_counter, dobutamine_table, out_time);
        % generate epinephrine data
        elseif all_the_different_parameters == 8
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)]...
                = general(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                epinephrine_counter, epinephrine_table, out_time);
        % generate norepinephrine data
        elseif all_the_different_parameters == 9
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)]...
                = general(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                norepinephrine_counter, norepinephrine_table, out_time);
        % generate meanBP data
        elseif all_the_different_parameters == 10
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)]...
                = general(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                mbp_counter, mbp_table, out_time);
        % generate Platelet count data
        elseif all_the_different_parameters == 11
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)] ...
                = general(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                platelet_counter, platelet_table, out_time);
        % generate fio2 data
        elseif all_the_different_parameters == 12 %(fio2)
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)]...
                = general(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                fio2_counter, FIO2_table, out_time);
        % generate PO2 data
        elseif all_the_different_parameters == 13 % (po2)
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)]...
                = general(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                po2_counter, PO2_table, out_time);
        % Ventilation assistance data
        elseif all_the_different_parameters == 14 % (ventilation help)
            measurements(all_the_different_parameters,:)...
                 = zeros(1,intervals);
            flags(all_the_different_parameters) = 0;
            counters(all_the_different_parameters) = 1;
        elseif all_the_different_parameters == 15 % (urine output)
            measurements(all_the_different_parameters,:)...
                = zeros(1,intervals);
            flags(all_the_different_parameters) = 0;
            counters(all_the_different_parameters) = 1;
        end
    end
    % Sepsis existance analysis
    % check if the patient wass diagnosed with any level of sepsis
    [flags(16),counters(16)] = sepsis(hadm_id_under_analysis,sepsis_counter, sepsis_table);
    % giving the values specific names
    [exists_bilirubin,bilirubin_counter,...
        exists_gcs_motor,gcs_motor_counter,...
        exists_gcs_verbal,gcs_verbal_counter,...
        exists_gcs_eye,gcs_eye_counter,...
        exists_creatinine,creatinine_counter,...
        exists_dopamine,dopamine_counter,...
        exists_dobutamine,dobutamine_counter,...
        exists_epinephrine,epinephrine_counter,...
        exists_norepinephrine,norepinephrine_counter,...
        exists_mbp,mbp_counter,...
        exists_platelet,platelet_counter,...
        exists_fio,fio2_counter,...
        exists_po2,po2_counter,...
        exists_ventilation, ventilation_counter,...
        exists_urine_output,urine_output_counter,...
        sepsis_flag,sepsis_counter]...
        = parse_flags_counters(flags, counters);
    [bilirubin_values,creatinine_values,...
        gcs_motor_values,gcs_verbal_values,gcs_eye_values,...
        dopamine_values,dobutamine_values,...
        epinephrine_values,norepinephrine_values,...
        mbp_values,platelet_values,...
        fio_values,...
        po2_values,ventilation_values,...
        urine_output_values]...
        = parse_measurements(measurements);
    [sofa_score,sofa_sepsis,position] = SOFA(intervals,start_time,out_time,...
        exists_bilirubin,exists_gcs_motor,...
        exists_gcs_verbal,exists_gcs_eye,...
        exists_creatinine,exists_dopamine,...
        exists_dobutamine,exists_epinephrine,...
        exists_norepinephrine,exists_mbp,....
        exists_platelet,exists_fio,...
        exists_po2,exists_ventilation,exists_urine_output,...
        sepsis_flag,...
        bilirubin_values,creatinine_values,...
        gcs_motor_values,gcs_verbal_values,gcs_eye_values,...
        dopamine_values,dobutamine_values,...
        epinephrine_values,norepinephrine_values,...
        mbp_values,platelet_values,...
        fio_values,...
        po2_values,ventilation_values,...
        urine_output_values);
    
    if sofa_sepsis == 1
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
    % plot_function(intervals, sofa_score, sepsis_flag, counter)
    % stop counter for debugging
    % if counter == 37579
    %   a = 1; 
    % end
    % This is for finishing the analysis
    
%     if counter == 10
%         if sepsis_flag == 1
%             
%             sepsis_case = zeros(30,intervals);
%             
%             sepsis_case(1,:) = exists_bilirubin;
%             sepsis_case(2,:) = bilirubin_values;
%             sepsis_case(3,:) = exists_creatinine 
%             sepsis_case(4,:) = creatinine_values
%             sepsis_case(5,:) = exists_gcs_motor 
%             sepsis_case(6,:) = gcs_motor_values
%             sepsis_case(7,:) = exists_gcs_verbal 
%             sepsis_case(8,:) = gcs_verbal_values
%             sepsis_case(9,:) = exists_gcs_eye
%             sepsis_case(10,:) = gcs_eye_values
%             sepsis_case(11,:) = exists_dopamine
%             sepsis_case(12,:) = dopamine_values
%             sepsis_case(13,:) = exists_dobutamine
%             sepsis_case(14,:) = dobutamine_values
%             sepsis_case(15,:) = exists_epinephrine
%             sepsis_case(16,:) = epinephrine_values
%             sepsis_case(17,:) = exists_norepinephrine
%             sepsis_case(18,:) = norepinephrine_values
%             sepsis_case(19,:) = exists_mbp
%             sepsis_case(20,:) = mbp_values
%             sepsis_case(21,:) = exists_platelet
%             sepsis_case(22,:) = platelet_values
%             sepsis_case(23,:) = exists_fio
%             sepsis_case(24,:) = fio_values
%             sepsis_case(25,:) = exists_po2
%             sepsis_case(26,:) = po2_values
%             sepsis_case(27,:) = exists_ventilation
%             sepsis_case(28,:) = ventilation_values
%             sepsis_case(29,:) = exists_urine_output
%             sepsis_case(30,:) = urine_output_values
%             
%         elseif
%             
%         end
%         
%     end

%     if sepsis_flag == 1
%         sp = sp +1;
%     end
%     if sp == 3
%         if sepsis_flag == 1
%         %sp = sp +1;
%         counter2 = counter2 + 1;
%         disp('seps')
%         plot_function(intervals, sofa_score, sepsis_flag, counter2)
%         end
%     elseif sp >= 6
%         if sepsis_flag ==1
%         counter2 = counter2 + 1;
%         disp('seps')
%         plot_function(intervals, sofa_score, sepsis_flag, counter2)
%         else
%           counter2 = counter2 + 1;
%         disp('no seps')
%         plot_function(intervals, sofa_score, sepsis_flag, counter2)  
%         end
%     end
%     if counter2 == 6
%         i = 1;
%     end
        
    
    counter = counter + 1;
    if counter == 37590        
       i = 1; 
    end
end
sp
save('saveROC_stat_SOFA.mat','ROC_stat');
toc