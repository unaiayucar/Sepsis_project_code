function [intervals, start_time, ad_counter, out_time] = admission(hadm_id, ad_counter, admission_table)
    ad_hadm_id = admission_table(ad_counter,3).hadm_id;
    intervals = 0;    
    T = '15:00';
    infmt = 'mm:ss';
    D = duration(T,'InputFormat',infmt);
    if ad_hadm_id == hadm_id
        start_time = admission_table(ad_counter,4).admittime;
        out_time = admission_table(ad_counter,5).dischtime;
        stay_time = out_time - start_time;
        intervals = ceil(stay_time/D) + 1;
        ad_counter = ad_counter + 1;    
    elseif ad_hadm_id < hadm_id
        while(ad_hadm_id < hadm_id)
           ad_counter = ad_counter + 1;
           ad_hadm_id = admission_table(ad_counter,3).hadm_id;
        end
        if ad_hadm_id == hadm_id
            start_time = admission_table(ad_counter,4).admittime;
            out_time = admission_table(ad_counter,5).dischtime;
            stay_time = out_time - start_time;
            intervals = ceil(stay_time/D) + 1;
            ad_counter = ad_counter + 1;
        end
    end
end