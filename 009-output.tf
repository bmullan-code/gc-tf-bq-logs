output "vm-internal-ip" {
  value = google_compute_instance.vm_instance.network_interface.0.network_ip
}

output "iap-tunnel-cmd" {
  value = "gcloud compute start-iap-tunnel ${google_compute_instance.vm_instance.name} 80 --local-host-port=localhost:8080"
}

