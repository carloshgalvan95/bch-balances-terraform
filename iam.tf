# Identity dbt runs as in CI. No keys: the workflow impersonates it through WIF.
resource "google_service_account" "dbt" {
  project      = google_project.main.project_id
  account_id   = "dbt-runner"
  display_name = "dbt runner"

  depends_on = [google_project_service.apis]
}

# Query jobs are a project-level permission; this grants no data access.
resource "google_project_iam_member" "dbt_job_user" {
  project = google_project.main.project_id
  role    = "roles/bigquery.jobUser"
  member  = google_service_account.dbt.member
}

# dbt builds the staging tables, so it writes here and nowhere else.
resource "google_bigquery_dataset_iam_member" "dbt_staging_editor" {
  project    = google_bigquery_dataset.staging.project
  dataset_id = google_bigquery_dataset.staging.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = google_service_account.dbt.member
}

# dbt builds the mart table, so it writes here and nowhere else.
resource "google_bigquery_dataset_iam_member" "dbt_mart_editor" {
  project    = google_bigquery_dataset.mart.project
  dataset_id = google_bigquery_dataset.mart.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = google_service_account.dbt.member
}
