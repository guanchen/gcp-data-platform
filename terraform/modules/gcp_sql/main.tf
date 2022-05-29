terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

resource "google_project_service" "this" {
  project = var.gcp_project_id
  service = "sqladmin.googleapis.com"

  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_sql_database_instance" "this" {
  name = "${var.gcp_project_id}-sql-instance-${var.environment}"

  database_version    = var.db_version
  deletion_protection = false

  settings {
    availability_type = var.db_instance_availability_type
    tier              = var.db_instance_tier
    user_labels       = var.labels
  }
}

resource "google_sql_user" "this" {
  name = var.gcp_service_account_email

  instance = google_sql_database_instance.this.name
  type     = "CLOUD_IAM_SERVICE_ACCOUNT"
}

resource "google_sql_database" "this" {
  name = "default"

  instance = google_sql_database_instance.this.name
}
