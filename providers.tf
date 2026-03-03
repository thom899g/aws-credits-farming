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