function [measurement_array, exists_measurement, measurement_counter]...
    = general(measurement_array,hadm_id, intervals, start_time,...
    measurement_counter, meassurement_table, out_time)

    if measurement_counter <= height(meassurement_table)
       % take new hadmm_id and set variables to start values   
       measurement_hadm_id ...
           = meassurement_table(measurement_counter,2).hadm_id; 
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
       exists_measurement = 0; % existance flag
       save_last_value_previous_to_ICU = 0; % In case there are values 
       % previous to ICU
          
       % case in new analysis both hadm_id are equal
       if measurement_hadm_id == hadm_id 
          % We analyze the data until new value shows
          while(out == 0) 
              % we take the time of the sample taken
              time_of_sample ...
                  = meassurement_table(measurement_counter,3).charttime;
              if time_of_sample > out_time
                 time_of_sample = out_time; 
              end
              % substract it to initial
              actual_time_dif = time_of_sample - start_time;
              if actual_time_dif == D0
                 actual_time_dif = D1; 
              end
              intervals_double = actual_time_dif/D;
              % If it is negative, that means that was a value previous to 
              % ICU
              % Lets take the values
              
              if intervals_double < 0
                  % The values was taken previous to ICU, not into account
                  save_last_value_previous_to_ICU ...
                      = meassurement_table(measurement_counter,5).valuenum;
                  if isnan(save_last_value_previous_to_ICU) == 1
                      save_last_value_previous_to_ICU = 0;
                  end                      
                  measurement_counter = measurement_counter + 1;
              elseif (0<= intervals_double)&&(intervals_double<1)
                 % smaller than one and possitive, within 15 mimuntes to 
                 % start
                 if fill_samples_count == 1
                     % filling not started yet
                     new_value ...
                      = meassurement_table(measurement_counter,5).valuenum;
                     if isnan(new_value) == 0
                         measurement_array(fill_samples_count) = new_value;
                     end
                     new_intervals = ceil(intervals_double);
                     fill_samples_count ...
                         = fill_samples_count + new_intervals;
                     measurement_counter = measurement_counter + 1;
                     exists_measurement = 1;
                 else
                     % filling already started, need to take into account new
                     % values
                     old_value = measurement_array(fill_samples_count -1);
                     new_value ...
                      = meassurement_table(measurement_counter,5).valuenum;
                     if isnan(new_value) == 0
                         definitive_val = (old_value + new_value)/2;
                         measurement_array(fill_samples_count - 1)...
                             = definitive_val;
                     end
                     measurement_counter = measurement_counter + 1;
                     exists_measurement = 1;
                 end
             elseif intervals_double==1
                 % smaller than one and possitive, within 15 mimuntes to 
                 % start
                 new_intervals = ceil(intervals_double);
                 if fill_samples_count == 1
                     % filling not started yet
                     new_value ...
                      = meassurement_table(measurement_counter,5).valuenum;
                     if isnan(new_value) == 0
                         measurement_array(fill_samples_count) = new_value;
                     end
                     new_intervals = ceil(intervals_double);
                     fill_samples_count ...
                         = fill_samples_count + new_intervals;
                     measurement_counter = measurement_counter + 1; 
                     start_time = start_time + (new_intervals)*D;
                     fill_samples_count ...
                         = fill_samples_count + new_intervals;
                     exists_measurement = 1;
                 else
                     % its a single value stage no need to take into
                     % account old values
                     old_value = measurement_array(fill_samples_count -1);
                     new_value ...
                      = meassurement_table(measurement_counter,5).valuenum;
                     if isnan(new_value) == 0
                         % definitive_val = (old_value + new_value)/2;
                         measurement_array(fill_samples_count - 1)...
                             = new_value;
                     end
                     measurement_counter = measurement_counter + 1; 
                     start_time = start_time + (new_intervals)*D;
                     fill_samples_count ...
                         = fill_samples_count + new_intervals;
                     exists_measurement = 1;
                 end
              else
                 if fill_samples_count == 1
                     if save_last_value_previous_to_ICU == 0
                         new_intervals = ceil(intervals_double);
                         new_value ...
                             = meassurement_table...
                             (measurement_counter,5).valuenum;
                         if isnan(new_value) == 0
                             measurement_array...
                                 (fill_samples_count + new_intervals - 1) ...
                                 = new_value ; 
                         end
                         measurement_counter = measurement_counter + 1; 
                         start_time = start_time + (new_intervals)*D;
                         fill_samples_count ...
                             = fill_samples_count + new_intervals;
                         exists_measurement = 1;                         
                     else
                         new_intervals = ceil(intervals_double);
                         old_value = save_last_value_previous_to_ICU;
                         new_value ...
                             = meassurement_table...
                             (measurement_counter,5).valuenum;
                         %{
                         differential = (new_value - old_value)...
                            /new_intervals;
                         if differential == 0
                            gcs_verbal_array...
                                (fill_samples_count:...
                                (new_intervals + fill_samples_count)-1)...
                                = old_value; 
                         else                     
                            gcs_verbal_array...
                                (fill_samples_count:...
                                (new_intervals + fill_samples_count)-1)...
                                = old_value;%(old_value + differential)...
                                :differential:new_value ; 
                         end
                         %}
                         if isnan(new_value) == 0    
                             measurement_array...
                                 (fill_samples_count:...
                                 (new_intervals + fill_samples_count)-1)...
                                 = old_value;
                         end
                         measurement_counter = measurement_counter + 1;
                         start_time = start_time + (new_intervals)*D;
                         fill_samples_count...
                             = fill_samples_count + new_intervals;
                         exists_measurement = 1;
                     end
                 else
                     new_intervals = ceil(intervals_double);
                     old_value = measurement_array(fill_samples_count -1);
                     new_value...
                         = meassurement_table...
                         (measurement_counter,5).valuenum;
                     if isnan(new_value) == 0  
                         differential =(new_value-old_value)/new_intervals;
                         if new_intervals == 1
                             if differential == 0
                                 measurement_array...
                                     (fill_samples_count:...
                                     (new_intervals ...
                                     + fill_samples_count)-1)...
                                     = old_value; 
                             else                     
                                measurement_array...
                                    (fill_samples_count:...
                                    (new_intervals...
                                    + fill_samples_count)-1)...
                                    = (old_value + differential):...
                                    differential:new_value ; 
                             end
                         else
                             if differential == 0
                                 measurement_array...
                                     (fill_samples_count)= old_value; 
                             else                     
                                measurement_array...
                                    (fill_samples_count)= new_value ; 
                             end
                         end
                     end
                     measurement_counter = measurement_counter + 1; 
                     start_time = start_time + (new_intervals)*D;
                     fill_samples_count ...
                         = fill_samples_count + new_intervals;
                     exists_measurement = 1;
                 end
              end
              if meassurement_table...
                      (measurement_counter, 2).hadm_id ~= hadm_id
                  if exists_measurement == 1
                     measurement_array(fill_samples_count:end)...
                         = measurement_array(fill_samples_count -1);
                  end              
                  out = 1;
              end

          end

       elseif measurement_hadm_id < hadm_id
          while(out2 == 0)
              measurement_counter = measurement_counter + 1;
              if meassurement_table...
                      (measurement_counter, 2).hadm_id == hadm_id
                  % We analyze the data until new value shows
                  while(out == 0) 
                      % we take the time of the sample taken
                      time_of_sample ...
                          = meassurement_table...
                          (measurement_counter,3).charttime;
                      % substract it to initial
                      if time_of_sample > out_time
                        time_of_sample = out_time; 
                      end
                      actual_time_dif = time_of_sample - start_time;
                      if actual_time_dif == D0
                         actual_time_dif = D1; 
                      end
                      intervals_double = actual_time_dif/D;
                      % If it is negative, that means that was a value 
                      % previous to ICU
                      if intervals_double < 0
                          % The values was taken previous to ICU, not into 
                          % account
                          new_value ...
                                     = meassurement_table...
                                     (measurement_counter,5).valuenum;
                          if isnan(new_value) == 0
                            save_last_value_previous_to_ICU ...
                                = new_value;
                          end
                          measurement_counter = measurement_counter + 1;
                      elseif (0<= intervals_double)&&(intervals_double<1)
                         % smaller than one and possitive, within 15 
                         % mimuntes to start
                         if fill_samples_count == 1
                             % filling not started yet
                             new_value ...
                                     = meassurement_table...
                                     (measurement_counter,5).valuenum;
                             if isnan(new_value) == 0
                                 measurement_array(fill_samples_count) ...
                                 = new_value;
                             end                             
                             new_intervals = ceil(intervals_double);
                             fill_samples_count ...
                                 = fill_samples_count + new_intervals;
                             measurement_counter = measurement_counter + 1;
                             exists_measurement = 1;
                         elseif intervals_double==1
                             % smaller than one and possitive, within 
                             % 15 mimuntes to start
                             new_intervals = ceil(intervals_double);
                             if fill_samples_count == 1
                                 % filling not started yet
                                 new_value ...
                                  = meassurement_table...
                                  (measurement_counter,5).valuenum;
                                 if isnan(new_value) == 0
                                     measurement_array(fill_samples_count)...
                                         = new_value;
                                 end
                                 new_intervals = ceil(intervals_double);
                                 fill_samples_count ...
                                     = fill_samples_count + new_intervals;
                                 measurement_counter = measurement_counter + 1; 
                                 start_time = start_time + (new_intervals)*D;
                                 fill_samples_count ...
                                     = fill_samples_count + new_intervals;
                                 exists_measurement = 1;
                             else
                                 % filling already started, need to take 
                                 % into account new values
                                 new_value ...
                                  = meassurement_table...
                                  (measurement_counter,5).valuenum;
                                 if isnan(new_value) == 0
                                     measurement_array(fill_samples_count)...
                                         = new_value;
                                 end
                                 measurement_counter = measurement_counter + 1; 
                                 start_time = start_time + (new_intervals)*D;
                                 fill_samples_count ...
                                     = fill_samples_count + new_intervals;
                                 exists_measurement = 1;
                             end    
                         else
                             % filling already started, need to take into 
                             % account new values
                             old_value ...
                                 = measurement_array(fill_samples_count -1);
                             new_value ...
                                 = meassurement_table...
                                 (measurement_counter,5).valuenum;
                             if isnan(new_value) == 0
                                 definitive_val = (old_value + new_value)/2;
                                 measurement_array(fill_samples_count - 1) ...
                                     = definitive_val;
                             end
                             measurement_counter = measurement_counter + 1;
                             exists_measurement = 1;
                         end
                      else
                         if fill_samples_count == 1
                             if save_last_value_previous_to_ICU == 0
                                 new_intervals = ceil(intervals_double);
                                 new_value ...
                                     = meassurement_table...
                                     (measurement_counter,5).valuenum;
                                 if isnan(new_value) == 0
                                     measurement_array...
                                         (fill_samples_count + new_intervals)...
                                         = new_value ; 
                                 end
                                 measurement_counter...
                                     = measurement_counter + 1; 
                                 start_time...
                                     = start_time + (new_intervals)*D;
                                 fill_samples_count...
                                     = fill_samples_count + new_intervals;
                                 exists_measurement = 1;
                             else
                                 new_intervals = ceil(intervals_double);
                                 old_value ...
                                     = save_last_value_previous_to_ICU;
                                 new_value ...
                                     = meassurement_table...
                                     (measurement_counter,5).valuenum;
                                 %{
                                 differential = (new_value - old_value)...
                                    /new_intervals;
                                 if differential == 0
                                    gcs_verbal_array...
                                    (fill_samples_count:...
                                    (new_intervals...
                                    + fill_samples_count)-1) = old_value; 
                                 else                     
                                    gcs_verbal_array...
                                    (fill_samples_count...
                                    :(new_intervals...
                                    + fill_samples_count)-1)...
                                    = old_value;
                                %(old_value + differential)...
                                    :differential:new_value ; 
                                 end
                                 %}
                                 if isnan(new_value) == 0
                                     measurement_array...
                                         (fill_samples_count:...
                                         (new_intervals...
                                         + fill_samples_count)-1) = old_value;
                                     measurement_counter ...
                                         = measurement_counter + 1;
                                 end
                                 start_time...
                                     = start_time + (new_intervals)*D;
                                 fill_samples_count...
                                     = fill_samples_count + new_intervals;
                                 exists_measurement = 1;
                             end
                         else
                             new_intervals = ceil(intervals_double);
                             old_value ...
                                 = measurement_array(fill_samples_count -1);
                             new_value ...
                                 = meassurement_table...
                                 (measurement_counter,5).valuenum;
                             if isnan(new_value) == 0
                                 differential ...
                                     = (new_value - old_value)/new_intervals;
                                 if new_intervals == 1
                                     if differential == 0
                                         measurement_array...
                                             (fill_samples_count:...
                                             (new_intervals ...
                                             + fill_samples_count)-1)...
                                             = old_value; 
                                     else
                                         if(fill_samples_count)>400
                                             a = 2;
                                         end
                                        measurement_array...
                                            (fill_samples_count:...
                                            (new_intervals ...
                                            + fill_samples_count)-1)...
                                            = (old_value + differential):...
                                            differential:new_value ; 
                                     end
                                 else
                                     if differential == 0
                                         measurement_array...
                                             (fill_samples_count)= old_value; 
                                     else                     
                                        measurement_array...
                                            (fill_samples_count)= new_value ; 
                                     end
                                 end
                             end
                             measurement_counter = measurement_counter + 1; 
                             start_time = start_time + (new_intervals)*D;
                             fill_samples_count ...
                                 = fill_samples_count + new_intervals;
                             exists_measurement = 1;
                         end
                      end
                      if meassurement_table...
                              (measurement_counter, 2).hadm_id ~= hadm_id
                          if exists_measurement == 1
                             measurement_array(fill_samples_count:end)...
                                 = measurement_array(fill_samples_count -1);
                          end  
                          out = 1;
                          out2 = 1;
                      end
                  end
              elseif meassurement_table(measurement_counter, 2).hadm_id ...
                      > hadm_id
                  out2 = 1;
              end
          end      
       end
    else
        measurement_array(1:intervals) = 6;
        exists_measurement = 0;        
    end
end