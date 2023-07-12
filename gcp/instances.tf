resource "google_compute_instance" "kafka_broker" {
  count        = "${var.instance_count["broker"]}"
  name         = "kafka-broker-${count.index}"
  machine_type = "${var.instance_type}"
  metadata = {
    ssh-keys = "ubuntu:${file("${var.ssh_key_location}")}"
  }
  allow_stopping_for_update = true
  tags                      = ["kafka"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20230605"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kafka_subnet.self_link}"
    access_config {}
  }
}

resource "google_compute_instance" "zookeeper" {
  count        = "${var.instance_count["zookeeper"]}"
  name         = "zookeeper-${count.index}"
  machine_type = "${var.instance_type}"
  metadata = {
    ssh-keys = "ubuntu:${file("${var.ssh_key_location}")}"
  }
  allow_stopping_for_update = true
  tags                      = ["kafka","zookeeper"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20230605"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kafka_subnet.self_link}"
    access_config {}
  }
}

resource "google_compute_instance" "kafka_controller" {
  count        = "${var.instance_count["controller"]}"
  name         = "kafka-controller-${count.index}"
  machine_type = "${var.instance_type}"
  metadata = {
    ssh-keys = "ubuntu:${file("${var.ssh_key_location}")}"
  }
  allow_stopping_for_update = true
  tags                      = ["kafka","kafka-controller"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20230605"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kafka_subnet.self_link}"
    access_config {}
  }
}

resource "google_compute_instance" "client" {
  count        = "${var.instance_count["client"]}"
  name         = "client-${count.index}"
  machine_type = "${var.instance_type}"
  metadata = {
    ssh-keys = "ubuntu:${file("${var.ssh_key_location}")}"
  }
  allow_stopping_for_update = true
  tags                      = ["kafka","client"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20230605"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kafka_subnet.self_link}"
    access_config {}
  }
}