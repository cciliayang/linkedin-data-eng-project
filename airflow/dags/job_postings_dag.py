from airflow import DAG
#from airflow.operators.bash_operator import BashOperator
from airflow.operators.bash import BashOperator
from airflow.utils.dates import days_ago
from datetime import timedelta

# Define the default_args for the DAG
default_args = {
    'owner': 'your_name',
    'depends_on_past': False,
    'start_date': days_ago(1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Define the DAG
dag = DAG(
    'dbt_run_dag',
    default_args=default_args,
    description='A simple dbt DAG',
    schedule_interval=timedelta(days=1),
)

# Task to download the dbt project from Google Cloud Storage
download_dbt_project = BashOperator(
    task_id='download_dbt_project',
    bash_command=(
        'mkdir -p /home/airflow/gcs/data/dbt_project && '
        'gsutil -m cp -r gs://dbt-linkedin-project/* /home/airflow/gcs/data/dbt_project/'
    ),
    dag=dag,
)

# Task to run dbt models
#dbt_run = BashOperator(
    #task_id='dbt_run',
    #bash_command='cd /home/airflow/gcs/data/dbt_project && dbt run --profiles-dir .',
    #dag=dag,
#)

# Task to run staging models
run_staging = BashOperator(
    task_id='run_staging',
    bash_command='dbt run --models staging',
    dag=dag,
)

# Task to test dbt models
dbt_test = BashOperator(
    task_id='dbt_test',
    bash_command='cd /home/airflow/gcs/data/dbt_project && dbt test --profiles-dir .',
    dag=dag,
)

# Set the task dependencies
download_dbt_project >> run_staging >> dbt_test
