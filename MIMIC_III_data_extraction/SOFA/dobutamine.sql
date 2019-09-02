DROP MATERIALIZED VIEW IF EXISTS dobutamine CASCADE;
CREATE MATERIALIZED VIEW dobutamine as

SELECT  subject_id, hadm_id, starttime as charttime, itemid, rate as valuenum, icustay_id
FROM inputevents_mv
WHERE itemid = 221653 AND rate IS NOT NULL
UNION
SELECT subject_id, hadm_id, charttime, itemid, rate as valuenum, icustay_id
FROM inputevents_cv
WHERE itemid in (30042,30306) AND rate IS NOT NULL
ORDER BY hadm_id, charttime

