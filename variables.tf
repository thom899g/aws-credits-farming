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