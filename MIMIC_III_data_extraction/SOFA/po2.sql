DROP MATERIALIZED VIEW IF EXISTS po2 CASCADE;
CREATE MATERIALIZED VIEW po2 as

SELECT subject_id, hadm_id, charttime, itemid, valuenum
FROM labevents
WHERE itemid in (50821, 490) AND valuenum IS NOT NULL
UNION
SELECT subject_id, hadm_id, charttime, itemid, valuenum
FROM chartevents
WHERE itemid in (50832, 779) AND valuenum IS NOT NULL
ORDER BY hadm_id, charttime


