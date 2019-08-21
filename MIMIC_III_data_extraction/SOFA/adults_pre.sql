DROP MATERIALIZED VIEW IF EXISTS adults_pre CASCADE;
CREATE MATERIALIZED VIEW adults_pre as
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