DROP MATERIALIZED VIEW IF EXISTS adults_pre1 CASCADE;
DROP MATERIALIZED VIEW IF EXISTS adults_pre2 CASCADE;
DROP MATERIALIZED VIEW IF EXISTS adults CASCADE;
CREATE MATERIALIZED VIEW adults_pre1 as
SELECT ie.subject_id, ie.hadm_id, ie.icustay_id,
    ie.intime, adm.deathtime, pat.gender, 
	ROUND((cast(ie.intime as date) - cast(pat.dob as date))/365.242, 2) AS age,
	-- note that there is already a "hospital_expire_flag" field in the admissions table which you could use
    CASE
        WHEN adm.hospital_expire_flag = 1 then 'Y'           
    ELSE 'N'
    END AS hospital_expire_flag,
    -- note also that hospital_expire_flag is equivalent to "Is adm.deathtime not null?"
    CASE
        WHEN adm.deathtime BETWEEN ie.intime and ie.outtime
            THEN 'Y'
        -- sometimes there are typographical errors in the death date, so check before intime
        WHEN adm.deathtime <= ie.intime
            THEN 'Y'
        WHEN adm.dischtime <= ie.outtime
            AND adm.discharge_location = 'DEAD/EXPIRED'
            THEN 'Y'
        ELSE 'N'
        END AS ICUSTAY_EXPIRE_FLAG,
	CASE
        WHEN adm.deathtime BETWEEN ie.intime and ie.outtime
            THEN adm.deathtime - ie.intime 
        -- sometimes there are typographical errors in the death date, so check before intime
        WHEN adm.deathtime <= ie.intime
            THEN adm.deathtime - ie.intime 
        WHEN adm.dischtime <= ie.outtime
            AND adm.discharge_location = 'DEAD/EXPIRED'
            THEN adm.deathtime - ie.intime 
        END AS stay_time
FROM icustays ie
INNER JOIN patients pat
ON ie.subject_id = pat.subject_id
INNER JOIN admissions adm
ON ie.hadm_id = adm.hadm_id
ORDER BY hadm_id;
CREATE MATERIALIZED VIEW adults_pre2 as
SELECT hadm_id, MIN(icustay_id) as icustay_id
FROM adults_pre1
group by hadm_id
order by hadm_id;
CREATE MATERIALIZED VIEW adults as
SELECT adp1.subject_id, adp1.hadm_id, adp2.icustay_id, adp1.intime,
adp1.deathtime, adp1.gender, adp1.age, adp1.hospital_expire_flag,
adp1.ICUSTAY_EXPIRE_FLAG, adp1.stay_time
FROM adults_pre1 as adp1
INNER JOIN adults_pre2 as adp2
ON adp1.icustay_id = adp2.icustay_id
ORDER BY adp1.hadm_id;
