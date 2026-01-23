# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket  = "3-tier-ik-bucket-tfstate"
    key     = "vpc-terraform-github-action.tfstate" 
    region  = "eu-west-1"
    encrypt = true
  }
}