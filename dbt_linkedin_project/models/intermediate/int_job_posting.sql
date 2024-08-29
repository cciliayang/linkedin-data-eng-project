-- Intermediate Model

SELECT
    job_title,
    job_location AS location,
    COUNT(*) AS number_of_postings
FROM {{ ref('stg_linkedin_jobs_postings') }}
GROUP BY
    job_title,
    job_location