-- Dimensional model for job position type

WITH job_position_level_clean AS (
    SELECT
        job_level
    FROM
        {{ ref('stg_linkedin_jobs_postings') }}
    WHERE
        job_level IS NOT NULL
        AND TRIM(job_level) != ''
)

SELECT
    ROW_NUMBER() OVER (ORDER BY job_level) AS job_level_id,
    job_level AS job_position_level
FROM
    job_position_level_clean
GROUP BY
    job_level