-- Model for the most in demand job titles by City,  ordered by count of ob postings in descending order.

SELECT
    l.search_city,
    jt.job_title_name AS job_title,
    COUNT(fact.job_id) AS job_postings_count
FROM
    {{ ref('fact_job_posting') }} fact
JOIN
    {{ ref('dim_job_title') }} jt
    ON fact.job_title_id = jt.job_title_id
JOIN
    {{ ref('dim_location') }} l
    ON fact.location_id = l.location_id
GROUP BY
    l.search_city,
    jt.job_title_name
ORDER BY
    job_postings_count DESC

