terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.22.0"
    }
  }
}

module "data_lake" {
  source = "../../modules/data-lake"

  bucket_location = local.data_location # Needs to match dataset_location for data transfer
  bucket_name     = "${local.gcp_project_id}-bucket-${local.environment}"
  environment     = local.environment
  gcp_project_id  = local.gcp_project_id
  labels          = local.labels
}

module "data_warehouse" {
  source = "../../modules/data-warehouse"

  dataset_id       = local.bigquery_dataset
  dataset_location = local.data_location # Needs to match bucket_location for data transfer
  environment      = local.environment
  gcp_project_id   = local.gcp_project_id
  labels           = local.labels
}

module "workflow_platform" {
  source = "../../modules/workflow-platform"

  composer_environment_size = "ENVIRONMENT_SIZE_SMALL"
  composer_image_version    = "composer-2.0.12-airflow-2.2.3"
  composer_region           = local.gcp_project_region
  environment               = local.environment
  gcp_project_id            = local.gcp_project_id
  labels                    = local.labels
}
