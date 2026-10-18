variable "project_id" {
  description = "ID of the GCP project to create. Globally unique and never reusable, even after deletion."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "project_id must be 6 to 30 characters: lowercase letters, digits or hyphens, starting with a letter and not ending with a hyphen."
  }
}

variable "billing_account" {
  description = "ID of the Cloud Billing account linked to the project (gcloud billing accounts list). Kept in terraform.tfvars, never committed."
  type        = string

  validation {
    condition     = can(regex("^[0-9A-Z]{6}-[0-9A-Z]{6}-[0-9A-Z]{6}$", var.billing_account))
    error_message = "billing_account must look like XXXXXX-XXXXXX-XXXXXX (uppercase letters and digits)."
  }
}

variable "region" {
  description = "Default region for regional resources. us-central1 sits inside the US multi-region used by BigQuery."
  type        = string
  default     = "us-central1"
}

variable "location" {
  description = "BigQuery dataset location. Must match the public source dataset (US), since BigQuery cannot join across locations."
  type        = string
  default     = "US"
}
