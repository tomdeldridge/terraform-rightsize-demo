# Environment-Specific Configurations

This directory contains environment-specific configurations for the rightsize-demo project.

## Directory Structure

```
environments/
├── alfa/
│   ├── backend.hcl          # S3 backend config for alfa environment
│   └── terraform.tfvars     # Variable values for alfa environment
├── prod/
│   ├── backend.hcl          # S3 backend config for prod environment
│   └── terraform.tfvars     # Variable values for prod environment
└── README.md               # This file
```

## Usage

### Deploy to ALFA Environment

```bash
# Initialize with alfa backend
terraform init -backend-config=environments/alfa/backend.hcl

# Plan with alfa variables
terraform plan -var-file=environments/alfa/terraform.tfvars

# Apply with alfa variables
terraform apply -var-file=environments/alfa/terraform.tfvars
```

### Deploy to PROD Environment

```bash
# Initialize with prod backend
terraform init -backend-config=environments/prod/backend.hcl

# Plan with prod variables
terraform plan -var-file=environments/prod/terraform.tfvars

# Apply with prod variables
terraform apply -var-file=environments/prod/terraform.tfvars
```

## Backend Configuration

Each environment uses its own S3 bucket and DynamoDB table for state management:

### ALFA Environment
- **Bucket**: `terraform-state-618300337335-alfa`
- **DynamoDB Table**: `terraform-state-lock-618300337335-alfa`

### PROD Environment
- **Bucket**: `terraform-state-618300337335-prod`
- **DynamoDB Table**: `terraform-state-lock-618300337335-prod`

## Environment Differences

### ALFA
- Instance Type: `t3.large` (current state for rightsizing analysis)
- VPC CIDR: `10.0.0.0/16`
- Root Volume: 20 GB

### PROD
- Instance Type: `t2.large` (rightsized recommendation)
- VPC CIDR: `10.1.0.0/16` (different to avoid conflicts)
- Root Volume: 30 GB (larger for production workloads)

## Prerequisites

Before deploying to any environment, ensure:

1. **S3 Buckets exist**:
   ```bash
   aws s3 mb s3://terraform-state-618300337335-alfa
   aws s3 mb s3://terraform-state-618300337335-prod
   ```

2. **DynamoDB Tables exist**:
   ```bash
   aws dynamodb create-table \
     --table-name terraform-state-lock-618300337335-alfa \
     --attribute-definitions AttributeName=LockID,AttributeType=S \
     --key-schema AttributeName=LockID,KeyType=HASH \
     --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

   aws dynamodb create-table \
     --table-name terraform-state-lock-618300337335-prod \
     --attribute-definitions AttributeName=LockID,AttributeType=S \
     --key-schema AttributeName=LockID,KeyType=HASH \
     --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
   ```

3. **Update SSH Public Key**: Replace the placeholder public key in the `terraform.tfvars` files with your actual SSH public key.

## Switching Between Environments

To switch from one environment to another:

```bash
# Clean up current backend
rm -rf .terraform/

# Reinitialize with new environment
terraform init -backend-config=environments/{environment}/backend.hcl
```
