-- Dimensional model for location of job posting

WITH location_clean AS (
    SELECT
        search_city,
        job_location,
        search_country,
        search_position
    FROM
        {{ ref('stg_linkedin_jobs_postings') }}
    WHERE
        search_city IS NOT NULL
        AND TRIM(search_city) != ''
        AND job_location IS NOT NULL
        AND TRIM(job_location) != ''
        AND search_country IS NOT NULL
        AND TRIM(search_country) != ''
        AND search_position IS NOT NULL
        AND TRIM(search_position) != ''
)

SELECT
    ROW_NUMBER() OVER (ORDER BY search_city, job_location, search_country, search_position) AS location_id,
    search_city,
    job_location,
    search_country,
    search_position
FROM
    location_clean
GROUP BY
    search_city,
    job_location,
    search_country,
    search_position