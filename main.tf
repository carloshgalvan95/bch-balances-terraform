# No org_id or folder_id: the account has no organization, so the project is
# created at the top of its own hierarchy.
resource "google_project" "main" {
  name            = "bch-balances"
  project_id      = var.project_id
  billing_account = var.billing_account

  # PREVENT makes any plan that would delete the project fail. A deleted project
  # ID can never be reused and holds a quota slot for 30 days. To tear down,
  # change this to "DELETE", apply, then destroy.
  deletion_policy = "PREVENT"
}

# A new project starts with no APIs enabled. Anything that later creates
# datasets, the service account or the WIF pool must declare
# depends_on = [google_project_service.apis].
locals {
  apis = [
    # Datasets and dbt query jobs.
    "bigquery.googleapis.com",
    # Service account and WIF pool/provider.
    "iam.googleapis.com",
    # generateAccessToken: GitHub's federated token impersonates the service account.
    "iamcredentials.googleapis.com",
    # Exchanges the GitHub OIDC token for a Google federated token.
    "sts.googleapis.com",
    # Project IAM bindings (getIamPolicy/setIamPolicy); listed by Google's WIF guide:
    # https://cloud.google.com/iam/docs/workload-identity-federation-with-deployment-pipelines
    "cloudresourcemanager.googleapis.com",
  ]
}

resource "google_project_service" "apis" {
  for_each = toset(local.apis)

  project = google_project.main.project_id
  service = each.value

  # Leave APIs on if this resource is destroyed. Teardown deletes the whole
  # project, which removes its APIs with it.
  disable_on_destroy = false
}

# Separate layer so the filtered 3-month input is built once and reused by the mart.
resource "google_bigquery_dataset" "staging" {
  project     = google_project.main.project_id
  dataset_id  = "bch_staging"
  location    = var.location
  description = "Staging tables built by dbt from the public Bitcoin Cash dataset."

  depends_on = [google_project_service.apis]
}

# Only layer consumers query, so later access can be granted here without staging.
resource "google_bigquery_dataset" "mart" {
  project     = google_project.main.project_id
  dataset_id  = "bch_mart"
  location    = var.location
  description = "Mart tables built by dbt: address balances over the staging window."

  depends_on = [google_project_service.apis]
}
