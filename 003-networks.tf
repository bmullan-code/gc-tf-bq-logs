
resource "google_compute_network" "vpc_network" {
  name                    = "${var.prefix}-terraform-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
    name          = "${var.prefix}-terraform-subnet"
    ip_cidr_range = var.network_subnet_0_cidr
    region        = var.region
    network       = google_compute_network.vpc_network.id
}

