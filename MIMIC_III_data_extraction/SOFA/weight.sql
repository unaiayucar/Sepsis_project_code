DROP MATERIALIZED VIEW IF EXISTS weightCASCADE;
CREATE MATERIALIZED VIEW weight as

SELECT  DISTINCT ON(hadm_id) icustay_id, hadm_id, patientweight as weight
FROM inputevents_mv
ORDER BY hadm_id