terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

resource "google_project_service" "this" {
  project = var.gcp_project_id
  service = "storage-component.googleapis.com"

  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_storage_bucket" "this" {
  name = var.bucket_name

  force_destroy = true
  labels        = var.labels
  location      = var.bucket_location
}
