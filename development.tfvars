# development.tfvars - Development environment configuration

# Project Configuration
project_name = "3-tier-ik-dev"
region      = "eu-west-1"

# Networking Configuration - Smaller CIDR for dev
vpc_cidr                     = "10.1.0.0/16"
az1                         = "eu-west-1a"
az2                         = "eu-west-1b"

# Subnet CIDR Configuration
public_subnet_1_cidr        = "10.1.0.0/24"
public_subnet_2_cidr        = "10.1.1.0/24"
private_web_subnet_1_cidr   = "10.1.2.0/24"
private_web_subnet_2_cidr   = "10.1.3.0/24"
private_app_subnet_1_cidr   = "10.1.4.0/24"
private_app_subnet_2_cidr   = "10.1.5.0/24"
private_db_subnet_1_cidr    = "10.1.6.0/24"
private_db_subnet_2_cidr    = "10.1.7.0/24"

# EC2 Configuration - Dev uses micro instances
instance_type  = "t2.micro"
key_pair_name  = "3tier-dev-keypair"

# Database Configuration
db_username = "admin"