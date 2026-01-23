# 3-Tier Architecture on AWS with Terraform

![Project Image](https://github.com/efritznel/3-tier-architecture/blob/main/3tier%20diagram.gif)

This project deploys a highly available 3-tier web application architecture on AWS using Terraform.

## 🏗️ Architecture Overview

The infrastructure includes:

- **Presentation Tier**: External Application Load Balancer + Web Servers in Private Subnets
- **Application Tier**: Internal Application Load Balancer + App Servers in Private Subnets  
- **Data Tier**: RDS MySQL Database with Multi-AZ deployment in Private Subnets

## 📁 File Structure

```
├── backend.tf              # Terraform backend configuration (S3)
├── provider.tf              # AWS provider configuration
├── variables.tf             # Variable definitions
├── vpc.tf                   # VPC, subnets, routing, and NAT gateway
├── security.tf              # Security groups for all tiers
├── external_alb.tf          # External Application Load Balancer
├── internal_alb.tf          # Internal Application Load Balancer
├── asg_web.tf              # Auto Scaling Group for web servers
├── asg_app.tf              # Auto Scaling Group for app servers
├── rds.tf                  # RDS MySQL database configuration
├── outputs.tf              # Output values
├── terraform.tfvars        # Default variable values
├── development.tfvars      # Development environment variables
├── production.tfvars       # Production environment variables
└── README.md               # This file
```

## 🚀 Prerequisites

1. **AWS Account** with appropriate permissions
2. **Terraform** installed (>= 1.0)
3. **AWS CLI** configured with credentials
4. **Key Pair** created in your target AWS region

## 📋 Pre-Deployment Steps

### 1. Create AWS Key Pair
```bash
# Create key pair for SSH access (replace with your key name)
aws ec2 create-key-pair --key-name 3tier-keypair --query 'KeyMaterial' --output text > 3tier-keypair.pem
chmod 400 3tier-keypair.pem
```

### 2. S3 Backend Bucket
The S3 bucket has been created with:
- **Bucket Name**: `3-tier-ik-bucket-tfstate`
- **Region**: `eu-west-1`
- **Versioning**: Enabled
- **Encryption**: AES-256

## 🎯 Deployment Instructions

### 1. Initialize Terraform
```bash
terraform init
```

### 2. Plan Deployment
```bash
# Using default terraform.tfvars
terraform plan

# Or using specific environment
terraform plan -var-file="development.tfvars"
terraform plan -var-file="production.tfvars"
```

### 3. Deploy Infrastructure
```bash
# Deploy with default values
terraform apply

# Or deploy specific environment
terraform apply -var-file="development.tfvars"
terraform apply -var-file="production.tfvars"
```

### 4. Access Your Application
After deployment:
```bash
# Get the ALB DNS name
terraform output external_alb_dns_name
```

## 🔧 Infrastructure Components

### Step 1: Networking
- VPC with configurable CIDR
- 2 Public subnets across 2 AZs
- 2 Private subnets for web servers
- 2 Private subnets for app servers  
- 2 Private subnets for database servers
- Internet Gateway for public access
- NAT Gateway for private subnet internet access
- Route tables with proper associations

### Step 2: Security Groups
- **External ALB**: HTTP (80) from internet
- **Web Servers**: HTTP (80) from ALB only
- **Internal ALB**: HTTP (80) from web servers
- **App Servers**: HTTP (8080) from internal ALB
- **Database**: MySQL (3306) from app servers only

### Step 3: Auto Scaling Groups
- **Web Tier**: Launch template + ASG (1-4 instances)
- **App Tier**: Launch template + ASG (1-4 instances)

### Step 4: Load Balancers
- **External ALB**: Routes traffic to web servers
- **Internal ALB**: Routes traffic between web and app tiers

### Step 5: Database
- **RDS MySQL 5.7** with Multi-AZ deployment
- **Secrets Manager** for password management
- **DB Subnet Group** spanning private subnets

## 🧹 Cleanup

```bash
terraform destroy
```

---

**Important**: Update `key_pair_name` in `terraform.tfvars` to match your AWS key pair!
