function [sepsis_flag, sepsis_counter] ...
    = sepsis(hadm_id, sepsis_counter, sepsis_table)

    % this fucntion gives back a flag announcing if the patient was
    % diagnosed with sepsis or not.
    if sepsis_counter <= height(sepsis_table)
        sepsis_hadm_id = sepsis_table(sepsis_counter,2).hadm_id;
        out = 0;
        % generate the flag with default value to 0
        sepsis_flag = 0;

         % case in new analysis both hadm_id are equal
       if sepsis_hadm_id == hadm_id 
           % found a match, we set the flag up
           sepsis_flag = 1;
           % we increase the counter
           sepsis_counter = sepsis_counter + 1;
       elseif sepsis_hadm_id < hadm_id
           % we have to increase the value of the counter until we reach 
           % the desired value or, we over pass it
           while(out == 0)
              sepsis_counter = sepsis_counter + 1;
              sepsis_hadm_id = sepsis_table(sepsis_counter,2).hadm_id;
              if sepsis_hadm_id == hadm_id
                 sepsis_flag = 1;
                 sepsis_counter = sepsis_counter + 1;
                 out = 1;
              elseif sepsis_hadm_id >  hadm_id
                 out = 1; 
              end          
           end
       end    
    else
        sepsis_flag = 0;
    end
end