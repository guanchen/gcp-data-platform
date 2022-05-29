output "bucket_name" {
  description = "The GCS bucket name"
  value       = google_storage_bucket.this.name
}
