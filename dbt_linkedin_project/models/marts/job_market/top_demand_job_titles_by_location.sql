-- Model for identifying the top in-demand job titles by location

WITH job_postings_ranked AS (
    SELECT
        l.job_location AS location,
        jt.job_title_name AS job_title,
        COUNT(*) AS number_of_postings,
        ROW_NUMBER() OVER (
            PARTITION BY l.job_location
            ORDER BY COUNT(*) DESC
        ) AS job_title_rank
    FROM
        {{ ref('fact_job_posting') }} f
    INNER JOIN
        {{ ref('dim_location') }} l ON f.location_id = l.location_id
    INNER JOIN
        {{ ref('dim_job_title') }} jt ON f.job_title_id = jt.job_title_id
	WHERE
	-- filter by location
		l.job_location = 'Philadelphia, PA'
    GROUP BY
        l.job_location,
        jt.job_title_name
)

SELECT
    job_title,
    location,
    number_of_postings
FROM
    job_postings_ranked
WHERE
    job_title_rank = 1

ORDER BY
    number_of_postings DESC
