# Backend configuration for ALFA environment
# Account ID: 618300337335
# Usage: terraform init -backend-config=environments/alfa/backend.hcl

bucket         = "terraform-state-618300337335-alfa"
key            = "rightsize-demo/terraform.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "terraform-state-lock-618300337335-alfa"
