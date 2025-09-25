# Terraform version constraints
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Optional: Configure Terraform backend for state management
# Uncomment and customize for production use
/*
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "rightsize-demo/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
*/
