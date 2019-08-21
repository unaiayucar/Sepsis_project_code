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

% RESPIRATION
fio2_chart_counter = 1;
fio2_lab_counter = 1;
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
flags = zeros(17);
counters = zeros(17);
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
    parfor all_the_different_parameters = 1:16
        % generate creatinine data
        if all_the_different_parameters == 1
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)]...
                = doctor_g(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                creatinine_counter, creatinine_table, out_time);
        % generate bilirubin data
        elseif all_the_different_parameters == 2
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)] ...
                = doctor_g(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                bilirubin_counter, bilirubin_table, out_time);
        % generate gcs_motor data
        elseif all_the_different_parameters == 3
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)]...
                = doctor_g(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                gcs_motor_counter, gcs_motor_table, out_time);
        % generate gcs_verbal data
        elseif all_the_different_parameters == 4
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)] ...
                = doctor_g(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                gcs_verbal_counter, gcs_verbal_table, out_time);
        % generate gcs_eye data
        elseif all_the_different_parameters == 5
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)] ...
                = doctor_g(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                gcs_eye_counter, gcs_eye_table, out_time);
        % generate dopamine data
        elseif all_the_different_parameters == 6
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)] ...
                = doctor_g(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                dopamine_counter, dopamine_table, out_time);
        % generate dobutamine data
        elseif all_the_different_parameters == 7
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)] ...
                = doctor_g(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                dobutamine_counter, dobutamine_table, out_time);
        % generate epinephrine data
        elseif all_the_different_parameters == 8
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)]...
                = doctor_g(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                epinephrine_counter, epinephrine_table, out_time);
        % generate norepinephrine data
        elseif all_the_different_parameters == 9
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)]...
                = doctor_g(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                norepinephrine_counter, norepinephrine_table, out_time);
        % generate meanBP data
        elseif all_the_different_parameters == 10
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)]...
                = doctor_g(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                mbp_counter, mbp_table, out_time);
        % generate Platelet count data
        elseif all_the_different_parameters == 11
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)] ...
                = doctor_g(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                platelet_counter, platelet_table, out_time);
        % generate fio2 chart data
        elseif all_the_different_parameters == 12 %(fio chart)
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)]...
                = doctor_g(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                fio2_chart_counter, FIO2_chart_table, out_time);
        %generate fio2 lab data
        elseif all_the_different_parameters == 13 %(fio lab)
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)] ...
                = doctor_g(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                fio2_lab_counter, FIO2_table, out_time);
        % generate PO2 data
        elseif all_the_different_parameters == 14 % (po2)
            [measurements(all_the_different_parameters,:),...
                flags(all_the_different_parameters),...
                counters(all_the_different_parameters)]...
                = doctor_g(measurements(all_the_different_parameters,:),...
                hadm_id_under_analysis, intervals, start_time,...
                po2_counter, PO2_table, out_time);
        % Ventilation assistance data
        elseif all_the_different_parameters == 15 % (ventilation help)
            measurements(all_the_different_parameters,:)...
                 = zeros(1,intervals);
            flags(all_the_different_parameters) = 0;
            counters(all_the_different_parameters) = 1;
        elseif all_the_different_parameters == 16 % (urine output)
            measurements(all_the_different_parameters,:)...
                = zeros(1,intervals);
            flags(all_the_different_parameters) = 0;
            counters(all_the_different_parameters) = 1;
        end
    end
    % Sepsis existance analysis
    % check if the patient wass diagnosed with any level of sepsis
    [flags(17),counters(17)] = sepsis(hadm_id_under_analysis,sepsis_counter, sepsis_table);
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
        exists_fio_chart,fio2_chart_counter,...
        exists_fio_lab,fio2_lab_counter,...
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
        fio_chart_values,fio_lab_values,...
        po2_values,ventilation_values,...
        urine_output_values]...
        = parse_measurements(measurements);
    sofa_score = SOFA(intervals,start_time,out_time,...
        exists_bilirubin,exists_gcs_motor,...
        exists_gcs_verbal,exists_gcs_eye,...
        exists_creatinine,exists_dopamine,...
        exists_dobutamine,exists_epinephrine,...
        exists_norepinephrine,exists_mbp,....
        exists_platelet,exists_fio_chart,exists_fio_lab,...
        exists_po2,exists_ventilation,exists_urine_output,...
        sepsis_flag,...
        bilirubin_values,creatinine_values,...
        gcs_motor_values,gcs_verbal_values,gcs_eye_values,...
        dopamine_values,dobutamine_values,...
        epinephrine_values,norepinephrine_values,...
        mbp_values,platelet_values,...
        fio_chart_values,fio_lab_values,...
        po2_values,ventilation_values,...
        urine_output_values);
    % analyse if the patient was diagnosed with Sepsis
    if sepsis_flag == 1
       new_counter = new_counter + 1; 
    end
    % plot results
    plot_function(intervals, sofa_score, sepsis_flag, counter)
    % stop counter for debugging
    if counter == 5
       i = 1; 
    end
    % This is for finishing the analysis
    counter = counter + 1;
    if counter == 37590        
       i = 1; 
    end
end

new_counter
