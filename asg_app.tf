# create ASG for app servers
# create launch template for app servers

resource "aws_launch_template" "app_server_lt" {
  name_prefix   = "${var.project_name}-app-server-lt-"
  image_id      = "ami-0ea3405d2d2522162" # Amazon Linux 2023 AMI for eu-west-1
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.app_sg.id]
  }

user_data = base64encode(<<-EOF
#!/bin/bash

# Log all commands and errors
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "Starting app server user data script..."

# Update system packages
yum update -y

# Install Python3 (should already be available in Amazon Linux 2023)
yum install -y python3

# Create app directory
mkdir -p /opt/app
cd /opt/app

# Create a simple Python app that responds on port 8080
cat > /opt/app/app.py <<EOT
#!/usr/bin/env python3

import http.server
import socketserver
import json
from datetime import datetime

PORT = 8080

class MyHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            
            response = {
                "message": "3-Tier Architecture - Application Server",
                "status": "healthy",
                "timestamp": datetime.now().isoformat(),
                "tier": "application",
                "port": PORT
            }
            
            self.wfile.write(json.dumps(response).encode())
        elif self.path == '/health':
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            self.wfile.write(b'OK')
        else:
            super().do_GET()

with socketserver.TCPServer(("", PORT), MyHTTPRequestHandler) as httpd:
    print(f"App server running on port {PORT}")
    httpd.serve_forever()
EOT

# Make the script executable
chmod +x /opt/app/app.py

# Start the Python app server as a background service
cd /opt/app
nohup python3 app.py > /var/log/app-server.log 2>&1 &

# Wait for the server to start
sleep 5

# Test the server locally
curl -s http://localhost:8080/health > /tmp/app-test.log 2>&1

echo "App server user data script completed successfully!"
EOF
)


  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "app-server-instance"
    }
  }
}

# Create Auto Scaling Group for app servers
resource "aws_autoscaling_group" "app_asg" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.private_app_subnet_1.id, aws_subnet.private_app_subnet_2.id]

  target_group_arns    = [aws_lb_target_group.app_tg.arn]

  launch_template {
    id      = aws_launch_template.app_server_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "app-server-asg"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}