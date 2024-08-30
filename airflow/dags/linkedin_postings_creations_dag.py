from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator

default_args = {
    'owner': 'airflow',
    'start_date': days_ago(1),
    'retries': 1,
}

dag = DAG(
    dag_id='bigquery_transformation_dag',
    default_args=default_args,
    description='A DAG to run BigQuery SQL Linkedin job postings transformations',
    schedule_interval='@daily',
    catchup=False,
)

# Create a table query from dbt model called dim_location
create_table_query = """
CREATE OR REPLACE TABLE `big-star-collectibles-433202.transformed_data.dim_location` AS
SELECT
    ROW_NUMBER() OVER (ORDER BY search_city, job_location, search_country, search_position) AS location_id,
    search_city,
	job_location,
	search_country,
	search_position

FROM `big-star-collectibles-433202.raw_data.raw_linkedin_job_posting`
GROUP BY search_city,
		job_location,
		search_country,
		search_position
"""

# Create a table query that display top 10 job titles by city
create_job_titles_by_top_city_query = """
CREATE OR REPLACE TABLE `big-star-collectibles-433202.transformed_data.top_job_titles_by_city` AS
SELECT
    l.search_city,
    jt.job_title_name AS job_title,
    COUNT(fact.job_id) AS job_postings_count
FROM
    `big-star-collectibles-433202.transformed_data.fact_job_posting` fact
JOIN
    `big-star-collectibles-433202.transformed_data.dim_job_title` jt
    ON fact.job_title_id = jt.job_title_id
JOIN
    `big-star-collectibles-433202.transformed_data.dim_location` l
    ON fact.location_id = l.location_id
GROUP BY
    l.search_city,
    jt.job_title_name
ORDER BY
    job_postings_count DESC
LIMIT 10
"""

# Task 1 - table query from dbt model called dim_location
transform_data = BigQueryInsertJobOperator(
    task_id='transform_data',
    configuration={
        "query": {
            "query": create_table_query,
            "useLegacySql": False,
        }
    },
    dag=dag,
)

# Task 2 - table query that display top 10 job titles by city
create_top_job_titles_table = BigQueryInsertJobOperator(
    task_id='create_top_job_titles_by_city',
    configuration={
        "query": {
            "query": create_job_titles_by_top_city_query,
            "useLegacySql": False,
        }
    },
    dag=dag,
)


transform_data >> create_top_job_titles_table