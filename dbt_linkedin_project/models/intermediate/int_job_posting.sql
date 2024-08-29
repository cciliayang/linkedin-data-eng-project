-- Intermediate Model

SELECT
    job_title,
    job_location AS location,
    COUNT(*) AS number_of_postings
FROM {{ source('linkedin_job_posting', 'raw_linkedin_job_posting') }}
GROUP BY
    job_title,
    job_location