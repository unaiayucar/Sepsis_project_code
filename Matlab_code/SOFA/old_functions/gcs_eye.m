function [gcs_eye_array, exists_gcs_eye, gcs_eye_counter] = gcs_eye(hadm_id, intervals, start_time, gcs_eye_counter, gcs_eye_table)
    if gcs_eye_counter <= height(gcs_eye_table)
       % take new hadmm_id and set variables to start values   
       eye_hadm_id = gcs_eye_table(gcs_eye_counter,2).hadm_id; 
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
       exists_gcs_eye = 0; % existance flag
       save_last_value_previous_to_ICU = 0; % In case there are values 
       % previous to ICU
       % we create the answer vector 
       gcs_eye_array(1:intervals) = 4;

       % case in new analysis both hadm_id are equal
       if eye_hadm_id == hadm_id 
          % We analyze the data until new value shows
          while(out == 0) 
              % we take the time of the sample taken
              time_of_sample = gcs_eye_table(gcs_eye_counter,3).charttime;
              % substract it to initial
              actual_time_dif = time_of_sample - start_time;
              if actual_time_dif == D0
                 actual_time_dif = D1; 
              end
              intervals_double = actual_time_dif/D;
              % If it is negative, that means that was a value previous to ICU
              if intervals_double < 0
                  % The values was taken previous to ICU, not into account
                  save_last_value_previous_to_ICU = gcs_eye_table(gcs_eye_counter,5).valuenum;
                  gcs_eye_counter = gcs_eye_counter + 1;
              elseif (0<= intervals_double)&&(intervals_double<1)
                 % smaller than one and possitive, within 15 mimuntes to start
                 if fill_samples_count == 1
                     % filling not started yet
                     gcs_eye_array(fill_samples_count) = gcs_eye_table(gcs_eye_counter, 5).valuenum;
                     new_intervals = ceil(intervals_double);
                     fill_samples_count = fill_samples_count + new_intervals;
                     gcs_eye_counter = gcs_eye_counter + 1;
                     exists_gcs_eye = 1;
                 else
                     % filling already started, need to take into account new
                     % values
                     value1 = gcs_eye_array(fill_samples_count -1);
                     value2 = gcs_eye_table(gcs_eye_counter,5).valuenum;
                     definitive_val = (value1 + value2)/2;
                     gcs_eye_array(fill_samples_count - 1) = definitive_val;
                     gcs_eye_counter = gcs_eye_counter + 1;
                     exists_gcs_eye = 1;
                 end
              else
                 if fill_samples_count == 1
                     if save_last_value_previous_to_ICU == 0
                         new_intervals = ceil(intervals_double);
                         new_value = gcs_eye_table(gcs_eye_counter,5).valuenum;
                         gcs_eye_array(fill_samples_count + new_intervals) = new_value ; 
                         gcs_eye_counter = gcs_eye_counter + 1; 
                         start_time = start_time + (new_intervals)*D;
                         fill_samples_count = fill_samples_count + new_intervals;
                         exists_gcs_eye = 1;
                     else
                         new_intervals = ceil(intervals_double);
                         old_value = save_last_value_previous_to_ICU;
                         new_value = gcs_eye_table(gcs_eye_counter,5).valuenum;
                         %{
                         differential = (new_value - old_value)/new_intervals;
                         if differential == 0
                            gcs_verbal_array(fill_samples_count:(new_intervals + fill_samples_count)-1) = old_value; 
                         else                     
                            gcs_verbal_array(fill_samples_count:(new_intervals + fill_samples_count)-1) = old_value;%(old_value + differential):differential:new_value ; 
                         end
                         %}
                         gcs_eye_array(fill_samples_count:(new_intervals + fill_samples_count)-1) = old_value;
                         gcs_eye_counter = gcs_eye_counter + 1;
                         start_time = start_time + (new_intervals)*D;
                         fill_samples_count = fill_samples_count + new_intervals;
                         exists_gcs_eye = 1;
                     end
                 else
                     new_intervals = ceil(intervals_double);
                     old_value = gcs_eye_array(fill_samples_count -1);
                     new_value = gcs_eye_table(gcs_eye_counter,5).valuenum;
                     differential = (new_value - old_value)/new_intervals;
                     if differential == 0
                         gcs_eye_array(fill_samples_count:(new_intervals + fill_samples_count)-1) = old_value; 
                     else                     
                        gcs_eye_array(fill_samples_count:(new_intervals + fill_samples_count)-1) = (old_value + differential):differential:new_value ; 
                     end
                     gcs_eye_counter = gcs_eye_counter + 1; 
                     start_time = start_time + (new_intervals)*D;
                     fill_samples_count = fill_samples_count + new_intervals;
                     exists_gcs_eye = 1;
                 end
              end
              if gcs_eye_table(gcs_eye_counter, 2).hadm_id ~= hadm_id
                  if exists_gcs_eye == 1
                     gcs_eye_array(fill_samples_count:end) = gcs_eye_array(fill_samples_count -1);
                  end              
                  out = 1;
              end

          end

       elseif eye_hadm_id < hadm_id
          while(out2 == 0)
              gcs_eye_counter = gcs_eye_counter + 1;
              if gcs_eye_table(gcs_eye_counter, 2).hadm_id == hadm_id
                  % We analyze the data until new value shows
                  while(out == 0) 
                      % we take the time of the sample taken
                      time_of_sample = gcs_eye_table(gcs_eye_counter,3).charttime;
                      % substract it to initial
                      actual_time_dif = time_of_sample - start_time;
                      if actual_time_dif == D0
                        actual_time_dif = D1; 
                      end
                      intervals_double = actual_time_dif/D;
                      % If it is negative, that means that was a value previous to ICU
                      if intervals_double < 0
                          % The values was taken previous to ICU, not into account
                          save_last_value_previous_to_ICU = gcs_eye_table(gcs_eye_counter,5).valuenum;
                          gcs_eye_counter = gcs_eye_counter + 1;
                      elseif (0<= intervals_double)&&(intervals_double<1)
                         % smaller than one and possitive, within 15 mimuntes to start
                         if fill_samples_count == 1
                             % filling not started yet
                             gcs_eye_array(fill_samples_count) = gcs_eye_table(gcs_eye_counter, 5).valuenum;
                             new_intervals = ceil(intervals_double);
                             fill_samples_count = fill_samples_count + new_intervals;
                             gcs_eye_counter = gcs_eye_counter + 1;
                             exists_gcs_eye = 1;
                         else
                             % filling already started, need to take into account new
                             % values
                             value1 = gcs_eye_array(fill_samples_count -1);
                             value2 = gcs_eye_table(gcs_eye_counter,5).valuenum;
                             definitive_val = (value1 + value2)/2;
                             gcs_eye_array(fill_samples_count - 1) = definitive_val;
                             gcs_eye_counter = gcs_eye_counter + 1;
                             exists_gcs_eye = 1;
                         end
                      else
                         if fill_samples_count == 1
                             if save_last_value_previous_to_ICU == 0
                                 new_intervals = ceil(intervals_double);
                                 new_value = gcs_eye_table(gcs_eye_counter,5).valuenum;
                                 gcs_eye_array(new_intervals + fill_samples_count) = new_value ; 
                                 gcs_eye_counter = gcs_eye_counter + 1; 
                                 start_time = start_time + (new_intervals)*D;
                                 fill_samples_count = fill_samples_count + new_intervals;
                                 exists_gcs_eye = 1;
                             else
                                 new_intervals = ceil(intervals_double);
                                 old_value = save_last_value_previous_to_ICU;
                                 new_value = gcs_eye_table(gcs_eye_counter,5).valuenum;
                                 %{
                                 differential = (new_value - old_value)/new_intervals;                             
                                 if differential == 0
                                    gcs_verbal_array(fill_samples_count:(new_intervals + fill_samples_count)-1) = old_value; 
                                 else                     
                                    gcs_verbal_array(fill_samples_count:(new_intervals + fill_samples_count)-1) = old_value;%(old_value + differential):differential:new_value ; 
                                 end
                                 %}
                                 gcs_eye_array(fill_samples_count:(new_intervals + fill_samples_count)-1) = old_value; % this is replacing previous comment
                                 gcs_eye_counter = gcs_eye_counter + 1;
                                 start_time = start_time + (new_intervals)*D;
                                 fill_samples_count = fill_samples_count + new_intervals;
                                 exists_gcs_eye = 1;
                             end
                         else
                             new_intervals = ceil(intervals_double);
                             old_value = gcs_eye_array(fill_samples_count -1);
                             new_value = gcs_eye_table(gcs_eye_counter,5).valuenum;
                             differential = (new_value - old_value)/new_intervals;
                             if differential == 0
                                gcs_eye_array(fill_samples_count:(new_intervals + fill_samples_count)-1) = old_value; 
                             else                     
                                gcs_eye_array(fill_samples_count:(new_intervals + fill_samples_count)-1) = (old_value + differential):differential:new_value ; 
                             end
                             gcs_eye_counter = gcs_eye_counter + 1; 
                             start_time = start_time + (new_intervals)*D;
                             fill_samples_count = fill_samples_count + new_intervals;
                             exists_gcs_eye = 1;
                         end
                      end
                      if gcs_eye_table(gcs_eye_counter, 2).hadm_id ~= hadm_id
                          if exists_gcs_eye == 1
                             gcs_eye_array(fill_samples_count:end) = gcs_eye_array(fill_samples_count -1);
                          end  
                          out = 1;
                          out2 = 1;
                      end
                  end
              elseif gcs_eye_table(gcs_eye_counter, 2).hadm_id > hadm_id
                  out2 = 1;
              end
          end      
       end
    else
        gcs_eye_array(1:intervals) = 4;
        exists_gcs_eye = 0;
    end
end