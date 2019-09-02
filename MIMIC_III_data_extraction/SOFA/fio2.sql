DROP MATERIALIZED VIEW IF EXISTS fio2 CASCADE;
CREATE MATERIALIZED VIEW fio2 as

 SELECT chartevents.subject_id,
    chartevents.hadm_id,
    chartevents.charttime,
    chartevents.itemid,
        CASE
            WHEN chartevents.itemid = 223835 THEN
            CASE
                WHEN chartevents.valuenum > 0::double precision AND chartevents.valuenum <= 1::double precision THEN chartevents.valuenum * 100::double precision
                WHEN chartevents.valuenum > 1::double precision AND chartevents.valuenum < 21::double precision THEN NULL::double precision
                WHEN chartevents.valuenum >= 21::double precision AND chartevents.valuenum <= 100::double precision THEN chartevents.valuenum
                ELSE NULL::double precision
            END
            WHEN chartevents.itemid = ANY (ARRAY[3420, 3422]) THEN chartevents.valuenum
            WHEN chartevents.itemid = 190 AND chartevents.valuenum > 0.20::double precision AND chartevents.valuenum < 1::double precision THEN chartevents.valuenum * 100::double precision
            ELSE NULL::double precision
        END AS valuenum
   FROM mimiciii.chartevents
  WHERE (chartevents.itemid = ANY (ARRAY[3420, 190, 223835, 3422])) AND chartevents.error IS DISTINCT FROM 1 AND chartevents.valuenum IS NOT NULL
UNION
 SELECT labevents.subject_id,
    labevents.hadm_id,
    labevents.charttime,
    labevents.itemid,
        CASE
            WHEN labevents.itemid = 50816 THEN
            CASE
                WHEN labevents.valuenum > 0::double precision AND labevents.valuenum <= 1::double precision THEN labevents.valuenum * 100::double precision
                WHEN labevents.valuenum > 1::double precision AND labevents.valuenum < 21::double precision THEN NULL::double precision
                WHEN labevents.valuenum >= 21::double precision AND labevents.valuenum <= 100::double precision THEN labevents.valuenum
                ELSE NULL::double precision
            END
            ELSE NULL::double precision
        END AS valuenum
   FROM mimiciii.labevents
  WHERE labevents.itemid = 50816 AND labevents.valuenum IS NOT NULL
  ORDER BY 2, 3;