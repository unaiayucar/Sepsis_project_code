DROP MATERIALIZED VIEW IF EXISTS temperature CASCADE;
CREATE MATERIALIZED VIEW temperature as

SELECT ch.subject_id, ch.hadm_id, ch.charttime
,case
when ch.itemid in (223761,678) and ch.valuenum > 70 and ch.valuenum < 120  then ch.value
when ch.itemid in (223762,676) and ch.valuenum > 10 and ch.valuenum < 50 then ch.value
else null end as value
,case
when ch.itemid in (223761,678) and ch.valuenum > 70 and ch.valuenum < 120  then ((ch.valuenum-32)*5)/9
when ch.itemid in (223762,676) and ch.valuenum > 10 and ch.valuenum < 50 then ch.valuenum
else null end as valuenum, 
ch.itemid, ch.icustay_id
FROM chartevents ch
WHERE ch.itemid in (223761,678) and ch.valuenum > 70 and ch.valuenum < 120 OR
ch.itemid in (223762,676) and ch.valuenum > 10 and ch.valuenum < 50
ORDER BY ch.hadm_id, ch.charttime