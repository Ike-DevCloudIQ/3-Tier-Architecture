# 🔐 Security Setup Instructions

## Required Files (Not in Git)

Before deploying this Terraform infrastructure, you need to create these files locally:

### 1. Environment Variable Files

Copy the template files and add your actual values:

```bash
# For development environment
cp development.tfvars.template development.tfvars
# Edit development.tfvars and replace YOUR_KEY_PAIR_NAME_HERE with your actual key pair name

# For production environment  
cp production.tfvars.template production.tfvars
# Edit production.tfvars and replace YOUR_KEY_PAIR_NAME_HERE with your actual key pair name
```

### 2. SSH Key Pair

Create an AWS key pair and download the .pem file:
1. Go to AWS Console → EC2 → Key Pairs
2. Create a new key pair (e.g., "3tier-keypair")
3. Download the .pem file to this directory
4. Set correct permissions: `chmod 400 your-keypair.pem`

### 3. AWS Credentials

Ensure your AWS credentials are configured:
```bash
aws configure
# or use environment variables:
# export AWS_ACCESS_KEY_ID=your_access_key
# export AWS_SECRET_ACCESS_KEY=your_secret_key
# export AWS_SESSION_TOKEN=your_session_token (if using temporary credentials)
```

## Files Ignored by Git

The following sensitive files are automatically ignored:
- `*.tfvars` (environment configurations)
- `*.tfstate*` (Terraform state files)
- `*.pem` (SSH keys)
- `*.key` (any key files)
- `.env*` (environment files)
- `secrets/` (secrets directory)

## Security Best Practices

1. ✅ Never commit sensitive files to version control
2. ✅ Use separate .tfvars files for different environments
3. ✅ Keep SSH keys secure with proper permissions (400)
4. ✅ Use AWS IAM roles instead of hardcoded credentials when possible
5. ✅ Regularly rotate access keys and passwords
6. ✅ Use AWS Secrets Manager for database passwords (already implemented)

## Deployment Commands

```bash
# Development
terraform plan -var-file="development.tfvars"
terraform apply -var-file="development.tfvars"

# Production  
terraform plan -var-file="production.tfvars"
terraform apply -var-file="production.tfvars"
```