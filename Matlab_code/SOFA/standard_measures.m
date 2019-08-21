function measurement = standard_measures(intervals)
measurement = zeros(16,intervals);
% creatinine standard
measurement(1,1:intervals) = 0.85;
% bilirubin standard
measurement(2,1:intervals) = 1.2;
% gcs_motor standard
measurement(3,1:intervals) = 6;
% gcs_verbal standard
measurement(4,1:intervals) = 5;
% gcs_eye standard
measurement(5,1:intervals) = 4;
% dopamine standard
measurement(6,1:intervals) = 0;
% dobutamine standard
measurement(7,1:intervals) = 0;
% epinephrine standard
measurement(8,1:intervals) = 0;
% norepinephrine standard
measurement(9,1:intervals) = 0;
% mean BP standard (MAP = (SBP + 2(DBP))/2)(MAP=(105+2*70)/3)
measurement(10,1:intervals) = 115;
% platelet standard
measurement(11,1:intervals) = 300;% M (*10^3)
% fio2 chart standard
measurement(12,1:intervals) = 21; % in percentage %
% fio2 lab standard
measurement(13,1:intervals) = 21; % in percentage %
% PO2 standard
measurement(14,1:intervals) = 85; % milimeters of mercury
% ventilation standard
measurement(15,1:intervals) = 0;
% urine output standard
measurement(16,1:intervals) = 0.5; % internet says (o.5mL/kg/h)
end