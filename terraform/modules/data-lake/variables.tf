variable "bucket_location" {
  description = "The location of your bucket"

  type = string
}

variable "bucket_name" {
  description = "The name of your bucket"

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
