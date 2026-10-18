# Container for external identities; GitHub is the only provider in it.
resource "google_iam_workload_identity_pool" "github" {
  project                   = google_project.main.project_id
  workload_identity_pool_id = "github"

  depends_on = [google_project_service.apis]
}

# Trusts GitHub tokens from one repo only, matched by numeric id: a repo name can be
# re-registered after delete or rename, an id is never reused. No condition = any GitHub repo.
resource "google_iam_workload_identity_pool_provider" "github" {
  project                            = google_project.main.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions"

  attribute_mapping = {
    "google.subject"          = "assertion.sub"
    "attribute.repository_id" = "assertion.repository_id"
  }

  attribute_condition = "assertion.repository_id == '${var.github_repository_id}'"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# Lets workflows from that repo impersonate the dbt service account; no keys exist.
resource "google_service_account_iam_member" "dbt_wif_user" {
  service_account_id = google_service_account.dbt.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository_id/${var.github_repository_id}"
}
