locals {
  environment        = "dev"
  gcp_project_id     = "week1-350310"
  gcp_project_region = "us-central1"

  bigquery_dataset = "week1_350310_dataset_dev"
  data_location    = "US"

  labels = {
    "environment" = local.environment,
    "managed-by"  = "terraform",
  }
}
