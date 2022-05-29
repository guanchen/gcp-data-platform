terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

resource "google_project_service" "this" {
  project = var.gcp_project_id
  service = "bigquery.googleapis.com"

  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_bigquery_dataset" "this" {
  dataset_id = var.dataset_id

  delete_contents_on_destroy = true
  labels                     = var.labels
  location                   = var.dataset_location
}
