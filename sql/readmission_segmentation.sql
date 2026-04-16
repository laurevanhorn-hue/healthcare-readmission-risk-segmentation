/*
30-Day Readmission Risk Segmentation in US Hospitals
SQL version of the notebook logic

Business goal:
Identify patient and encounter segments with the highest 30-day readmission risk.

Main KPI:
30-day readmission rate = readmissions_30d / encounters

Dataset:
diabetic_data
*/

------------------------------------------------------------
-- 1. Base table: clean fields and define target
------------------------------------------------------------
WITH base AS (
    SELECT
        encounter_id,
        patient_nbr,
        race,
        gender,
        age,
        admission_type_id,
        discharge_disposition_id,
        admission_source_id,
        time_in_hospital,
        medical_specialty,
        num_lab_procedures,
        num_procedures,
        num_medications,
        number_outpatient,
        number_emergency,
        number_inpatient,
        diag_1,
        diag_2,
        diag_3,
        number_diagnoses,
        max_glu_serum,
        A1Cresult,
        insulin,
        change,
        diabetesMed,
        readmitted,

        CASE
            WHEN readmitted = '<30' THEN 1
            ELSE 0
        END AS readmitted_30d,

        COALESCE(number_outpatient, 0)
        + COALESCE(number_emergency, 0)
        + COALESCE(number_inpatient, 0) AS total_prior_visits
    FROM diabetic_data
),

------------------------------------------------------------
-- 2. Feature engineering
------------------------------------------------------------
features AS (
    SELECT
        encounter_id,
        patient_nbr,
        race,
        gender,
        age,
        admission_type_id,
        discharge_disposition_id,
        admission_source_id,
        time_in_hospital,
        medical_specialty,
        num_lab_procedures,
        num_procedures,
        num_medications,
        number_outpatient,
        number_emergency,
        number_inpatient,
        diag_1,
        diag_2,
        diag_3,
        number_diagnoses,
        max_glu_serum,
        A1Cresult,
        insulin,
        change,
        diabetesMed,
        readmitted,
        readmitted_30d,
        total_prior_visits,

        CASE
            WHEN total_prior_visits = 0 THEN '0'
            WHEN total_prior_visits <= 2 THEN '1-2'
            WHEN total_prior_visits <= 5 THEN '3-5'
            ELSE '6+'
        END AS prior_utilization_bucket,

        CASE
            WHEN time_in_hospital <= 3 THEN '1-3 days'
            WHEN time_in_hospital <= 7 THEN '4-7 days'
            ELSE '8-14 days'
        END AS stay_bucket,

        CASE
            WHEN num_medications <= 9 THEN '0-9'
            WHEN num_medications <= 19 THEN '10-19'
            WHEN num_medications <= 29 THEN '20-29'
            ELSE '30+'
        END AS medication_count_bucket,

        CASE
            WHEN number_diagnoses <= 4 THEN '1-4'
            WHEN number_diagnoses <= 7 THEN '5-7'
            WHEN number_diagnoses <= 10 THEN '8-10'
            ELSE '11+'
        END AS diagnosis_count_bucket,

        CASE
            WHEN total_prior_visits >= 3 THEN 1
            ELSE 0
        END AS high_prior_utilization_flag,

        CASE
            WHEN time_in_hospital >= 8 THEN 1
            ELSE 0
        END AS long_stay_flag,

        COALESCE(SUBSTRING(CAST(diag_1 AS VARCHAR), 1, 3), 'Unknown') AS diag_1_group
    FROM base
),

------------------------------------------------------------
-- 3. Overall KPI
------------------------------------------------------------
overall_kpi AS (
    SELECT
        COUNT(*) AS encounters,
        SUM(readmitted_30d) AS readmissions_30d,
        AVG(readmitted_30d * 1.0) AS readmission_rate
    FROM features
),

------------------------------------------------------------
-- 4. Segment summaries
------------------------------------------------------------
age_summary AS (
    SELECT
        age AS segment_value,
        'Age group' AS segment_type,
        COUNT(*) AS encounters,
        SUM(readmitted_30d) AS readmissions_30d,
        AVG(readmitted_30d * 1.0) AS readmission_rate
    FROM features
    GROUP BY age
),

prior_utilization_summary AS (
    SELECT
        prior_utilization_bucket AS segment_value,
        'Prior utilization' AS segment_type,
        COUNT(*) AS encounters,
        SUM(readmitted_30d) AS readmissions_30d,
        AVG(readmitted_30d * 1.0) AS readmission_rate
    FROM features
    GROUP BY prior_utilization_bucket
),

stay_summary AS (
    SELECT
        stay_bucket AS segment_value,
        'Time in hospital' AS segment_type,
        COUNT(*) AS encounters,
        SUM(readmitted_30d) AS readmissions_30d,
        AVG(readmitted_30d * 1.0) AS readmission_rate
    FROM features
    GROUP BY stay_bucket
),

medication_summary AS (
    SELECT
        medication_count_bucket AS segment_value,
        'Medication count' AS segment_type,
        COUNT(*) AS encounters,
        SUM(readmitted_30d) AS readmissions_30d,
        AVG(readmitted_30d * 1.0) AS readmission_rate
    FROM features
    GROUP BY medication_count_bucket
),

diagnosis_count_summary AS (
    SELECT
        diagnosis_count_bucket AS segment_value,
        'Diagnosis count' AS segment_type,
        COUNT(*) AS encounters,
        SUM(readmitted_30d) AS readmissions_30d,
        AVG(readmitted_30d * 1.0) AS readmission_rate
    FROM features
    GROUP BY diagnosis_count_bucket
),

discharge_summary AS (
    SELECT
        CAST(discharge_disposition_id AS VARCHAR) AS segment_value,
        'Discharge disposition' AS segment_type,
        COUNT(*) AS encounters,
        SUM(readmitted_30d) AS readmissions_30d,
        AVG(readmitted_30d * 1.0) AS readmission_rate
    FROM features
    GROUP BY discharge_disposition_id
    HAVING COUNT(*) >= 500
),

admission_type_summary AS (
    SELECT
        CAST(admission_type_id AS VARCHAR) AS segment_value,
        'Admission type' AS segment_type,
        COUNT(*) AS encounters,
        SUM(readmitted_30d) AS readmissions_30d,
        AVG(readmitted_30d * 1.0) AS readmission_rate
    FROM features
    GROUP BY admission_type_id
    HAVING COUNT(*) >= 500
),

diag_summary AS (
    SELECT
        diag_1_group AS segment_value,
        'Primary diagnosis group' AS segment_type,
        COUNT(*) AS encounters,
        SUM(readmitted_30d) AS readmissions_30d,
        AVG(readmitted_30d * 1.0) AS readmission_rate
    FROM features
    GROUP BY diag_1_group
    HAVING COUNT(*) >= 500
),

medical_specialty_summary AS (
    SELECT
        COALESCE(medical_specialty, 'Other / Missing') AS segment_value,
        'Medical specialty' AS segment_type,
        COUNT(*) AS encounters,
        SUM(readmitted_30d) AS readmissions_30d,
        AVG(readmitted_30d * 1.0) AS readmission_rate
    FROM features
    GROUP BY COALESCE(medical_specialty, 'Other / Missing')
    HAVING COUNT(*) >= 500
),

------------------------------------------------------------
-- 5. Combine all candidate segments
------------------------------------------------------------
all_segments AS (
    SELECT * FROM age_summary
    UNION ALL
    SELECT * FROM prior_utilization_summary
    UNION ALL
    SELECT * FROM stay_summary
    UNION ALL
    SELECT * FROM medication_summary
    UNION ALL
    SELECT * FROM diagnosis_count_summary
    UNION ALL
    SELECT * FROM discharge_summary
    UNION ALL
    SELECT * FROM admission_type_summary
    UNION ALL
    SELECT * FROM diag_summary
    UNION ALL
    SELECT * FROM medical_specialty_summary
),

------------------------------------------------------------
-- 6. Filter to meaningful segments and rank them
------------------------------------------------------------
high_risk_segments AS (
    SELECT
        segment_type,
        segment_value,
        encounters,
        readmissions_30d,
        readmission_rate
    FROM all_segments
    WHERE encounters >= 500
),

ranked_segments AS (
    SELECT
        segment_type,
        segment_value,
        encounters,
        readmissions_30d,
        readmission_rate,
        ROW_NUMBER() OVER (
            ORDER BY readmission_rate DESC, encounters DESC
        ) AS risk_rank
    FROM high_risk_segments
)

------------------------------------------------------------
-- 7. Final output: Top 10 high-risk segments
------------------------------------------------------------
SELECT
    risk_rank,
    segment_type,
    segment_value,
    encounters,
    readmissions_30d,
    ROUND(readmission_rate * 100, 2) AS readmission_rate_pct
FROM ranked_segments
WHERE risk_rank <= 10
ORDER BY risk_rank;
