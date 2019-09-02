DROP MATERIALIZED VIEW IF EXISTS norepinephrine CASCADE;
CREATE MATERIALIZED VIEW norepinephrine as

SELECT  subject_id, hadm_id, starttime as charttime, itemid, rate as valuenum, icustay_id
FROM inputevents_mv
WHERE itemid = 221906 AND rate IS NOT NULL
UNION
SELECT subject_id, hadm_id, charttime, itemid, rate as valuenum, icustay_id
FROM inputevents_cv
WHERE itemid = 30120 AND rate IS NOT NULL
ORDER BY hadm_id, charttime
