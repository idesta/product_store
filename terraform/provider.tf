terraform {
  # 1. CLI version lock
  required_version = ">= 1.5.0"

  required_providers {
    # 2. Replaced with the Apache CloudStack provider
    cloudstack = {
      source  = "cloudstack/cloudstack"
      version = "0.6.0" # Current stable version in 2026
    }

    # 3. Kept the Local provider for managing files
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

# 4. Configure the CloudStack Provider using your variables
provider "cloudstack" {
  api_url    = var.cloudstack_api_url
  api_key    = var.cloudstack_api_key
  secret_key = var.cloudstack_secret_key
}