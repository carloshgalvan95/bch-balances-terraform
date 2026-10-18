# Names match the GitHub Variables of the dbt repo in lowercase, so each value is copied 1:1.

output "gcp_wif_provider" {
  description = "Full provider name for google-github-actions/auth workload_identity_provider."
  value       = google_iam_workload_identity_pool_provider.github.name
}

output "gcp_sa_email" {
  description = "Service account the dbt workflow impersonates."
  value       = google_service_account.dbt.email
}

output "dbt_gcp_project" {
  description = "Project where dbt runs jobs and writes tables."
  value       = google_project.main.project_id
}

output "dbt_staging_dataset" {
  description = "Staging dataset id."
  value       = google_bigquery_dataset.staging.dataset_id
}

output "dbt_mart_dataset" {
  description = "Mart dataset id."
  value       = google_bigquery_dataset.mart.dataset_id
}

output "dbt_location" {
  description = "BigQuery location of both datasets."
  value       = google_bigquery_dataset.staging.location
}
