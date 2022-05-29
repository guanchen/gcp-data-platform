output "dataset_id" {
  description = "The BigQuery dataset id"
  value       = google_bigquery_dataset.this.id
}
