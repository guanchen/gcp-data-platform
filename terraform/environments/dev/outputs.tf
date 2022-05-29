output "airflow_uri" {
  description = "The URI of the Apache Airflow Web UI hosted within the Cloud Composer environment."
  value       = module.workflow_platform.airflow_uri
}

output "airflow_dags_gcs_prefix" {
  description = "The Cloud Storage prefix of the DAGs for the Cloud Composer environment"
  value       = module.workflow_platform.dags_gcs_prefix
}

output "data_lake_gcs_bucket_name" {
  description = "The GCS bucket name used as the data lake"
  value       = module.data_lake.bucket_name
}

output "data_warehouse_bq_dataset_name" {
  description = "The BigQuery dataset name used as the data warehouse"
  value       = module.data_warehouse.dataset_id
}
