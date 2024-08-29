-- Model for the most in demande job titles

WITH job_counts AS (
    SELECT
        job_title,
        location,
        COUNT(*) AS number_of_postings
    FROM
        {{ source('transformed_job_posting_data', 'int_job_posting') }}
    GROUP BY
        job_title,
        location
)
SELECT
    job_title,
    location,
    number_of_postings
FROM
    job_counts
WHERE
    location = 'Chicago, IL'  -- Replace with the location of interest
ORDER BY
    number_of_postings DESC
