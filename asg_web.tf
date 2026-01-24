# create ASG for web servers
# create launch template for web servers
resource "aws_launch_template" "web_server_lt" {
  name_prefix   = "${var.project_name}-web-server-lt-"
  image_id      = "ami-0ea3405d2d2522162" # Amazon Linux 2023 AMI for eu-west-1
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.web_sg.id]
  }

user_data = base64encode(<<-EOF
#!/bin/bash

# Log all commands and errors
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "Starting user data script..."

# Update system packages
yum update -y

# Install Apache HTTP Server
yum install -y httpd

# Ensure correct ownership and permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# Get instance metadata with IMDSv2 token for security
TOKEN=$$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" 2>/dev/null)
if [ -n "$$TOKEN" ]; then
    INSTANCE_ID=$$(curl -H "X-aws-ec2-metadata-token: $$TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id 2>/dev/null || echo "unknown")
    AZ=$$(curl -H "X-aws-ec2-metadata-token: $$TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone 2>/dev/null || echo "unknown")
else
    INSTANCE_ID="unknown"
    AZ="unknown"
fi

TIMESTAMP=$$(date)

# Create a simple, reliable index page
cat > /var/www/html/index.html <<EOT
<!DOCTYPE html>
<html>
<head>
    <title>3-Tier Architecture Web Server</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 800px; margin: 0 auto; }
        .status { background-color: #d4edda; padding: 10px; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎉 3-Tier Architecture Web Server</h1>
        <div class="status">
            <h2>✅ Server Status: Online</h2>
            <p><strong>Instance ID:</strong> $${INSTANCE_ID}</p>
            <p><strong>Availability Zone:</strong> $${AZ}</p>
            <p><strong>Project:</strong> High Availability Web Application on AWS</p>
            <p><strong>Timestamp:</strong> $${TIMESTAMP}</p>
        </div>
        <p>This web server is running in the presentation tier of a 3-tier architecture.</p>
        <p>The load balancer is successfully routing traffic to this instance!</p>
    </div>
</body>
</html>
EOT

# Create health check endpoint
echo "OK" > /var/www/html/health

# Create a simple test page
echo "<h1>Health Check: OK</h1>" > /var/www/html/test.html

# Configure Apache
cat <<EOT > /etc/httpd/conf.d/allow-all.conf
<Directory "/var/www/html">
    AllowOverride None
    Require all granted
</Directory>
EOT

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Wait for Apache to fully start
sleep 10

# Test Apache locally
curl -s http://localhost/ > /tmp/apache-test.log 2>&1

# Verify Apache is running and log status
systemctl status httpd --no-pager -l

echo "User data script completed successfully!"
EOF
)



  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "web-server-instance"
    }
  }
}


# Create Auto Scaling Group
resource "aws_autoscaling_group" "web_asg" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.private_web_subnet_1.id, aws_subnet.private_web_subnet_2.id]

  target_group_arns    = [aws_lb_target_group.web_tg.arn]

  launch_template {
    id      = aws_launch_template.web_server_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "web-server-asg"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}