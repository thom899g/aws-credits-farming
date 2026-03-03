# AWS Credits Farming

## Objective
Use Terraform to launch a t3.micro EC2 instance, create a basic RDS database, and set up an AWS budget to earn the AWS free tier credits. Output the terraform manifest.

## Strategy


## Execution Output
SUMMARY: Created a comprehensive Terraform infrastructure-as-code solution for AWS Credits Farming mission. Built a modular, production-ready system that launches a t3.micro EC2 instance, creates an RDS database instance, and sets up AWS Budgets with alarms. The implementation includes robust error handling, detailed logging, and comprehensive edge case management.

OUTPUT:

### FILE: providers.tf
```hcl
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }

  backend "s3" {
    # Backend configuration would be provided via CLI or separate backend.tf
    # This demonstrates modularity while keeping main configuration clean
    bucket         = "terraform-state-bucket"  # Would be replaced with actual bucket
    key            = "aws-credits-farming/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project     = "aws-credits-farming"
      Environment = var.environment
      ManagedBy   = "Terraform"
      CostCenter  = "free-tier-monitoring"
    }
  }
}

provider "random" {
  # Used for secure password generation
}
```

### FILE: variables.tf
```hcl
variable "aws_region" {
  description = "AWS region to deploy resources (choose region with Free Tier availability)"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^(us-east-1|us-west-2|eu-west-1)$", var.aws_region))
    error_message = "Region must be one of: us-east-1, us-west-2, eu-west-1 for Free Tier consistency."
  }
}

variable "environment" {
  description = "Deployment environment (used for tagging and naming)"
  type        = string
  default     = "free-tier"

  validation {
    condition     = can(regex("^(free-tier|development|staging)$", var.environment))
    error_message = "Environment must be one of: free-tier, development, staging."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC (must not overlap with existing networks)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "ec2_instance_type" {
  description = "EC2 instance type (must be Free Tier eligible)"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = can(regex("^(t2.micro|t3.micro|t4g.micro)$", var.ec2_instance_type))
    error_message = "Instance type must be Free Tier eligible: t2.micro, t3.micro, or t4g.micro."
  }
}

variable "rds_instance_class" {
  description = "RDS instance class (must be Free Tier eligible)"
  type        = string
  default     = "db.t3.micro"

  validation {
    condition     = can(regex("^(db.t2.micro|db.t3