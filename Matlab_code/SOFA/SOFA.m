%% SOFA criteria
function [sofa_score, sofa_sepsis, position] = SOFA(intervals,start_time,out_time,exists_bilirubin,...
    exists_gcs_motor,exists_gcs_verbal,exists_gcs_eye,...
    exists_creatinine,exists_dopamine,exists_dobutamine,...
    exists_epinephrine,exists_norepinephrine,exists_mbp,...
    exists_platelet,exists_fio,exists_po2,...
    exists_ventilation,exists_urine_output,sepsis_flag,bilirubin_values,...
    gcs_motor_values,gcs_verbal_values,gcs_eye_values,creatinine_values,...
    dopamine_values,dobutamine_values,epinephrine_values,...
    norepinephrine_values,mbp_values,platelet_values,fio_values,...
    po2_values,ventilation_values,urine_output_values)

    SOFA_reference = 5;
    sofa_sepsis = 0;
    position = 0;
    % Lets create first the compound values
    gcs_values = gcs_motor_values + gcs_verbal_values + gcs_eye_values;
    exists_FIO2PO2 = 0;
    if exists_fio
        if exists_po2
           FIO2PO2 = fio_values ./ po2_values;
           exists_FIO2PO2 = 1;
        end
    end
    sofa_score = zeros(intervals,1);
    for sample_every_15 = 1:intervals
        % NEUROLOGICAL ANALYSIS
        if exists_gcs_motor == 1 || exists_gcs_eye == 1 || exists_gcs_verbal
            if gcs_values(sample_every_15) <= 14 && gcs_values(sample_every_15) >= 13
                sofa_score(sample_every_15) = sofa_score(sample_every_15) + 1;             
            elseif gcs_values(sample_every_15) <= 12 && gcs_values(sample_every_15) >= 10
                sofa_score(sample_every_15) = sofa_score(sample_every_15) + 2;
            elseif gcs_values(sample_every_15) <= 9 && gcs_values(sample_every_15) >= 6
                sofa_score(sample_every_15) = sofa_score(sample_every_15) + 3;
            elseif gcs_values(sample_every_15) < 6
                sofa_score(sample_every_15) = sofa_score(sample_every_15) + 4;            
            end            
        end
        % RESPIRATORY ANALYSIS
        if exists_FIO2PO2 == 1
            if exists_ventilation == 1
                if FIO2PO2(sample_every_15) < 200 && FIO2PO2 >= 100
                    sofa_score(sample_every_15) = sofa_score(sample_every_15) + 3;             
                elseif FIO2PO2(sample_every_15) < 100 
                    sofa_score(sample_every_15) = sofa_score(sample_every_15) + 4;     
                end  
            else
                if FIO2PO2(sample_every_15) < 400 && FIO2PO2(sample_every_15) >= 300
                    sofa_score(sample_every_15) = sofa_score(sample_every_15) + 1;
                elseif FIO2PO2(sample_every_15) < 300
                    sofa_score(sample_every_15) = sofa_score(sample_every_15) + 2;
                end
                
            end
        end
        % LIVER ANALYSIS (HEPATIC)
        if exists_bilirubin == 1
            if bilirubin_values(sample_every_15) >= 1.2 && bilirubin_values(sample_every_15) < 2
                sofa_score(sample_every_15) = sofa_score(sample_every_15) + 1;             
            elseif bilirubin_values(sample_every_15) >= 2 && bilirubin_values(sample_every_15) < 6
                sofa_score(sample_every_15) = sofa_score(sample_every_15) + 2;
            elseif bilirubin_values(sample_every_15) >= 6 && bilirubin_values(sample_every_15) < 12
                sofa_score(sample_every_15) = sofa_score(sample_every_15) + 3;
            elseif bilirubin_values(sample_every_15) >= 12
                sofa_score(sample_every_15) = sofa_score(sample_every_15) + 4;            
            end
        end
        % CARDIOVASCULAR ANALYSIS
        if exists_mbp == 1 || exists_dopamine == 1 || exists_dobutamine == 1 || exists_epinephrine == 1 || exists_norepinephrine == 1
            if dopamine_values(sample_every_15) > 15 || epinephrine_values(sample_every_15) > 0.1 || norepinephrine_values(sample_every_15) > 0.1
                sofa_score(sample_every_15) = sofa_score(sample_every_15) + 4;
            elseif (dopamine_values(sample_every_15) <= 15 && dopamine_values(sample_every_15) > 5) || (epinephrine_values(sample_every_15) <= 0.1 && epinephrine_values(sample_every_15) > 0) || (norepinephrine_values(sample_every_15) <= 0.1 && norepinephrine_values(sample_every_15) > 0)
                sofa_score(sample_every_15) = sofa_score(sample_every_15) + 3;
            elseif (dopamine_values(sample_every_15) > 0 && dopamine_values(sample_every_15) <= 5) || dobutamine_values(sample_every_15) > 0
                sofa_score(sample_every_15) = sofa_score(sample_every_15) + 2;
            elseif mbp_values < 70
                sofa_score(sample_every_15) = sofa_score(sample_every_15) + 1;
            end
        end
        % RENAL ANALYSIS
        if exists_creatinine == 1
            if creatinine_values(sample_every_15) >= 5
                sofa_score(sample_every_15) = sofa_score(sample_every_15) + 4;
            elseif creatinine_values(sample_every_15) >= 3.5 && creatinine_values(sample_every_15) < 5
                sofa_score(sample_every_15) = sofa_score(sample_every_15) + 3;
            elseif creatinine_values(sample_every_15) >= 2 && creatinine_values(sample_every_15) < 3.5
                sofa_score(sample_every_15) = sofa_score(sample_every_15) + 2;
            elseif creatinine_values(sample_every_15) >= 1.2 && creatinine_values(sample_every_15) < 2
                sofa_score(sample_every_15) = sofa_score(sample_every_15) + 1;
            end
        end
        % COAGULATION
        if exists_platelet == 1
            if platelet_values(sample_every_15) < 20
                sofa_score(sample_every_15) = sofa_score(sample_every_15) + 4;
            elseif platelet_values(sample_every_15) >= 20 && platelet_values(sample_every_15) < 50
                sofa_score(sample_every_15) = sofa_score(sample_every_15) + 3;
            elseif platelet_values(sample_every_15) >= 50 && platelet_values(sample_every_15) < 100
                sofa_score(sample_every_15) = sofa_score(sample_every_15) + 2;
            elseif platelet_values(sample_every_15) >= 100 && platelet_values(sample_every_15) < 150
                sofa_score(sample_every_15) = sofa_score(sample_every_15) + 1;
            end
        end
        if sofa_score(sample_every_15) >= SOFA_reference
           position = sample_every_15;
           sofa_sepsis = 1;
           SOFA_reference = 100;
        end
    end
end