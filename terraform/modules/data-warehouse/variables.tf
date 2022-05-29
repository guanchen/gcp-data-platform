variable "dataset_location" {
  description = " The geographic location where the BigQuery dataset should reside."

  type = string
}

variable "dataset_id" {
  description = "A unique ID for your BigQuery dataset, without the project name."

  type = string
}

variable "environment" {
  description = "Your project environement"

  type = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "The value must be included in ['dev','staging', 'prod']"
  }
}

variable "gcp_project_id" {
  description = "Your GCP project id"

  type = string
}

variable "labels" {
  description = "A map of labels to apply to contained resources."

  default = {}
  type    = map(string)
}
