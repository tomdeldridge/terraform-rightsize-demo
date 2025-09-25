# Variables for the Rightsize EC2 example

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "demo"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "rightsize-demo"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type - matches current Rightsize resource (t3.large)"
  type        = string
  default     = "t3.large"
  
  validation {
    condition = contains([
      "t2.micro", "t2.small", "t2.medium", "t2.large", "t2.xlarge", "t2.2xlarge",
      "t3.nano", "t3.micro", "t3.small", "t3.medium", "t3.large", "t3.xlarge", "t3.2xlarge",
      "m4.large", "m4.xlarge", "m4.2xlarge", "m4.4xlarge", "m4.10xlarge", "m4.16xlarge",
      "m5.large", "m5.xlarge", "m5.2xlarge", "m5.4xlarge", "m5.8xlarge", "m5.12xlarge", "m5.16xlarge", "m5.24xlarge",
      "c5.large", "c5.xlarge", "c5.2xlarge", "c5.4xlarge", "c5.9xlarge", "c5.12xlarge", "c5.18xlarge", "c5.24xlarge",
      "r5.large", "r5.xlarge", "r5.2xlarge", "r5.4xlarge", "r5.8xlarge", "r5.12xlarge", "r5.16xlarge", "r5.24xlarge"
    ], var.instance_type)
    error_message = "Instance type must be a valid EC2 instance type."
  }
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 20
}

variable "public_key" {
  description = "Public key for EC2 key pair"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7... # Replace with your actual public key"
  
  validation {
    condition     = can(regex("^ssh-", var.public_key))
    error_message = "Public key must be in SSH format (ssh-rsa, ssh-ed25519, etc.)."
  }
}

# Rightsize recommendation variables for reference
variable "rightsize_recommendations" {
  description = "Map of rightsizing recommendations from AWS Trusted Advisor"
  type = map(object({
    current_instance_type     = string
    recommended_instance_type = string
    action                   = string
    estimated_monthly_cost   = string
    estimated_monthly_savings = string
    savings_percentage       = string
    implementation_effort    = string
  }))
  
  default = {
    "rightsize" = {
      current_instance_type     = "t3.large"
      recommended_instance_type = "t2.large"
      action                   = "Rightsize"
      estimated_monthly_cost   = "$80.00"
      estimated_monthly_savings = "$48.00"
      savings_percentage       = "60"
      implementation_effort    = "Low"
    }
    "upgrade" = {
      current_instance_type     = "t2.large"
      recommended_instance_type = "t3.large"
      action                   = "Upgrade"
      estimated_monthly_cost   = "$80.00"
      estimated_monthly_savings = "$48.00"
      savings_percentage       = "60"
      implementation_effort    = "Low"
    }
    "stop" = {
      current_instance_type     = "i-0abcdef1234567"
      recommended_instance_type = ""
      action                   = "Stop"
      estimated_monthly_cost   = "$80.00"
      estimated_monthly_savings = "$48.00"
      savings_percentage       = "60"
      implementation_effort    = "Low"
    }
    "migrate_to_graviton" = {
      current_instance_type     = "m4.4xlarge"
      recommended_instance_type = "x8g.xlarge"
      action                   = "MigrateToGraviton"
      estimated_monthly_cost   = "$80.00"
      estimated_monthly_savings = "$48.00"
      savings_percentage       = "60"
      implementation_effort    = "Low"
    }
  }
}
