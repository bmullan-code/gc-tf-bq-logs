
resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "${var.prefix}_logs_dataset"
  friendly_name               = "${var.prefix}_logs_dataset"
  description                 = "${var.prefix}_logs_dataset"
  location                    = "US"
  default_table_expiration_ms = 3600000
  delete_contents_on_destroy  = "true"
}