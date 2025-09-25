#!/bin/bash
# User data script for EC2 instance setup
# This script runs on instance launch

# Update system packages
yum update -y

# Install basic utilities
yum install -y \
    htop \
    git \
    curl \
    wget \
    unzip \
    tree \
    jq

# Install CloudWatch agent for better monitoring
yum install -y amazon-cloudwatch-agent

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws/

# Install Docker (optional - for containerized workloads)
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

# Create a simple web server for testing
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Rightsize Demo Instance</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { background-color: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .header { color: #232f3e; border-bottom: 2px solid #ff9900; padding-bottom: 10px; }
        .info-box { background-color: #e8f4fd; padding: 15px; margin: 15px 0; border-radius: 4px; border-left: 4px solid #0073bb; }
        .warning-box { background-color: #fff3cd; padding: 15px; margin: 15px 0; border-radius: 4px; border-left: 4px solid #ffc107; }
        .metric { display: inline-block; margin: 10px 20px 10px 0; }
        .metric-value { font-size: 24px; font-weight: bold; color: #0073bb; }
        .metric-label { font-size: 14px; color: #666; }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="header">🏗️ Rightsize Demo Instance</h1>
        
        <div class="info-box">
            <h3>Instance Information</h3>
            <p><strong>Project:</strong> ${project_name}</p>
            <p><strong>Instance Type:</strong> t3.large</p>
            <p><strong>Region:</strong> us-east-1</p>
            <p><strong>Purpose:</strong> Demonstration of AWS Trusted Advisor Rightsizing Recommendations</p>
        </div>

        <div class="warning-box">
            <h3>⚠️ Cost Optimization Opportunities</h3>
            <p>This instance has been flagged by AWS Trusted Advisor for potential cost savings:</p>
            <ul>
                <li><strong>Current Cost:</strong> ~$80.00/month</li>
                <li><strong>Potential Savings:</strong> ~$48.00/month (60%)</li>
                <li><strong>Recommended Actions:</strong></li>
                <ul>
                    <li>Rightsize from t3.large to t2.large</li>
                    <li>Consider stopping if underutilized</li>
                    <li>Migrate to Graviton processors for better price/performance</li>
                </ul>
            </ul>
        </div>

        <h3>📊 Key Metrics to Monitor</h3>
        <div class="metric">
            <div class="metric-value" id="cpu-usage">--</div>
            <div class="metric-label">CPU Usage %</div>
        </div>
        <div class="metric">
            <div class="metric-value" id="memory-usage">--</div>
            <div class="metric-label">Memory Usage %</div>
        </div>
        <div class="metric">
            <div class="metric-value" id="network-in">--</div>
            <div class="metric-label">Network In (MB)</div>
        </div>
        <div class="metric">
            <div class="metric-value" id="network-out">--</div>
            <div class="metric-label">Network Out (MB)</div>
        </div>

        <div class="info-box">
            <h3>💡 Rightsizing Best Practices</h3>
            <ul>
                <li>Monitor CPU, memory, and network utilization over time</li>
                <li>Look for consistent low utilization patterns (< 10% CPU)</li>
                <li>Consider burstable instances (T3/T4g) for variable workloads</li>
                <li>Use CloudWatch alarms to track utilization trends</li>
                <li>Test performance after rightsizing to ensure application requirements are met</li>
            </ul>
        </div>

        <p><small>Generated at: $(date)</small></p>
    </div>

    <script>
        // Simple script to show some basic system info
        // In a real scenario, you'd integrate with CloudWatch metrics
        function updateMetrics() {
            // Placeholder values - in production, fetch from CloudWatch or system metrics
            document.getElementById('cpu-usage').textContent = Math.floor(Math.random() * 15 + 5);
            document.getElementById('memory-usage').textContent = Math.floor(Math.random() * 20 + 10);
            document.getElementById('network-in').textContent = (Math.random() * 50 + 10).toFixed(1);
            document.getElementById('network-out').textContent = (Math.random() * 30 + 5).toFixed(1);
        }
        
        updateMetrics();
        setInterval(updateMetrics, 5000);
    </script>
</body>
</html>
EOF

# Install and start Apache web server
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# Set up CloudWatch agent configuration for detailed monitoring
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << EOF
{
    "metrics": {
        "namespace": "CWAgent",
        "metrics_collected": {
            "cpu": {
                "measurement": [
                    "cpu_usage_idle",
                    "cpu_usage_iowait",
                    "cpu_usage_user",
                    "cpu_usage_system"
                ],
                "metrics_collection_interval": 300,
                "totalcpu": false
            },
            "disk": {
                "measurement": [
                    "used_percent"
                ],
                "metrics_collection_interval": 300,
                "resources": [
                    "*"
                ]
            },
            "diskio": {
                "measurement": [
                    "io_time"
                ],
                "metrics_collection_interval": 300,
                "resources": [
                    "*"
                ]
            },
            "mem": {
                "measurement": [
                    "mem_used_percent"
                ],
                "metrics_collection_interval": 300
            },
            "netstat": {
                "measurement": [
                    "tcp_established",
                    "tcp_time_wait"
                ],
                "metrics_collection_interval": 300
            },
            "swap": {
                "measurement": [
                    "swap_used_percent"
                ],
                "metrics_collection_interval": 300
            }
        }
    }
}
EOF

# Start CloudWatch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config \
    -m ec2 \
    -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
    -s

# Create a log entry
echo "$(date): Rightsize demo instance ${project_name} initialized successfully" >> /var/log/rightsize-demo.log

# Set up a simple monitoring script
cat > /home/ec2-user/monitor.sh << 'EOF'
#!/bin/bash
# Simple monitoring script to help with rightsizing decisions

echo "=== Instance Monitoring Report ==="
echo "Date: $(date)"
echo "Instance Type: $(curl -s http://169.254.169.254/latest/meta-data/instance-type)"
echo "Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)"
echo ""

echo "=== CPU Usage ==="
top -bn1 | grep "Cpu(s)" | awk '{print $2}' | sed 's/%us,//'

echo ""
echo "=== Memory Usage ==="
free -h

echo ""
echo "=== Disk Usage ==="
df -h

echo ""
echo "=== Network Statistics ==="
cat /proc/net/dev | grep eth0

echo ""
echo "=== Load Average ==="
uptime

echo ""
echo "=== Top Processes ==="
ps aux --sort=-%cpu | head -10
EOF

chmod +x /home/ec2-user/monitor.sh
chown ec2-user:ec2-user /home/ec2-user/monitor.sh

# Create a cron job to run monitoring every hour
echo "0 * * * * /home/ec2-user/monitor.sh >> /var/log/instance-monitoring.log 2>&1" | crontab -u ec2-user -

echo "User data script completed successfully" >> /var/log/user-data.log
