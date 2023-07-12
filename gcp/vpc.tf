resource "google_compute_network" "vpc_network" {
  name                    = "kafka-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "kafka_subnet" {
  name          = "kafka-subnet"
  ip_cidr_range = "10.1.1.0/24"
  network       = "${google_compute_network.vpc_network.self_link}"
}

resource "google_compute_firewall" "default-allow-internal" {
  name    = "allow-internal"
  network = google_compute_network.vpc_network.self_link

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }
  target_tags   = ["kafka"]
  source_ranges = ["${google_compute_subnetwork.kafka_subnet.ip_cidr_range}"]
}


resource "google_compute_firewall" "ssh-rule" {
  name    = "ssh"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags   = ["kafka"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "kafka-broker-rule" {
  name    = "kafka-broker-rule"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["9092"]
  }
  
  allow {
    protocol = "tcp"
    ports    = ["9091"]
  }

  allow {
    protocol = "tcp"
    ports    = ["9098"]
  }

  target_tags   = ["kafka"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "kafka-controller-rule" {
  name    = "kafka-controller-rule"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["8090"]
  }
  target_tags   = ["kafka-controller"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "zookeeper-rule" {
  name    = "zookeeper-rule"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["2181"]
  }

  allow {
    protocol = "tcp"
    ports    = ["2888"]
  }

  allow {
    protocol = "tcp"
    ports    = ["3888"]
  }

  target_tags   = ["zookeeper"]
  source_ranges = ["0.0.0.0/0"]
}

