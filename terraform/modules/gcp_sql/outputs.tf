output "sql_instance_name" {
  description = "The SQL instance name"
  value       = google_sql_database_instance.this.name
}
