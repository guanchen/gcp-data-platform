terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.22.0"
    }
  }
}

module "gcp_bigquery" {
  source = "../../modules/gcp_bigquery"

  dataset_id       = local.bigquery_dataset
  dataset_location = local.data_location # Needs to match bucket_location for data transfer
  environment      = local.environment
  gcp_project_id   = local.gcp_project_id
  labels           = local.labels
}

module "gcp_bucket" {
  source = "../../modules/gcp_bucket"

  bucket_location = local.data_location # Needs to match dataset_location for data transfer
  bucket_name     = "${local.gcp_project_id}-bucket-${local.environment}"
  environment     = local.environment
  gcp_project_id  = local.gcp_project_id
  labels          = local.labels
}

module "gcp_composer" {
  source = "../../modules/gcp_composer"

  composer_environment_size = "ENVIRONMENT_SIZE_SMALL"
  composer_image_version    = "composer-2.0.12-airflow-2.2.3"
  composer_region           = local.gcp_project_region
  environment               = local.environment
  gcp_project_id            = local.gcp_project_id
  labels                    = local.labels
}
