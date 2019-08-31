DROP MATERIALIZED VIEW IF EXISTS meanBP CASCADE;
CREATE MATERIALIZED VIEW meanBP as

SELECT subject_id, hadm_id, charttime, value, valuenum, itemid, icustay_id
FROM chartevents
WHERE itemid in (456,52,6702,443,220052,220181,225312) AND valuenum > 0 AND valuenum < 300
ORDER BY hadm_id, charttime