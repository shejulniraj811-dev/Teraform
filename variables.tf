###############################################################################
# variables.tf
#
# Centralized input variables for this Terraform configuration.
# Reference any of these from other .tf files using: var.<name>
#
# Conventions follow the Terraform AWS Provider registry docs:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs
###############################################################################

# -----------------------------------------------------------------------------
# Provider / Region
# -----------------------------------------------------------------------------
variable "aws_region" {
  description = "AWS region to deploy resources into."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "aws_region must be a valid region string, e.g. us-east-1."
  }
}

variable "aws_profile" {
  description = "Named AWS CLI/credentials profile to use. Leave empty to use the default credential chain (env vars, instance role, etc.)."
  type        = string
  default     = ""
}

# -----------------------------------------------------------------------------
# EC2 Instance
# -----------------------------------------------------------------------------
variable "ami_id" {
  description = "AMI ID used to launch the EC2 instance. Must exist in aws_region."
  type        = string
  default     = "ami-091138d0f0d41ff90"

  validation {
    condition     = can(regex("^ami-[0-9a-f]{8,17}$", var.ami_id))
    error_message = "ami_id must be a valid AMI identifier, e.g. ami-0123456789abcdef0."
  }
}

variable "instance_type" {
  description = "EC2 instance type (size) to launch."
  type        = string
  default     = "t3.micro"
}

variable "instance_count" {
  description = "Number of identical EC2 instances to create."
  type        = number
  default     = 1

  validation {
    condition     = var.instance_count >= 1
    error_message = "instance_count must be at least 1."
  }
}

variable "key_name" {
  description = "Name of the existing EC2 key pair to enable SSH access. Leave empty for no key pair."
  type        = string
  default     = "aws_key.pem"
}

# -----------------------------------------------------------------------------
# Networking
# -----------------------------------------------------------------------------
variable "subnet_id" {
  description = "ID of the subnet to launch the instance into. Leave empty to use the default subnet of the default VPC."
  type        = string
  default     = ""
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs to associate with the instance."
  type        = list(string)
  default     = ["sg-0981f1bdf4af6c11d"]
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instance."
  type        = bool
  default     = true
}

# -----------------------------------------------------------------------------
# Storage (root EBS volume)
# -----------------------------------------------------------------------------
variable "root_volume_size" {
  description = "Size of the root EBS volume in GiB."
  type        = number
  default     = 8

  validation {
    condition     = var.root_volume_size >= 8
    error_message = "root_volume_size must be at least 8 GiB."
  }
}

variable "root_volume_type" {
  description = "Type of the root EBS volume (e.g. gp2, gp3, io1, io2)."
  type        = string
  default     = "gp3"
}

variable "root_volume_encrypted" {
  description = "Whether the root EBS volume should be encrypted."
  type        = bool
  default     = true
}

# -----------------------------------------------------------------------------
# Monitoring
# -----------------------------------------------------------------------------
variable "enable_detailed_monitoring" {
  description = "Enable detailed (1-minute) CloudWatch monitoring for the instance."
  type        = bool
  default     = false
}

# -----------------------------------------------------------------------------
# Naming & Tagging
# -----------------------------------------------------------------------------
variable "instance_name" {
  description = "Value for the Name tag applied to the EC2 instance."
  type        = string
  default     = "Niraj"
}

variable "environment" {
  description = "Deployment environment (used for the env tag)."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "tags" {
  description = "Additional tags to merge onto all taggable resources."
  type        = map(string)
  default     = {}
}
