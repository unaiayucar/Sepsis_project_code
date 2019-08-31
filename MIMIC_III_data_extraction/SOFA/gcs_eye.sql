DROP MATERIALIZED VIEW IF EXISTS gcs_eye CASCADE;
CREATE MATERIALIZED VIEW gcs_eye as

SELECT subject_id, hadm_id, charttime, value, valuenum, itemid, icustay_id
FROM chartevents
WHERE itemid in (184,220739)
ORDER BY hadm_id, charttime