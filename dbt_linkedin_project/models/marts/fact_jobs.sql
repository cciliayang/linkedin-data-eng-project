-- fact jobs table

WITH job_data AS (
    SELECT
        company AS company_name,
        job_title AS job_title_name,
        job_type AS job_type_environment,
        job_level AS job_position_level,
        search_city AS search_city,
        job_location AS job_location,
        search_country AS search_country,
        search_position AS search_position,
        COUNT(*) AS job_posting_count
    FROM
        {{ ref('stg_linkedin_jobs_postings') }}
    WHERE
        company IS NOT NULL
        AND job_title IS NOT NULL
        AND job_type IS NOT NULL
        AND job_level IS NOT NULL
        AND search_city IS NOT NULL
        AND job_location IS NOT NULL
        AND search_country IS NOT NULL
        AND search_position IS NOT NULL
    GROUP BY
        company,
        job_title,
        job_type,
        job_level,
        search_city,
        job_location,
        search_country,
        search_position
)

SELECT
    ROW_NUMBER() OVER (ORDER BY jd.company_name, jd.job_title_name, jd.job_type_environment, jd.job_position_level, jd.search_city, jd.job_location, jd.search_country, jd.search_position) AS job_id,
    c.company_id,
    jt.job_title_id,
    jty.job_type_id,
    jl.job_level_id,
    l.location_id,
    jd.job_posting_count
FROM
    job_data jd
    LEFT JOIN {{ ref('dim_company') }} c ON jd.company_name = c.company_name
    LEFT JOIN {{ ref('dim_job_title') }} jt ON jd.job_title_name = jt.job_title_name
    LEFT JOIN {{ ref('dim_job_type') }} jty ON jd.job_type_environment = jty.job_type_environment
    LEFT JOIN {{ ref('dim_job_level') }} jl ON jd.job_position_level = jl.job_position_level
    LEFT JOIN {{ ref('dim_location') }} l ON jd.search_city = l.search_city
    AND jd.job_location = l.job_location
    AND jd.search_country = l.search_country
    AND jd.search_position = l.search_position
