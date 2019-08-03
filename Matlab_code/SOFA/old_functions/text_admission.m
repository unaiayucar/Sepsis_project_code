% text admission func
counter = 1;
i = 1;
while(i<10)
    hadm_id = adults_table(i,2).hadm_id;
    [intervals,counter] = admission(hadm_id, counter, admission_table);
    intervals
    i = i+1;    
end

