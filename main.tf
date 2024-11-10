provider "google" {
  project = "devops-441313"
  region  = "us-central1"
}

resource "google_compute_network" "vpc_network" {
  name                    = "my-devops-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "default" {
  name          = "my-devops-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-west1"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "allow_specific_ports" {
  name    = "allow-specific-ports"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["25", "80", "443", "22", "6443", "465"]
  }

  allow {
    protocol = "tcp"
    ports    = ["3000-10000"]
  }

  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }

  source_ranges = ["0.0.0.0/0"]
  description   = "Allow specific TCP ports"
}

# Kubernetes Master and Worker Nodes (existing resources)
resource "google_compute_instance" "k8s_master" {
  name         = "k8s-master"
  machine_type = "e2-medium"
  zone         = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-focal-v20220712"
      size  = 50
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.default.id
    access_config {}
  }

  metadata_startup_script = file("startup_script_master.sh")
}

resource "google_compute_instance" "k8s_worker_1" {
  name         = "k8s-worker-1"
  machine_type = "e2-medium"
  zone         = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-focal-v20220712"
      size  = 50
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.default.id
    access_config {}
  }

  metadata_startup_script = file("startup_script_worker.sh")
}

resource "google_compute_instance" "k8s_worker_2" {
  name         = "k8s-worker-2"
  machine_type = "e2-medium"
  zone         = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-focal-v20220712"
      size  = 50
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.default.id
    access_config {}
  }

  metadata_startup_script = file("startup_script_worker.sh")
}

# VM for SonarQube
resource "google_compute_instance" "sonarqube" {
  name         = "sonarqube-vm"
  machine_type = "e2-standard-4"  # 4 vCPU, 16 GB RAM (adjust based on requirements)
  zone         = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-focal-v20220712"
      size  = 100  # Increased disk size for SonarQube requirements
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.default.id
    access_config {}
  }

  metadata_startup_script = file("sonar_install.sh")
}

# VM for Nexus
resource "google_compute_instance" "nexus" {
  name         = "nexus-vm"
  machine_type = "e2-standard-4"  
  zone         = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-focal-v20220712"
      size  = 100  # Increased disk size for Nexus requirements
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.default.id
    access_config {}
  }

  metadata_startup_script = file("nexus_install.sh")
}

# VM for Jenkins
resource "google_compute_instance" "jenkins" {
  name         = "jenkins-vm"
  machine_type = "e2-standard-4"  # 4 vCPU, 16 GB RAM (adjust based on requirements)
  zone         = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-focal-v20220712"
      size  = 100  # Increased disk size for Jenkins requirements
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.default.id
    access_config {}
  }

  metadata_startup_script = file("jenkins_install.sh")
}

