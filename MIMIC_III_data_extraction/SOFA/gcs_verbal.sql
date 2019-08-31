DROP MATERIALIZED VIEW IF EXISTS gcs_verbal CASCADE;
CREATE MATERIALIZED VIEW gcs_verbal as

SELECT subject_id, hadm_id, charttime, value, valuenum, itemid, icustay_id
FROM chartevents
WHERE itemid in (723,223900)
ORDER BY hadm_id, charttime