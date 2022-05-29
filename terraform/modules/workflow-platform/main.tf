terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

resource "google_project_service" "this" {
  project = var.gcp_project_id
  service = "composer.googleapis.com"

  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_service_account" "this" {
  account_id = "${var.gcp_project_id}-composer-sa-${var.environment}"

  description  = "Service account used by Composer in ${var.environment}"
  display_name = "${var.gcp_project_id}-composer-sa-${var.environment}"
}

resource "google_project_iam_member" "bigquery_admin" {
  member  = "serviceAccount:${google_service_account.this.email}"
  project = var.gcp_project_id
  role    = "roles/bigquery.admin"
}

resource "google_project_iam_member" "composer_worker" {
  member  = "serviceAccount:${google_service_account.this.email}"
  project = var.gcp_project_id
  role    = "roles/composer.worker"
}

resource "google_project_iam_member" "iam_serviceAccountUser" {
  member  = "serviceAccount:${google_service_account.this.email}"
  project = var.gcp_project_id
  role    = "roles/iam.serviceAccountUser"
}

resource "google_composer_environment" "this" {
  name = "${var.gcp_project_id}-composer-${var.environment}"

  labels = var.labels
  region = var.composer_region

  config {
    environment_size = var.composer_environment_size

    # To do: switch to private network
    node_config {
      service_account = google_service_account.this.id
    }

    # To do: replace Airflow config
    software_config {
      image_version = var.composer_image_version

      env_variables = {
        DATA_FOLDER = "/home/airflow/gcs/data"
        ENVIRONMENT = var.environment
      }

      pypi_packages = {
        dbt-bigquery = "==1.1.0"
        dbt-core     = "==1.1.0"
        hologram     = "==0.0.14"
        jsonschema   = "<3.2,>=3.0"
      }
    }
  }

  depends_on = [
    google_service_account.this,
    google_project_iam_member.bigquery_admin,
    google_project_iam_member.composer_worker,
    google_project_iam_member.iam_serviceAccountUser
  ]
}
