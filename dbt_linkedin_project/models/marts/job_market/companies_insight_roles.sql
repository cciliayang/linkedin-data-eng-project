-- Model to calculates the number of job postings per company, grouped by job title and job type.

WITH fact_jobs AS (
    SELECT * FROM {{ ref('fact_job_posting') }}
),
dim_company AS (
    SELECT * FROM {{ ref('dim_company') }}
),
dim_job_title AS (
    SELECT * FROM {{ ref('dim_job_title') }}
),
dim_job_type AS (
    SELECT * FROM {{ ref('dim_job_type') }}
)

SELECT
    c.company_name,
    jtitle.job_title_name,
    jtype.job_type_environment,
	--aggregates total num of job postings
    SUM(f.job_posting_count) AS total_job_postings
FROM
    fact_jobs f
JOIN
    dim_company c ON f.company_id = c.company_id
JOIN
    dim_job_title jtitle ON f.job_title_id = jtitle.job_title_id
JOIN
    dim_job_type jtype ON f.job_type_id = jtype.job_type_id
GROUP BY
    c.company_name,
    jtitle.job_title_name,
    jtype.job_type_environment
ORDER BY
    total_job_postings DESC
--limit to see top 10 only
LIMIT 10
