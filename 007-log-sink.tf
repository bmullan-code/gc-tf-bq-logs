resource "google_logging_project_sink" "log-sink" {
  name = "${var.prefix}-bigquery-log-sink"

  destination = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${google_bigquery_dataset.dataset.dataset_id}"
  filter = "logName=\"projects/${var.project_id}/logs/apache_access\""
  unique_writer_identity = true

}

# Because our sink uses a unique_writer, we must grant that writer access to the bucket.
resource "google_project_iam_binding" "log-writer" {
  project = var.project_id
  role = "roles/bigquery.user"

  members = [
    google_logging_project_sink.log-sink.writer_identity,
  ]
}

resource "google_project_iam_binding" "log-owner" {
  project = var.project_id
  role = "roles/bigquery.dataOwner"

  members = [
    google_logging_project_sink.log-sink.writer_identity,
  ]
}
