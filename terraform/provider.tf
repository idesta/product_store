terraform {
  # 1. Lock the Terraform CLI version to avoid team conflicts
  required_version = ">= 1.5.0"

  required_providers {
    # 2. Hard-pin the AWS provider for stability
    aws = {
      source  = "hashicorp/aws"
      version = "5.80.0" # Using a specific stable version
    }

    # 3. Add the Local provider to manage your hosts.ini file
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

provider "aws" {
  region = var.aws_region
}