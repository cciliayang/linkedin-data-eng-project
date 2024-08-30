-- Custom query to check if there are company_id that are null

WITH linkedin_postings_data AS (
    SELECT *
    FROM {{ ref('fact_job_posting') }}
)
SELECT *
FROM linkedin_postings_data
WHERE company_id IS NULL
