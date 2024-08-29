-- Model clean and prepare raw data from 'raw_linkedin_job_posting'

WITH clean_job_postings_data AS (
    SELECT
        _airbyte_raw_id AS raw_id,
        _airbyte_extracted_at AS extracted_at,
        _airbyte_meta AS meta,
        SAFE_CAST(_airbyte_generation_id AS INT64) AS generation_id,
        company,
        got_ner,
        job_link,
        job_type,
        job_level,
        job_title,
        TIMESTAMP(first_seen) AS first_seen,
        got_summary,
        search_city,
        job_location,
        search_country,
        is_being_worked,
        search_position,
        TIMESTAMP(last_processed_time) AS last_processed_time
    FROM {{ source('linkedin_job_posting', 'raw_linkedin_job_posting') }}
)

SELECT * FROM clean_job_postings_data