variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az1" {
  description = "The first availability zone"
  type        = string
  default     = "eu-west-1a"
}

variable "az2" {
  description = "The second availability zone"
  type        = string
  default     = "eu-west-1b"
}

variable "db_username" {
  description = "database user name"
  type        = string
  default     = "admin"
}

variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
  default     = "3-tier-ik"
}

variable "key_pair_name" {
  description = "Name of the AWS key pair for EC2 instances"
  type        = string
  default     = "3tier-keypair"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

# Subnet CIDR variables
variable "public_subnet_1_cidr" {
  description = "CIDR block for public subnet 1"
  type        = string
  default     = "10.0.0.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for public subnet 2"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_web_subnet_1_cidr" {
  description = "CIDR block for private web subnet 1"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_web_subnet_2_cidr" {
  description = "CIDR block for private web subnet 2"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_app_subnet_1_cidr" {
  description = "CIDR block for private app subnet 1"
  type        = string
  default     = "10.0.4.0/24"
}

variable "private_app_subnet_2_cidr" {
  description = "CIDR block for private app subnet 2"
  type        = string
  default     = "10.0.5.0/24"
}

variable "private_db_subnet_1_cidr" {
  description = "CIDR block for private db subnet 1"
  type        = string
  default     = "10.0.6.0/24"
}

variable "private_db_subnet_2_cidr" {
  description = "CIDR block for private db subnet 2"
  type        = string
  default     = "10.0.7.0/24"
}