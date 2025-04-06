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
# S3 Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "create_s3_bucket" {
  description = "Whether to create an S3 bucket for application deployment"
  type        = bool
  default     = false
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket for application deployment"
  type        = string
  default     = ""
}

# ---------------------------------------------------------------------------------------------------------------------
# CloudFront Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "create_cloudfront" {
  description = "Whether to create a CloudFront distribution"
  type        = bool
  default     = false
}

variable "cloudfront_price_class" {
  description = "The price class for the CloudFront distribution"
  type        = string
  default     = "PriceClass_100" # Use only North America and Europe
}

variable "cloudfront_allowed_methods" {
  description = "List of allowed methods for CloudFront"
  type        = list(string)
  default     = ["GET", "HEAD", "OPTIONS"]
}

variable "cloudfront_cached_methods" {
  description = "List of cached methods for CloudFront"
  type        = list(string)
  default     = ["GET", "HEAD"]
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
