output "airflow_uri" {
  description = "The URI of the Apache Airflow Web UI hosted within the Cloud Composer environment."
  value       = google_composer_environment.this.config.0.airflow_uri
}

output "dags_gcs_prefix" {
  description = "The Cloud Storage prefix of the DAGs for the Cloud Composer environment"
  value       = google_composer_environment.this.config.0.dag_gcs_prefix
}

output "composer_service_account_email" {
  description = "The Cloud Composer service account email"
  value       = google_service_account.this.email
}
