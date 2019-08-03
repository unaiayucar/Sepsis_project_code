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
paofio_counter = 1;
paofio_vent_counter = 1;

% NEUROLOGICAL
gcs_counter = 1;
gcs_motor_counter = 1;
gcs_verbal_counter = 1;
gcs_eye_counter = 1;

% CARDIOVASCULAR
map_counter = 1;
dopamine_counter = 1;
norepinephrine_counter = 1;
epirephrine_counter = 1;
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

% We want to analyze it for all existing patients
i = 0;
counter = 0;
new_counter = 0;
% arrays to store flags and counters
flags = zeros(7);
counters = zeros(7);
while(i == 0)
    % every loop adults increase in one, until we get to all of then
    adults_counter = adults_counter + 1;
    % charge adult under analysis
    hadm_id_under_analysis = adults_table(adults_counter,2).hadm_id;
    % check admission time for knowing admission interval
    [intervals, start_time, admissions_counter, out_time] = admission(hadm_id_under_analysis, admissions_counter, admission_table);
    % matrix to store measurements
    measurements = zeros(5,intervals);
    parfor all_the_different_parameters = 1:6
        % generate creatinine data
        if all_the_different_parameters == 1
            [measurements(all_the_different_parameters,:), flags(all_the_different_parameters), counters(all_the_different_parameters)] = general(hadm_id_under_analysis, intervals, start_time, creatinine_counter, creatinine_table, out_time);
        % generate bilirubin data
        elseif all_the_different_parameters == 2
            [measurements(all_the_different_parameters,:), flags(all_the_different_parameters), counters(all_the_different_parameters)] = general(hadm_id_under_analysis, intervals, start_time, bilirubin_counter, bilirubin_table, out_time);
        % generate gcs_motor data
        elseif all_the_different_parameters == 3
            [measurements(all_the_different_parameters,:), flags(all_the_different_parameters), counters(all_the_different_parameters)] = general(hadm_id_under_analysis, intervals, start_time, gcs_motor_counter, gcs_motor_table, out_time);
        % generate gcs_verbal data
        elseif all_the_different_parameters == 4
            [measurements(all_the_different_parameters,:), flags(all_the_different_parameters), counters(all_the_different_parameters)] = general(hadm_id_under_analysis, intervals, start_time, gcs_verbal_counter, gcs_verbal_table, out_time);
        % generate gcs_eye data
        elseif all_the_different_parameters == 5
            [measurements(all_the_different_parameters,:), flags(all_the_different_parameters), counters(all_the_different_parameters)] = general(hadm_id_under_analysis, intervals, start_time, gcs_eye_counter, gcs_eye_table, out_time);
        % check if the patient wass diagnosed with any level of sepsis
        elseif all_the_different_parameters == 6
            [flags(all_the_different_parameters), counters(all_the_different_parameters)] = sepsis(hadm_id_under_analysis, sepsis_counter, sepsis_table);
        end
    end
    [exists_bilirubin,bilirubin_counter,exists_gcs_motor,gcs_motor_counter,exists_gcs_verbal,gcs_verbal_counter,exists_gcs_eye,gcs_eye_counter,exists_creatinine,creatinine_counter,sepsis_flag,sepsis_counter]= parse_flags_counters(flags, counters);
    [bilirubin_values,gcs_motor_values,gcs_verbal_values,gcs_eye_values,creatinine_values] = parse_measurements(measurements);
    
    if sepsis_flag == 1
       new_counter = new_counter + 1; 
    end
    if length(bilirubin_values)~= intervals || length(gcs_motor_values) ~= intervals || length(gcs_eye_values)~= intervals || length(gcs_verbal_values) ~= intervals
        b = 1;
    end
    % This is for finishing the analysis
    counter = counter + 1;
    if counter == 37590        
       i = 1; 
    end
end

new_counter
