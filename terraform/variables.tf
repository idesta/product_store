variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

# We split this into two to give the Master more power
variable "master_instance_type" {
  default = "t3.medium"
}

variable "worker_instance_type" {
  default = "t3.small"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  # No default here, we use terraform.tfvars for the value
}

variable "allowed_ssh_ip" {
  description = "IP allowed to SSH into nodes"
}

variable "ubuntu_ami_id" {
  description = "Ubuntu 24.04 AMI ID"
  default     = "ami-0b6c6ebed2801a5cb"
}