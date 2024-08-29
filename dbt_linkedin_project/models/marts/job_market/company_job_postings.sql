-- Model for calculating the number of job postings per company

WITH company_postings AS (
    SELECT
        f.company_id,
        c.company_name,
        COUNT(*) AS number_of_postings
    FROM
        {{ ref('fact_job_posting') }} f
    INNER JOIN
        {{ ref('dim_company') }} c ON f.company_id = c.company_id
    GROUP BY
        f.company_id,
        c.company_name
)

SELECT
    company_name,
    number_of_postings
FROM
    company_postings
ORDER BY
    number_of_postings DESC
