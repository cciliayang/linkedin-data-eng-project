-- Create a custom test model for accepted range job postings

WITH data AS (
    SELECT *
    FROM {{ ref('fact_job_posting') }}
)
SELECT *
FROM data
WHERE job_posting_count < 1 OR job_posting_count > 1000000
