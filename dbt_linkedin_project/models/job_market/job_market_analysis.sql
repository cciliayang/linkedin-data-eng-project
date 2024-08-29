-- Final Model for analyzing job market

SELECT
    job_title,
    location,
    number_of_postings
--FROM
    --{{ ref('int_job_posting') }}
 FROM
        {{ source('transformed_job_posting_data', 'int_job_posting') }}
ORDER BY
    number_of_postings DESC