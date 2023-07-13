resource "local_file" "hosts" {
  filename = "../ansible/hosts.yml"
  content = templatefile("${path.module}/templates_tf/hosts.tpl",
    {
      broker = aws_instance.broker[*].public_dns
      zookeeper = aws_instance.zookeeper[*].public_dns
      controller = aws_instance.controller[*].public_dns
      client = aws_instance.client[*].public_dns
    }
  )
}