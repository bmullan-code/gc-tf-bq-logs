
resource "google_compute_instance" "vm_instance" {
  name         = "${var.prefix}-apache-http-server"
  #machine_type = "e2-micro"
  machine_type = "c2-standard-4"
  tags = ["http-server","https-server"]

  service_account {
    email  = var.default_service_account
    scopes = ["cloud-platform"]
  }
  

  shielded_instance_config {
    enable_secure_boot          = true
    enable_integrity_monitoring = true
  }

  network_interface {
    network = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.network-with-private-secondary-ip-ranges.id
    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  provisioner "local-exec" {
    command = "sleep 60 && gcloud compute ssh ${google_compute_instance.vm_instance.name} --tunnel-through-iap --command \"sudo service google-cloud-ops-agent restart\""
  }

  metadata_startup_script = <<EOT
#! /bin/bash
apt-get update
apt-get install -y apache2 php7.0
cat <<EOF > /var/www/html/index.html
<html><body><h1>Hello World</h1>
<p>This page was created from a simple startup script!</p>
</body></html>
EOF
#setup logging
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install

# Configures Ops Agent to collect telemetry from the app and restart Ops Agent.

set -e

# Create a back up of the existing file so existing configurations are not lost.
sudo cp /etc/google-cloud-ops-agent/config.yaml /etc/google-cloud-ops-agent/config.yaml.bak

# Configure the Ops Agent.
sudo tee /etc/google-cloud-ops-agent/config.yaml > /dev/null << EOF
metrics:
  receivers:
    apache:
      type: apache
  service:
    pipelines:
      apache:
        receivers:
          - apache
logging:
  receivers:
    apache_access:
      type: apache_access
    apache_error:
      type: apache_error
  service:
    pipelines:
      apache:
        receivers:
          - apache_access
          - apache_error
EOF

sudo service google-cloud-ops-agent restart
echo "first restart" $? > logs.txt

# sleep 180
#echo "sleep " $? >> logs.txt
#sudo service apache2 restart
#echo "apache restart" $? >> logs.txt
#sudo service google-cloud-ops-agent restart
#echo "second restart" $? >> logs.txt

EOT
}
