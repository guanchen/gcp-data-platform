variable "composer_image_version" {
  description = "Composer image version"

  type = string

  validation {
    condition     = substr(var.composer_image_version, 0, 11) == "composer-2."
    error_message = "The value must start with 'composer-2.'"
  }
}

variable "composer_environment_size" {
  description = "Composer environment size"

  type = string

  validation {
    condition     = contains(["ENVIRONMENT_SIZE_SMALL", "ENVIRONMENT_SIZE_MEDIUM", "ENVIRONMENT_SIZE_LARGE"], var.composer_environment_size)
    error_message = "The value must be 'ENVIRONMENT_SIZE_{SMALL/MEDIUM/LARGE}']"
  }
}

variable "environment" {
  description = "Your project environement"

  type = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "The value must be included in ['dev','staging', 'prod']"
  }
}

variable "composer_region" {
  description = "Region used by Composer"

  type = string
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
