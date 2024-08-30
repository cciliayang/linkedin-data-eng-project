-- Create a custom model to show company_id, company name and total job posting count.
SELECT
    c.company_id,
    c.company_name,
    f.job_posting_count
FROM
    {{ ref('fact_job_posting') }} AS f
JOIN
    {{ ref('dim_company') }} AS c
ON
    f.company_id = c.company_id
WHERE
    f.job_posting_count IS NOT NULL
ORDER BY
    f.job_posting_count DESC