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

variable "github_repository_id" {
  description = "Numeric id of the dbt GitHub repo allowed to use WIF (carloshgalvan95/bch-balances-dbt; get it with: gh api repos/carloshgalvan95/bch-balances-dbt --jq .id). Unlike a name, it is never reused. A reviewer rebuilding from a fork puts their own repo id here; no code edit needed."
  type        = string

  validation {
    condition     = can(regex("^[0-9]+$", var.github_repository_id))
    error_message = "github_repository_id must be the numeric repository id, digits only."
  }
}
