-- Dimensional model for job working environment type such as in person, hybrid or remote.

WITH job_type_clean AS(
	SELECT
		job_type
	FROM
		{{ref('stg_linkedin_jobs_postings')}}
	WHERE
		job_type IS NOT NULL
		AND TRIM(job_type) != ''
)

SELECT
	ROW_NUMBER() OVER(ORDER BY job_type) AS job_type_id,
	job_type AS job_type_environment
FROM
	job_type_clean
GROUP BY
	job_type