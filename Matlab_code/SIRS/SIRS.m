%% SOFA criteria
function [sirs_score, sirs_sepsis, position] = SIRS(intervals,start_time,out_time,...
    exists_respiratory_rate, exists_pco2,...
    exists_temperature, exists_heart_rate,...
    exists_wbc, sepsis_flag,...
    respiratory_rate_values, pco2_values,...
    temperature_values, heart_rate_values,...
    wbc_values)

    sirs_reference = 2;
    sirs_sepsis = 0;
    position = 0;

    sirs_score = zeros(intervals,1);
    for sample_every_15 = 1:intervals
        % RESPIRATORY ANALYSIS
        if exists_respiratory_rate == 1 || exists_pco2 == 1 
            if respiratory_rate_values(sample_every_15) > 20 || pco2_values(sample_every_15) < 43
                sirs_score(sample_every_15) = sirs_score(sample_every_15) + 1;             
            end          
        end
        % INFLAMATION ANALYSIS
        if exists_temperature == 1
            if temperature_values(sample_every_15) > 38 || temperature_values(sample_every_15) < 36
                sirs_score(sample_every_15) = sirs_score(sample_every_15) + 1;             
            end 
        end        
        % CARDIOVASCULAR ANALYSIS
        if  exists_heart_rate == 1
           if heart_rate_values(sample_every_15) > 90
                sirs_score(sample_every_15) = sirs_score(sample_every_15) + 1;             
            end 
        end
        % WHITE BLOOD CELL COUNT
        if exists_wbc == 1
            if wbc_values(sample_every_15) < 4 || wbc_values(sample_every_15) > 12
                sirs_score(sample_every_15) = sirs_score(sample_every_15) + 1;             
            end 
        end
        if sirs_score(sample_every_15) >= sirs_reference
           position = sample_every_15;
           sirs_sepsis = 1;
           sirs_reference = 100;
        end
                     
    end
end