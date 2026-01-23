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

yum install -y httpd

# Ensure correct ownership and permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# Create index page
echo "Project: How to deploy a High Availability web application on AWS!" > /var/www/html/index.html

# Explicitly allow access (Apache hardening fix)
cat <<EOT > /etc/httpd/conf.d/allow-all.conf
<Directory "/var/www/html">
    AllowOverride None
    Require all granted
</Directory>
EOT

systemctl start httpd
systemctl enable httpd
systemctl restart httpd
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