# --- CloudStack Provider Variables ---
# These replace the aws_region concept

variable "cloudstack_api_url" {
  description = "The CloudStack API endpoint"
}

variable "cloudstack_api_key" {
  description = "CloudStack API Key"
  sensitive   = true
}

variable "cloudstack_secret_key" {
  description = "CloudStack Secret Key"
  sensitive   = true
}

# --- Infrastructure Variables ---

variable "cs_zone" {
  description = "CloudStack Zone name or ID"
  default     = "zcs-et-aa01"
}

variable "cs_network_id" {
  description = "The UUID of the network where VMs will be deployed"
}

# --- Instance Sizing (Service Offerings) ---

variable "master_instance_type" {
  description = "Service offering for the Master node (Needs 2+ CPUs)"
  default     = "2C4G" # Standardized naming you found
}

variable "worker_instance_type" {
  description = "Service offering for Worker nodes"
  default     = "1C2G" # The name we verified earlier
}

# --- Template (Equivalent to AMI) ---

variable "cloudstack_template" {
  description = "Name or ID of the Ubuntu template"
  default     = "ubuntu-server-24.04"
}

# --- Access Control ---

variable "key_name" {
  description = "Name of the SSH key pair already uploaded to CloudStack"
  default     = "cloudstack_keypair"
}

variable "allowed_ssh_ip" {
  description = "IP allowed to access the CloudStack Virtual Router/Public IP"
}