provider "google" {
  credentials = file("./credentials.json")
  project     = "${var.clusters_project}"
  region      = "${var.clusters_region}"
  zone        = "${var.clusters_zone}"
}


