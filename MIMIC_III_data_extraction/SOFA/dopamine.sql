DROP MATERIALIZED VIEW IF EXISTS dopamine CASCADE;
CREATE MATERIALIZED VIEW dopamine as

SELECT  subject_id, hadm_id, starttime as charttime, itemid, rate as valuenum, icustay_id
FROM inputevents_mv
WHERE itemid = 221662 AND rate IS NOT NULL
UNION
SELECT subject_id, hadm_id, charttime, itemid, rate as valuenum, icustay_id
FROM inputevents_cv
WHERE itemid in (30043,30307) AND rate IS NOT NULL
ORDER BY hadm_id, charttime
