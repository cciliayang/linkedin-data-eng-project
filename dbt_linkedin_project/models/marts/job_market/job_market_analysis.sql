-- Model for analyzing the job market
-- use join tables and aggregate the data to get number of job postings
WITH job_postings_aggregated AS (
    SELECT
        l.job_location AS location,
        jt.job_title_name AS job_title,
        COUNT(*) AS number_of_postings
    FROM
        {{ ref('fact_job_posting') }} f
    INNER JOIN
        {{ ref('dim_location') }} l ON f.location_id = l.location_id
    INNER JOIN
        {{ ref('dim_job_title') }} jt ON f.job_title_id = jt.job_title_id
    GROUP BY
        l.job_location,
        jt.job_title_name
)

SELECT
    job_title,
    location,
    number_of_postings
FROM
    job_postings_aggregated
ORDER BY
    number_of_postings DESC
