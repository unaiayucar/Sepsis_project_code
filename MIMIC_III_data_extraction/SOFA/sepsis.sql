DROP MATERIALIZED VIEW IF EXISTS sepsis CASCADE;
CREATE MATERIALIZED VIEW sepsis as

SELECT DISTINCT ON(hadm_id) subject_id, hadm_id,
icd9_code, seq_num
FROM diagnoses_icd
WHERE icd9_code = '99591' OR icd9_code = '78552'
OR icd9_code = '99592'
ORDER BY hadm_id, seq_num
