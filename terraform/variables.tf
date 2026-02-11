variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "instance_type" {
  default = "t3.small"
}

variable "key_name" {
  description = "product-node-ci-cd-2"
}

variable "allowed_ssh_ip" {
  description = "0.0.0.0/0"
}


variable "ubuntu_ami_id" {
  description = "Ubuntu 24.04 AMI ID"
  default     = "ami-0b6c6ebed2801a5cb"
}
