DROP MATERIALIZED VIEW IF EXISTS heart_rate CASCADE;
CREATE MATERIALIZED VIEW heart_rate as

SELECT ch.subject_id, ch.hadm_id, ch.charttime, ch.value, ch.valuenum, 
ch.itemid, ch.icustay_id
FROM chartevents ch
WHERE ch.itemid in (211,220045) and ch.valuenum > 0 and ch.valuenum < 300
ORDER BY ch.hadm_id, ch.charttime