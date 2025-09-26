# Terraform version constraints and S3 backend configuration
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # S3 Backend configuration
  # Use environment-specific backend files:
  # - For ALFA: terraform init -backend-config=environments/alfa/backend.hcl
  # - For PROD: terraform init -backend-config=environments/prod/backend.hcl
  backend "s3" {}
}
