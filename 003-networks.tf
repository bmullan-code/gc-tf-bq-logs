
resource "google_compute_network" "vpc_network" {
  name                    = "${var.prefix}-terraform-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "vpc_subnet" {
    name          = "${var.prefix}-terraform-subnet"
    ip_cidr_range = var.network_subnet_0_cidr
    region        = var.region
    network       = google_compute_network.vpc_network.id
}

resource "google_compute_router" "router" {
  name    = "${var.prefix}-terraform-router"
  region  = google_compute_subnetwork.vpc_subnet.region
  network = google_compute_network.vpc_network.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name    = "${var.prefix}-terraform-nat"
  router  = google_compute_router.router.name
  region  = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

