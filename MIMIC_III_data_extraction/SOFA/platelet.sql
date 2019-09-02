DROP MATERIALIZED VIEW IF EXISTS platelet CASCADE;
CREATE MATERIALIZED VIEW platelet as

SELECT  subject_id, hadm_id, charttime, value, valuenum, itemid, flag
FROM labevents
WHERE itemid = 51265 AND valuenum IS NOT NULL AND valuenum < 10000
ORDER BY hadm_id, charttime


