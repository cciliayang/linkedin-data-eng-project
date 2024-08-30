from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

# Dag to verify if dbt is installed
default_args = {
    'owner': 'airflow',
    'start_date': datetime(2023, 8, 28),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    'check_dbt_version',
    default_args=default_args,
    # Set to None for manual triggering
    schedule_interval=None,
    # Ensure it doesn't try to run for all past dates
    catchup=False,
) as dag:

    check_dbt_version = BashOperator(
        task_id='check_dbt_version',
        bash_command='dbt --version',
    )
