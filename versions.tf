terraform {
  # "~> 1.16.6" allows 1.16.6 and later 1.16.x patches, never 1.17.
  required_version = "~> 1.16.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "8.7.0"
    }
  }
}

# No credentials argument: the provider reads Application Default Credentials
# created by "gcloud auth application-default login".
provider "google" {
  project = var.project_id
  region  = var.region
}
