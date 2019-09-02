DROP MATERIALIZED VIEW IF EXISTS pco2 CASCADE;
CREATE MATERIALIZED VIEW pco2 as

SELECT subject_id, hadm_id, charttime, itemid, valuenum
FROM chartevents
WHERE itemid = 778 AND valuenum IS NOT NULL