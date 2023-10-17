variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "eu-central-1"
}

variable "instance_count" {
  type = map(string)

  default = {
    "rest"            = 0
    "connect"         = 0
    "ksql"            = 0
    "schema"          = 0
    "control_center"  = 0
    "broker"          = 3
    "zookeeper"       = 1
    "controller"      = 0
    "client"          = 2
    "anoniks"         = 1
  }
}

variable "instance_prefix" {
  default     = "staging"
}

variable "aws_ami" {
  description = "AWS AMI for Ubuntu Server 18.04 LTS (HVM), SSD Volume Type"
  default = "ami-0242b6a1b2a6d463a"
  #description = "AWS AMI for Debian 10 Buster"
  #default = "ami-0ee256407f6444c24"
  #description = "AWS AMI for Ubuntu Server 20.04 LTS (HVM), SSD Volume Type"
  #default     = "ami-0136ddddd07f0584f"
}

variable "aws_instance_type" {
  description = "The AWS Instance Type."
  default     = "t2.micro"
}

variable "aws_instance_type_client" {
  description = "The AWS Instance Type."
  default     = "m5n.2xlarge" # m5n.2xlarge (8vcpu) org: m5n.8xlarge
}

variable "aws_instance_type_broker" {
  description = "The AWS Instance Type."
  default     = "i3en.2xlarge" # i3en.2xlarge (8vcpu) org: i3en.6xlarge
}

variable "aws_instance_type_zookeeper" {
  description = "The AWS Instance Type."
  default     = "i3en.large" # i3en.xlarge (4vcpu) org: i3en.2xlarge
}

variable "aws_instance_type_anoniks" {
  description = "The AWS Instance Type."
  default     = "i3en.large" # i3en.xlarge (4vcpu) org: i3en.2xlarge
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for public subnet"
  default     = "10.0.1.0/24"
}

variable "key_name" {
  description = "Key Pair"
  default     = "tf-key"
}

