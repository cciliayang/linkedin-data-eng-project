-- Dimensional model for company's job posting.

WITH company_clean_data AS (
    SELECT
        company
    FROM
        {{ ref('stg_linkedin_jobs_postings') }}
    WHERE
	-- Ensure no empty or whitespace-only strings
        company IS NOT NULL
        AND TRIM(company) != ''
)

SELECT
 -- Create a unique company_id for each company
    ROW_NUMBER() OVER (ORDER BY company) AS company_id,
    company AS company_name
FROM
    company_clean_data
GROUP BY
    company