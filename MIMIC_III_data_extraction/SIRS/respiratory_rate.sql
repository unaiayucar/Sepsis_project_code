DROP MATERIALIZED VIEW IF EXISTS respiratory_rate CASCADE;
CREATE MATERIALIZED VIEW respiratory_rate as

SELECT ch.subject_id, ch.hadm_id, ch.charttime, ch.value, ch.valuenum, 
ch.itemid, ch.icustay_id
FROM chartevents ch
WHERE ch.itemid in (615,618,220210,224690) and ch.valuenum > 0 and ch.valuenum < 70
ORDER BY ch.hadm_id, ch.charttime