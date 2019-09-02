DROP MATERIALIZED VIEW IF EXISTS creatinine CASCADE;
CREATE MATERIALIZED VIEW creatinine as

SELECT  subject_id, hadm_id, charttime, value, valuenum, itemid, flag
FROM labevents
WHERE itemid = 50912 AND valuenum IS NOT NULL AND valuenum < 150
ORDER BY hadm_id, charttime


