function [bilirubin_array, exists_bilirubin, bilirubin_counter] = bilirubin(hadm_id, intervals, start_time, bilirubin_counter, bilirubin_table)
    if bilirubin_counter <= height(bilirubin_table)
       % take new hadmm_id and set variables to start values   
       bilirubin_hadm_id = bilirubin_table(bilirubin_counter,2).hadm_id; 
       out = 0;
       out2 = 0;
       fill_samples_count = 1; % for the intervals (filling the 0s vector)
       T = '15:00';
       infmt = 'mm:ss';
       D = duration(T,'InputFormat',infmt);
       T0 = '00:00:00';
       infmt = 'hh:mm:ss';
       D0 = duration(T0,'InputFormat',infmt);
       T1 = '00:00:01';
       D1 = duration(T1, 'InputFormat', infmt);
       exists_bilirubin = 0; % existance flag
       save_last_value_previous_to_ICU = 0; % In case there are values 
       % previous to ICU
       % we create the answer vector (thats the normal bilirubin value)
       bilirubin_array(1:intervals) = 1.2;

       % case in new analysis both hadm_id are equal
       if bilirubin_hadm_id == hadm_id 
          % We analyze the data until new value shows
          while(out == 0) 
              % we take the time of the sample taken
              time_of_sample = bilirubin_table(bilirubin_counter,3).charttime;
              % substract it to initial
              actual_time_dif = time_of_sample - start_time;
              if actual_time_dif == D0
                 actual_time_dif = D1; 
              end
              intervals_double = actual_time_dif/D;
              % If it is negative, that means that was a value previous to ICU
              if intervals_double < 0
                  % The values was taken previous to ICU, not into account
                  save_last_value_previous_to_ICU = bilirubin_table(bilirubin_counter,5).valuenum;
                  bilirubin_counter = bilirubin_counter + 1;
              elseif (0<= intervals_double)&&(intervals_double<1)
                 % smaller than one and possitive, within 15 mimuntes to start
                 if fill_samples_count == 1
                     % filling not started yet
                     bilirubin_array(fill_samples_count) = bilirubin_table(bilirubin_counter, 5).valuenum;
                     new_intervals = ceil(intervals_double);
                     fill_samples_count = fill_samples_count + new_intervals;
                     bilirubin_counter = bilirubin_counter + 1;
                     exists_bilirubin = 1;
                 else
                     % filling already started, need to take into account new
                     % values
                     value1 = bilirubin_array(fill_samples_count -1);
                     value2 = bilirubin_table(bilirubin_counter,5).valuenum;
                     definitive_val = (value1 + value2)/2;
                     bilirubin_array(fill_samples_count - 1, 1) = definitive_val;
                     bilirubin_counter = bilirubin_counter + 1;
                     exists_bilirubin = 1;
                 end
              else
                 if fill_samples_count == 1
                     if save_last_value_previous_to_ICU == 0
                         new_intervals = ceil(intervals_double);
                         new_value = bilirubin_table(bilirubin_counter,5).valuenum;
                         bilirubin_array(fill_samples_count + new_intervals) = new_value ; 
                         bilirubin_counter = bilirubin_counter + 1; 
                         start_time = start_time + (new_intervals)*D;
                         fill_samples_count = fill_samples_count + new_intervals;
                         exists_bilirubin = 1;
                     else
                         new_intervals = ceil(intervals_double);
                         old_value = save_last_value_previous_to_ICU;
                         new_value = bilirubin_table(bilirubin_counter,5).valuenum;
                         %{
                         differential = (new_value - old_value)/new_intervals;
                         if differential == 0
                            gcs_verbal_array(fill_samples_count:(new_intervals + fill_samples_count)-1) = old_value; 
                         else                     
                            gcs_verbal_array(fill_samples_count:(new_intervals + fill_samples_count)-1) = old_value;%(old_value + differential):differential:new_value ; 
                         end
                         %}
                         bilirubin_array(fill_samples_count:(new_intervals + fill_samples_count)-1) = old_value;
                         bilirubin_counter = bilirubin_counter + 1;
                         start_time = start_time + (new_intervals)*D;
                         fill_samples_count = fill_samples_count + new_intervals;
                         exists_bilirubin = 1;
                     end
                 else
                     new_intervals = ceil(intervals_double);
                     old_value = bilirubin_array(fill_samples_count -1);
                     new_value = bilirubin_table(bilirubin_counter,5).valuenum;
                     differential = (new_value - old_value)/new_intervals;
                     if differential == 0
                         bilirubin_array(fill_samples_count:(new_intervals + fill_samples_count)-1) = old_value; 
                     else                     
                        bilirubin_array(fill_samples_count:(new_intervals + fill_samples_count)-1) = (old_value + differential):differential:new_value ; 
                     end
                     bilirubin_counter = bilirubin_counter + 1; 
                     start_time = start_time + (new_intervals)*D;
                     fill_samples_count = fill_samples_count + new_intervals;
                     exists_bilirubin = 1;
                 end
              end
              if bilirubin_table(bilirubin_counter, 2).hadm_id ~= hadm_id
                  if exists_bilirubin == 1
                     bilirubin_array(fill_samples_count:end) = bilirubin_array(fill_samples_count -1);
                  end              
                  out = 1;
              end

          end

       elseif bilirubin_hadm_id < hadm_id
          while(out2 == 0)
              bilirubin_counter = bilirubin_counter + 1;
              if bilirubin_table(bilirubin_counter, 2).hadm_id == hadm_id
                  % We analyze the data until new value shows
                  while(out == 0) 
                      % we take the time of the sample taken
                      time_of_sample = bilirubin_table(bilirubin_counter,3).charttime;
                      % substract it to initial
                      actual_time_dif = time_of_sample - start_time;
                      if actual_time_dif == D0
                        actual_time_dif = D1; 
                      end
                      intervals_double = actual_time_dif/D;
                      % If it is negative, that means that was a value previous to ICU
                      if intervals_double < 0
                          % The values was taken previous to ICU, not into account
                          save_last_value_previous_to_ICU = bilirubin_table(bilirubin_counter,5).valuenum;
                          bilirubin_counter = bilirubin_counter + 1;
                      elseif (0<= intervals_double)&&(intervals_double<1)
                         % smaller than one and possitive, within 15 mimuntes to start
                         if fill_samples_count == 1
                             % filling not started yet
                             bilirubin_array(fill_samples_count) = bilirubin_table(bilirubin_counter, 5).valuenum;
                             new_intervals = ceil(intervals_double);
                             fill_samples_count = fill_samples_count + new_intervals;
                             bilirubin_counter = bilirubin_counter + 1;
                             exists_bilirubin = 1;
                         else
                             % filling already started, need to take into account new
                             % values
                             value1 = bilirubin_array(fill_samples_count -1);
                             value2 = bilirubin_table(bilirubin_counter,5).valuenum;
                             definitive_val = (value1 + value2)/2;
                             bilirubin_array(fill_samples_count - 1) = definitive_val;
                             bilirubin_counter = bilirubin_counter + 1;
                             exists_bilirubin = 1;
                         end
                      else
                         if fill_samples_count == 1
                             if save_last_value_previous_to_ICU == 0
                                 new_intervals = ceil(intervals_double);
                                 new_value = bilirubin_table(bilirubin_counter,5).valuenum;
                                 bilirubin_array(new_intervals + fill_samples_count) = new_value ; 
                                 bilirubin_counter = bilirubin_counter + 1; 
                                 start_time = start_time + (new_intervals)*D;
                                 fill_samples_count = fill_samples_count + new_intervals;
                                 exists_bilirubin = 1;
                             else
                                 new_intervals = ceil(intervals_double);
                                 old_value = save_last_value_previous_to_ICU;
                                 new_value = bilirubin_table(bilirubin_counter,5).valuenum;
                                 %{
                                 differential = (new_value - old_value)/new_intervals;                             
                                 if differential == 0
                                    gcs_verbal_array(fill_samples_count:(new_intervals + fill_samples_count)-1) = old_value; 
                                 else                     
                                    gcs_verbal_array(fill_samples_count:(new_intervals + fill_samples_count)-1) = old_value;%(old_value + differential):differential:new_value ; 
                                 end
                                 %}
                                 bilirubin_array(fill_samples_count:(new_intervals + fill_samples_count)-1) = old_value; % this is replacing previous comment
                                 bilirubin_counter = bilirubin_counter + 1;
                                 start_time = start_time + (new_intervals)*D;
                                 fill_samples_count = fill_samples_count + new_intervals;
                                 exists_bilirubin = 1;
                             end
                         else
                             new_intervals = ceil(intervals_double);
                             old_value = bilirubin_array(fill_samples_count -1);
                             new_value = bilirubin_table(bilirubin_counter,5).valuenum;
                             differential = (new_value - old_value)/new_intervals;
                             if differential == 0
                                bilirubin_array(fill_samples_count:(new_intervals + fill_samples_count)-1) = old_value; 
                             else                     
                                bilirubin_array(fill_samples_count:(new_intervals + fill_samples_count)-1) = (old_value + differential):differential:new_value ; 
                             end
                             bilirubin_counter = bilirubin_counter + 1; 
                             start_time = start_time + (new_intervals)*D;
                             fill_samples_count = fill_samples_count + new_intervals;
                             exists_bilirubin = 1;
                         end
                      end
                      if bilirubin_table(bilirubin_counter, 2).hadm_id ~= hadm_id
                          if exists_bilirubin == 1
                             bilirubin_array(fill_samples_count:end) = bilirubin_array(fill_samples_count -1);
                          end  
                          out = 1;
                          out2 = 1;
                      end
                  end
              elseif bilirubin_table(bilirubin_counter, 2).hadm_id > hadm_id
                  out2 = 1;
              end
          end      
       end
    else
        bilirubin_array(1:intervals) = 1.2;
        bilirubin_counter = 0;
    end
end