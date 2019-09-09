function measurement = standard_measures(intervals)
measurement = zeros(5,intervals);
% Respiration
% Respiration Rate
measurement(1,1:intervals) = 16;
% PCO2
measurement(2,1:intervals) = 45;
% Temperature
measurement(3,1:intervals) = 36;
% Heart Rate
measurement(4,1:intervals) = 80;
% WBC
measurement(5,1:intervals) = 8;
end