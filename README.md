# AWS EC2 Rightsize Demo - Terraform Repository

This Terraform repository creates an EC2 instance that matches the configuration from AWS Trusted Advisor's "Amazon EC2 cost optimization recommendations for instances" check. It demonstrates various rightsizing scenarios and cost optimization opportunities.

## 🎯 Purpose

This repository is designed to:
- Demonstrate AWS Trusted Advisor rightsizing recommendations
- Provide a practical example of cost optimization opportunities
- Show how to implement monitoring for rightsizing decisions
- Serve as a testing ground for different instance types and configurations

## 📊 Rightsize Recommendations Context

Based on the AWS Trusted Advisor data, this instance represents several optimization scenarios:

| Scenario | Current Type | Recommended Type | Action | Monthly Savings |
|----------|-------------|------------------|---------|-----------------|
| **Rightsize** | t3.large | t2.large | Downgrade | $48.00 (60%) |
| **Upgrade** | t2.large | t3.large | Upgrade | $48.00 (60%) |
| **Stop** | Any | N/A | Stop unused | $48.00 (60%) |
| **Graviton Migration** | m4.4xlarge | x8g.xlarge | Migrate | $48.00 (60%) |

**Trusted Advisor Check ID:** `c1z7kmr00n`  
**Current Monthly Cost:** ~$80.00  
**Potential Savings:** ~$48.00 (60%)

## 🏗️ Infrastructure Components

This Terraform configuration creates:

- **VPC** with public subnet and internet gateway
- **EC2 Instance** (t3.large by default) with detailed monitoring
- **Security Group** with SSH, HTTP, and HTTPS access
- **CloudWatch Alarms** for CPU utilization monitoring
- **Key Pair** for SSH access
- **Web Server** with rightsizing information dashboard

## 🚀 Quick Start

### Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.0 installed
- SSH key pair for EC2 access

### Deployment Steps

1. **Clone and navigate to the repository:**
   ```bash
   git clone <repository-url>
   cd test-repo
   ```

2. **Configure variables:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
   
   Edit `terraform.tfvars` and update:
   - `public_key`: Your SSH public key
   - `aws_region`: Your preferred AWS region (default: us-east-1)
   - `instance_type`: Instance type to deploy (default: t3.large)

3. **Initialize and deploy:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

4. **Access the instance:**
   ```bash
   # SSH access
   ssh -i ~/.ssh/your-key ec2-user@<public-ip>
   
   # Web dashboard
   http://<public-ip>
   ```

## 📈 Monitoring and Rightsizing

### CloudWatch Alarms

The configuration includes CloudWatch alarms for:
- **High CPU utilization** (>80%) - indicates potential need for larger instance
- **Low CPU utilization** (<10%) - indicates rightsizing opportunity

### Monitoring Script

A monitoring script is installed at `/home/ec2-user/monitor.sh` that provides:
- CPU usage statistics
- Memory utilization
- Disk usage
- Network statistics
- Top processes

Run manually or check hourly logs at `/var/log/instance-monitoring.log`.

### Web Dashboard

Access the web dashboard at `http://<instance-public-ip>` to view:
- Instance information and current configuration
- Rightsizing recommendations
- Key metrics (simulated)
- Best practices for cost optimization

## 🔧 Testing Different Instance Types

To test rightsizing recommendations, modify the `instance_type` variable:

```hcl
# In terraform.tfvars
instance_type = "t2.large"    # Test downgrade recommendation
instance_type = "t3.medium"   # Test smaller alternative
instance_type = "t3.xlarge"   # Test larger alternative
instance_type = "m5.large"    # Test different family
```

Then apply the changes:
```bash
terraform plan
terraform apply
```

## 💰 Cost Optimization Strategies

### 1. Right-sizing Based on Utilization
- Monitor CPU, memory, and network utilization over 2-4 weeks
- Look for consistent patterns of low utilization (<10% CPU)
- Consider burstable instances (T3/T4g) for variable workloads

### 2. Instance Family Optimization
- **T3/T4g**: Burstable performance for variable workloads
- **M5/M6i**: Balanced compute, memory, and networking
- **C5/C6i**: Compute-optimized for CPU-intensive applications
- **R5/R6i**: Memory-optimized for memory-intensive applications

### 3. Graviton Migration
- Consider ARM-based Graviton processors for up to 40% better price performance
- Test application compatibility before migration
- Use instance types like M6g, C6g, R6g

### 4. Scheduling and Automation
- Use AWS Instance Scheduler for dev/test environments
- Implement auto-scaling for variable workloads
- Consider Spot Instances for fault-tolerant workloads

## 📋 Outputs

After deployment, Terraform provides:

```bash
terraform output
```

Key outputs include:
- `instance_id`: EC2 instance identifier
- `instance_public_ip`: Public IP for SSH/web access
- `ssh_connection_command`: Ready-to-use SSH command
- `rightsize_recommendations`: Summary of optimization opportunities
- `cloudwatch_alarms`: Monitoring alarm ARNs

## 🧹 Cleanup

To avoid ongoing costs:

```bash
terraform destroy
```

## 📚 Additional Resources

- [AWS Trusted Advisor Cost Optimization](https://docs.aws.amazon.com/support/latest/user/cost-optimization-checks.html)
- [AWS Compute Optimizer](https://aws.amazon.com/compute-optimizer/)
- [EC2 Instance Types](https://aws.amazon.com/ec2/instance-types/)
- [AWS Cost Optimization Hub](https://docs.aws.amazon.com/cost-management/latest/userguide/coh-getting-started.html)
- [CloudZero Cost Intelligence](https://www.cloudzero.com/)

## 🏷️ Tags and Metadata

All resources are tagged with:
- `Environment`: demo
- `Project`: rightsize-example
- `ManagedBy`: terraform
- `CostCenter`: engineering
- `Owner`: cloudzero-demo

Additional instance-specific tags include rightsizing metadata for cost tracking and optimization analysis.

## ⚠️ Important Notes

- **Security**: The security group allows SSH access from anywhere (0.0.0.0/0). In production, restrict this to your IP range.
- **Costs**: Remember to destroy resources when not needed to avoid charges.
- **Monitoring**: Enable detailed monitoring in production for better rightsizing decisions.
- **Backup**: Consider EBS snapshots for important data.

## 🤝 Contributing

This is a demonstration repository. For improvements or issues:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

---

**Disclaimer**: This is a demonstration environment. Always follow your organization's security and compliance requirements in production deployments.
