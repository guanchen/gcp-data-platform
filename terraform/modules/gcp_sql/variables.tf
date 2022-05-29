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

variable "gcp_service_account_email" {
  description = "The service account email used to query the database"

  type = string
}

variable "labels" {
  description = "A map of labels to apply to contained resources"

  default = {}
  type    = map(string)
}

variable "sql_database_version" {
  description = "The SQL Database engine and version"

  type = string

  validation {
    condition     = contains(["POSTGRES_12", "POSTGRES_13", "POSTGRES_14", "MYSQL_5_6", "MYSQL_5_7", "MYSQL_8_0"], var.db_version)
    error_message = "The value must be included in this list [POSTGRES_12/13/14, MYSQL_5_6/5_7, MYSQL_8_0]"
  }
}

variable "sql_instance_availability_type" {
  description = "The availability type of the Cloud SQL instance"

  type = string

  validation {
    condition     = var.db_instance_availability_type == "REGIONAL" || var.db_instance_availability_type == "ZONAL"
    error_message = "The value must be either 'REGIONAL' or 'ZONAL'."
  }
}

variable "sql_instance_tier" {
  description = "The SQL instance tier of the Cloud SQL instance"

  type = string

  validation {
    condition     = substr(var.db_instance_tier, 0, 3) == "db-"
    error_message = "The value must start with 'db-'"
  }
}
