DROP MATERIALIZED VIEW IF EXISTS wbc CASCADE;
CREATE MATERIALIZED VIEW wbc as

SELECT  subject_id, hadm_id, charttime, value, valuenum, itemid, flag
FROM labevents
WHERE itemid in (51300,51301) AND valuenum IS NOT NULL AND valuenum < 1000
ORDER BY hadm_id, charttime


