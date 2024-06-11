provider "google" {
  credentials = /workspaces/jenkins/hardy-binder-411706-334012125403.json
  project     = "hardy-binder-411706"
  region      = "us-central1"
}

resource "google_compute_instance" "default" {
  name         = "webjenkins
  machine_type = "e2-medium"
  zone = "us-central1-a"
 
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
 
}
 
output "instance_ip" {
  value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}
