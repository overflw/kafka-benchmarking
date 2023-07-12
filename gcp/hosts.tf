resource "local_file" "hosts" {
  filename = "./hosts.yml"
  content = templatefile("${path.module}/templates/hosts.tpl",
    {
      broker     = google_compute_instance.kafka_broker[*].network_interface.0.access_config.0.nat_ip
      controller = google_compute_instance.kafka_controller[*].network_interface.0.access_config.0.nat_ip
      zookeeper  = google_compute_instance.zookeeper[*].network_interface.0.access_config.0.nat_ip
      client     = google_compute_instance.client[*].network_interface.0.access_config.0.nat_ip
    }
  )
}
