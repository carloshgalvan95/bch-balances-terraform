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
