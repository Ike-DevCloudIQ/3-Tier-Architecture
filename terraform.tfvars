# terraform.tfvars - Main configuration file for 3-Tier Architecture

# Project Configuration
project_name = "3-tier-ik"
region      = "eu-west-1"

# Networking Configuration
vpc_cidr                     = "10.0.0.0/16"
az1                         = "eu-west-1a"
az2                         = "eu-west-1b"

# Subnet CIDR Configuration
public_subnet_1_cidr        = "10.0.0.0/24"
public_subnet_2_cidr        = "10.0.1.0/24"
private_web_subnet_1_cidr   = "10.0.2.0/24"
private_web_subnet_2_cidr   = "10.0.3.0/24"
private_app_subnet_1_cidr   = "10.0.4.0/24"
private_app_subnet_2_cidr   = "10.0.5.0/24"
private_db_subnet_1_cidr    = "10.0.6.0/24"
private_db_subnet_2_cidr    = "10.0.7.0/24"

# EC2 Configuration
instance_type  = "t2.micro"
key_pair_name  = "3tier-keypair"  # Make sure this key pair exists in your AWS account

# Database Configuration
db_username = "admin"