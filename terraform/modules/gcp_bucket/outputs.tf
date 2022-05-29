output "bucket_name" {
  description = "The bucket name"
  value       = google_storage_bucket.this.name
}
