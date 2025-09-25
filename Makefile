# Makefile for Terraform Rightsize Demo

.PHONY: help init plan apply destroy validate format check clean

# Default target
help: ## Show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

init: ## Initialize Terraform
	terraform init

validate: ## Validate Terraform configuration
	terraform validate

format: ## Format Terraform files
	terraform fmt -recursive

plan: ## Create Terraform execution plan
	terraform plan

apply: ## Apply Terraform configuration
	terraform apply

destroy: ## Destroy Terraform-managed infrastructure
	terraform destroy

output: ## Show Terraform outputs
	terraform output

check: validate format ## Run validation and formatting checks

clean: ## Clean up temporary files
	rm -rf .terraform/
	rm -f .terraform.lock.hcl
	rm -f terraform.tfplan
	rm -f *.log

# Rightsizing-specific targets
rightsize-t2-large: ## Deploy with t2.large instance (rightsize recommendation)
	terraform apply -var="instance_type=t2.large"

rightsize-t3-medium: ## Deploy with t3.medium instance (smaller alternative)
	terraform apply -var="instance_type=t3.medium"

rightsize-t3-xlarge: ## Deploy with t3.xlarge instance (larger alternative)
	terraform apply -var="instance_type=t3.xlarge"

monitor: ## Show monitoring command for SSH access
	@echo "Connect to instance and run monitoring:"
	@echo "ssh -i ~/.ssh/your-key ec2-user@$$(terraform output -raw instance_public_ip)"
	@echo "Then run: ./monitor.sh"

web-dashboard: ## Open web dashboard
	@echo "Web dashboard available at:"
	@echo "http://$$(terraform output -raw instance_public_ip)"

ssh: ## SSH to the instance
	@echo "SSH command:"
	@terraform output -raw ssh_connection_command

cost-estimate: ## Show cost estimates and recommendations
	@echo "=== Cost Optimization Summary ==="
	@echo "Current Monthly Cost: $$(terraform output -raw current_monthly_cost_estimate)"
	@echo "Potential Savings: $$(terraform output -raw potential_monthly_savings)"
	@echo "Savings Percentage: $$(terraform output -raw savings_percentage)"
	@echo ""
	@echo "=== Recommendations ==="
	@terraform output -json rightsize_recommendations | jq -r '.recommendations[]'

# Development targets
dev-setup: ## Set up development environment
	@echo "Setting up development environment..."
	@if [ ! -f terraform.tfvars ]; then \
		cp terraform.tfvars.example terraform.tfvars; \
		echo "Created terraform.tfvars from example. Please edit with your values."; \
	fi
	@echo "Development setup complete!"

quick-deploy: dev-setup init plan apply ## Quick deployment for development

# Safety targets
confirm-destroy: ## Destroy with confirmation prompt
	@echo "This will destroy all resources. Are you sure? [y/N]" && read ans && [ $${ans:-N} = y ]
	terraform destroy
