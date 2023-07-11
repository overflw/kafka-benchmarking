resource "aws_subnet" "default" {
    vpc_id = aws_vpc.default.id

    cidr_block = var.public_subnet_cidr

    map_public_ip_on_launch = true

    tags = {
        Name = "Kafka Public Subnet"
    }
}

resource "local_file" "hosts" {
  filename = "./hosts.yml"
  content = templatefile("${path.module}/templates_tf/hosts.tpl",
    {
      broker = aws_instance.broker[*].public_dns
      zookeeper = aws_instance.zookeeper[*].public_dns
      controller = aws_instance.controller[*].public_dns
      client = aws_instance.client[*].public_dns
    }
  )
}