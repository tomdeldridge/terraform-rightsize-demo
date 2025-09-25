# Outputs for the Rightsize EC2 example

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.main.id
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.main.arn
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.main.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.main.private_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.main.public_dns
}

output "instance_type" {
  description = "Instance type of the EC2 instance"
  value       = aws_instance.main.instance_type
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.ec2_sg.id
}

output "key_pair_name" {
  description = "Name of the key pair"
  value       = aws_key_pair.main.key_name
}

# Rightsize-specific outputs
output "current_monthly_cost_estimate" {
  description = "Current estimated monthly cost from Rightsize data"
  value       = "$80.00"
}

output "potential_monthly_savings" {
  description = "Potential monthly savings from Rightsize recommendations"
  value       = "$48.00"
}

output "savings_percentage" {
  description = "Potential savings percentage"
  value       = "60%"
}

output "rightsize_recommendations" {
  description = "Summary of rightsizing recommendations"
  value = {
    current_instance_type = var.instance_type
    recommendations = [
      "Rightsize from t3.large to t2.large",
      "Upgrade from t2.large to t3.large", 
      "Stop underutilized instance",
      "Migrate from m4.4xlarge to x8g.xlarge (Graviton)"
    ]
    trusted_advisor_check_id = "c1z7kmr00n"
    check_name = "Amazon EC2 cost optimization recommendations for instances"
  }
}

output "cloudwatch_alarms" {
  description = "CloudWatch alarms for monitoring instance utilization"
  value = {
    high_cpu_alarm = aws_cloudwatch_metric_alarm.cpu_utilization.arn
    low_cpu_alarm  = aws_cloudwatch_metric_alarm.cpu_low_utilization.arn
  }
}

output "ssh_connection_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ~/.ssh/${aws_key_pair.main.key_name} ec2-user@${aws_instance.main.public_ip}"
}
