import os
from datetime import datetime, timedelta
from airflow import DAG

# Operators
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from airflow.providers.google.cloud.transfers.local_to_gcs import (
    LocalFilesystemToGCSOperator,
)
from airflow.contrib.operators.gcs_to_bq import GoogleCloudStorageToBigQueryOperator

# Environment variables
DAGS_FOLDER = os.environ.get("DAGS_FOLDER")
DATA_FOLDER = os.environ.get("DATA_FOLDER")
DBT_FOLDER = DATA_FOLDER + "/dbt"
ENV = os.environ.get("ENVIRONMENT")
GCP_PROJECT = os.environ.get("GCP_PROJECT")

# Parameters
DATA_LAKE_NAME = f"{GCP_PROJECT}-data-lake-{ENV}"
DATA_WAREHOUSE_NAME = f"data_warehouse_{ENV}"
URL = "https://s3.amazonaws.com/amazon-reviews-pds/tsv/sample_us.tsv"

# Airflow pipeline
with DAG(
    default_args={
        "depends_on_past": False,
        "retries": 0,
    },
    dag_id="elt-pipeline",
    description="A simple ELT pipeline",
    schedule_interval=timedelta(days=1),
    start_date=datetime(2022, 1, 1),
    catchup=False,
) as dag:

    def download_file(url, **kwargs):
        # Import only when necessary
        import csv
        import pathlib

        import pandas as pd
        import requests

        # Ensure directory exists
        pathlib.Path("/tmp/download").mkdir(parents=True, exist_ok=True)

        try:
            response = requests.get(url)

            tmp_file = url.split("/")[-1]
            tmp_file_format = tmp_file.split(".")[-1]
            tmp_file_name = tmp_file.split(".")[0]
            tmp_file_path = f"/tmp/download/{tmp_file}"

            with open(tmp_file_path, "wb") as f:
                f.write(response.content)

            if tmp_file_format == "tsv":
                csv_dataframe = pd.read_table(tmp_file_path, sep="\t")

            else:
                csv_dataframe = pd.read_csv(tmp_file_path)

            if tmp_file_format != "csv":
                tmp_file = tmp_file_name + ".csv"
                tmp_file_path = f"/tmp/download/{tmp_file}"
                csv_dataframe.to_csv(tmp_file_path, index=True)

            nb_rows = len(csv_dataframe.index)

            task_instance = kwargs["ti"]
            task_instance.xcom_push(
                key="nb_rows", value=nb_rows
            )  # Push number of rows as 'nb_rows'
            task_instance.xcom_push(
                key="file_name", value=tmp_file
            )  # Push filename as 'file_name'
            task_instance.xcom_push(
                key="tmp_file_path", value=tmp_file_path
            )  # Push file path as 'tmp_file_path'

        except requests.exceptions.ConnectionError:
            print(f"Could not connect to {url}.")

    download_file = PythonOperator(
        task_id="download",
        provide_context=True,
        python_callable=download_file,
        op_kwargs={"url": URL},
        dag=dag,
    )

    upload_data_to_gcs = LocalFilesystemToGCSOperator(
        task_id="upload",
        src="{{ti.xcom_pull(task_ids='download', key='tmp_file_path')}}",
        dst="{{ti.xcom_pull(task_ids='download', key='file_name')}}",
        bucket=DATA_LAKE_NAME,
    )

    gcs_to_bq = GoogleCloudStorageToBigQueryOperator(
        task_id="gcs_to_bq",
        bucket=DATA_LAKE_NAME,
        source_objects=["{{ti.xcom_pull(task_ids='download', key='file_name')}}"],
        destination_project_dataset_table=f"{DATA_WAREHOUSE_NAME}.raw_table",
        source_format="CSV",
        autodetect=True,
        skip_leading_rows=1,
        create_disposition="CREATE_IF_NEEDED",
        write_disposition="WRITE_APPEND",
        dag=dag,
    )

    deduplicate_raw_data = BashOperator(
        task_id="dbt_run",
        bash_command=f"dbt run --select deduplicated_raw_data --profiles-dir {DBT_FOLDER} --project-dir {DBT_FOLDER}",
        dag=dag,
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command=f"dbt test --profiles-dir {DBT_FOLDER} --project-dir {DBT_FOLDER} --vars '{{nb_rows: "
        + "{{ ti.xcom_pull(task_ids='download', key='nb_rows') }}"
        + "}'",
        dag=dag,
    )

    download_file >> upload_data_to_gcs >> gcs_to_bq >> deduplicate_raw_data >> dbt_test
