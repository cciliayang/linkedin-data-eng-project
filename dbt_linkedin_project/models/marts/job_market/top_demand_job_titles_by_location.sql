-- Model for the most in demande job titles in specified location for example ''

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
-- Replace with the location of interest
    location = 'Philadelphia, PA'
ORDER BY
    number_of_postings DESC
