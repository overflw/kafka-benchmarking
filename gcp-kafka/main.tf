provider "google" {
  credentials = file("./credentials.json")
  project     = "kafka-benchmark-test"
  region      = "europe-west6"
  zone        = "europe-west6-a"
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
  source_ranges = ["${google_compute_subnetwork.kafka_subnet.ip_cidr_range}",]
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

resource "google_compute_instance" "kafka_broker" {
  count        = 2
  name         = "kafka-broker-${count.index}"
  machine_type = "e2-small"
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/tf.pub")}"
  }
  allow_stopping_for_update = true
  tags                      = ["kafka"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20230605"
      #image = "https://bitnami.com/redirect/to/2308558/bitnami-kafka-3.4.0-r24-debian-11-amd64.ova"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kafka_subnet.self_link}"
    access_config {}
  }
}

resource "google_compute_instance" "kafka_controller" {
  count        = 1
  name         = "kafka-controller-${count.index}"
  machine_type = "e2-small"
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/tf.pub")}"
  }
  allow_stopping_for_update = true
  tags                      = ["kafka","kafka-controller"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20230605"
      #image = "https://bitnami.com/redirect/to/2308558/bitnami-kafka-3.4.0-r24-debian-11-amd64.ova"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kafka_subnet.self_link}"
    access_config {}
  }
}

resource "google_compute_network" "vpc_network" {
  name                    = "kafka-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "kafka_subnet" {
  name          = "kafka-subnet"
  ip_cidr_range = "10.1.1.0/24"
  network       = "${google_compute_network.vpc_network.self_link}"
}

resource "local_file" "hosts" {
  filename = "./hosts.yml"
  content = templatefile("${path.module}/templates/hosts.tpl",
    {
      broker = google_compute_instance.kafka_broker[*].network_interface.0.access_config.0.nat_ip
      controller = google_compute_instance.kafka_controller[*].network_interface.0.access_config.0.nat_ip
      #broker = {}
      #controller = {}
      zookeeper = {}
      client = {}
    }
  )
}

