DROP MATERIALIZED VIEW IF EXISTS gcs_motor CASCADE;
CREATE MATERIALIZED VIEW gcs_motor as

SELECT subject_id, hadm_id, charttime, value, valuenum, itemid, icustay_id
FROM chartevents
WHERE itemid in (454,223901)
ORDER BY hadm_id, charttime