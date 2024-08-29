-- Dimensional model for job posting title

WITH job_title_clean AS (
    SELECT
        job_title
    FROM
        {{ ref('stg_linkedin_jobs_postings') }}
    WHERE
	-- Ensure no empty or whitespace-only strings
        job_title IS NOT NULL
        AND TRIM(job_title) != ''
)

SELECT
-- Create a unique surrogate key for each job title
    ROW_NUMBER() OVER (ORDER BY job_title) AS job_title_id,
    job_title AS job_title_name
FROM
    job_title_clean
GROUP BY
    job_title