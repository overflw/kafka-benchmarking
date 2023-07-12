variable "clusters_region" {
    type    = string
    default = "europe-west6"
}

variable "clusters_zone" {
    type    = string
    default = "europe-west6-a"
}

variable "clusters_project" {
    type    = string
    default = "kafka-benchmark-test"
}

variable "instance_count" {
    type    = map
    default = {
        broker = 2
        controller = 0
        zookeeper = 1
        client = 1
    }
}

variable "instance_type" {
    type    = string
    default = "n2-standard-2"
}

variable "ssh_key_location" {
    type    = string
    default = "~/.ssh/tf.pub"
}