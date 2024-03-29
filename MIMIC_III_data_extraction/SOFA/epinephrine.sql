DROP MATERIALIZED VIEW IF EXISTS epinephrine CASCADE;
CREATE MATERIALIZED VIEW epinephrine as

SELECT  subject_id, hadm_id, starttime as charttime, itemid, rate as valuenum, icustay_id
FROM inputevents_mv
WHERE itemid = 221289 AND rate IS NOT NULL
UNION
SELECT subject_id, hadm_id, charttime, itemid, rate as valuenum, icustay_id
FROM inputevents_cv
WHERE itemid in (30119,30309) AND rate IS NOT NULL
ORDER BY hadm_id, charttime

