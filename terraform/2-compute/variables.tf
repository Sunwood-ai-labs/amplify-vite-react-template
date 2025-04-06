# ---------------------------------------------------------------------------------------------------------------------
# General Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "ap-northeast-1"
}

variable "app_name" {
  description = "The name of the application"
  type        = string
  default     = "react-auth-app"
}

# ---------------------------------------------------------------------------------------------------------------------
# IAM Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "ec2_role_name" {
  description = "The name of the IAM role for the EC2 instance (optional)"
  type        = string
  default     = ""
}

# ---------------------------------------------------------------------------------------------------------------------
# Tags
# ---------------------------------------------------------------------------------------------------------------------
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    Terraform   = "true"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Remote State Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "network_remote_state_bucket" {
  description = "The name of the S3 bucket containing the network remote state"
  type        = string
}

variable "network_remote_state_key" {
  description = "The key of the network remote state in the S3 bucket"
  type        = string
  default     = "network/terraform.tfstate"
}

variable "services_remote_state_bucket" {
  description = "The name of the S3 bucket containing the services remote state"
  type        = string
}

variable "services_remote_state_key" {
  description = "The key of the services remote state in the S3 bucket"
  type        = string
  default     = "services/terraform.tfstate"
}
