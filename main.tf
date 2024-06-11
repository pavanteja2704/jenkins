provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project_id
  region      = var.region
}
 
resource "google_compute_instance" "default" {
  name         = var.instance_name
  machine_type = var.machine_type
zone = var.zone
 
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }
 
  network_interface {
    network = "default"
 
    access_config {
      // Include this if you want to give the VM an external IP
    }
  }
 
  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2
  EOT
 
  tags = ["http-server"]
 
  metadata = {
    ssh-keys = var.ssh_keys
  }
}
 
output "instance_ip" {
  value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}
