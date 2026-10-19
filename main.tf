# No org_id or folder_id: the account has no organization, so the project is
# created at the top of its own hierarchy.
resource "google_project" "main" {
  name            = "bch-balances"
  project_id      = var.project_id
  billing_account = var.billing_account

  # PREVENT blocks only the project delete, which runs last: a plain destroy
  # removes everything else first. A deleted project ID can never be reused
  # and holds a quota slot for 30 days. To tear down, see README Teardown.
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
