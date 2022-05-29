terraform {
  backend "gcs" {
    bucket = "terraform_gsong"
    prefix = "environments/dev"
  }
}
