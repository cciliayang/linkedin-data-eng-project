from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.providers.google.cloud.operators.bigquery import BigQueryCreateEmptyDatasetOperator
from airflow.operators.bash import BashOperator

# Default DAG arguments
default_args = {
    'owner': 'airflow',
    'start_date': days_ago(1),
    'retries': 1,
}

# Define the DAG
dag = DAG(
    dag_id='create_dataset_and_load_dbt_models',
    default_args=default_args,
    description='A DAG to create a BigQuery dataset and load dbt models',
    schedule_interval=None,
    catchup=False,
)

# Task 1 - Create a new BigQuery dataset
create_dataset = BigQueryCreateEmptyDatasetOperator(
    task_id='create_bigquery_dataset',
    dataset_id='transformed_linkedin_postings_data',
    project_id='big-star-collectibles-433202',
    location='US',
    dag=dag,
)

# Task 2 - Copy dbt project files from the dbt-linkedin-project bucket to the local file system
copy_dbt_project = BashOperator(
    task_id='copy_dbt_project',
    #bash_command='gsutil -m cp -r gs://dbt-linkedin-project /home/airflow/dbt_project',
	bash_command='gsutil -m cp -r gs://dbt-linkedin-project /home/airflow/gcs/data/dbt_project',
    dag=dag,
)

# Task 3 - Run dbt models using the copied dbt project files
run_dbt_models = BashOperator(
    task_id='run_dbt_models',
    #bash_command='dbt run --profiles-dir /home/airflow/dbt_project --project-dir /home/airflow/dbt_project --target prod',
    bash_command='dbt run --profiles-dir /home/airflow/gcs/data/dbt_project --project-dir /home/airflow/gcs/data/dbt_project --target prod',
	env={
        'DBT_BIGQUERY_DATASET': 'transformed_linkedin_postings_data',
    },
    dag=dag,
)

# Define task dependencies
create_dataset >> copy_dbt_project >> run_dbt_models
