DROP MATERIALIZED VIEW IF EXISTS bilirubin CASCADE;
CREATE MATERIALIZED VIEW bilirubin as

SELECT  subject_id, hadm_id, charttime, value, valuenum, itemid, flag
FROM labevents
WHERE itemid = 50885 AND valuenum IS NOT NULL AND valuenum < 150
ORDER BY hadm_id, charttime


