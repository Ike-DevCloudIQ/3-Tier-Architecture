# Output values for important resources

# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.my_vpc.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.my_vpc.cidr_block
}

# Subnet Outputs
output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

output "private_web_subnet_ids" {
  description = "IDs of private web subnets"
  value       = [aws_subnet.private_web_subnet_1.id, aws_subnet.private_web_subnet_2.id]
}

output "private_app_subnet_ids" {
  description = "IDs of private app subnets"
  value       = [aws_subnet.private_app_subnet_1.id, aws_subnet.private_app_subnet_2.id]
}

output "private_db_subnet_ids" {
  description = "IDs of private database subnets"
  value       = [aws_subnet.private_db_subnet_1.id, aws_subnet.private_db_subnet_2.id]
}

# Load Balancer Outputs
output "external_alb_dns_name" {
  description = "DNS name of the external Application Load Balancer"
  value       = aws_lb.external_alb.dns_name
}

output "external_alb_arn" {
  description = "ARN of the external Application Load Balancer"
  value       = aws_lb.external_alb.arn
}

output "internal_alb_dns_name" {
  description = "DNS name of the internal Application Load Balancer"
  value       = aws_lb.internal_alb.dns_name
}

# RDS Outputs
output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.default.endpoint
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.default.port
}

# Security Group Outputs
output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb_sg.id
}

output "web_security_group_id" {
  description = "ID of the web tier security group"
  value       = aws_security_group.web_sg.id
}

output "app_security_group_id" {
  description = "ID of the app tier security group"
  value       = aws_security_group.app_sg.id
}

output "db_security_group_id" {
  description = "ID of the database security group"
  value       = aws_security_group.db_sg.id
}

# Auto Scaling Group Outputs
output "web_asg_name" {
  description = "Name of the web tier Auto Scaling Group"
  value       = aws_autoscaling_group.web_asg.name
}

output "app_asg_name" {
  description = "Name of the app tier Auto Scaling Group"
  value       = aws_autoscaling_group.app_asg.name
}

# NAT Gateway Output
output "nat_gateway_ip" {
  description = "Elastic IP of the NAT Gateway"
  value       = aws_eip.nat_eip.public_ip
}

# Secrets Manager Output
output "db_password_secret_arn" {
  description = "ARN of the database password secret"
  value       = aws_secretsmanager_secret.db_password.arn
}