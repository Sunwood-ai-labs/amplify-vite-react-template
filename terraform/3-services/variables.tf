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
# Cognito Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "user_pool_name" {
  description = "The name of the Cognito User Pool"
  type        = string
  default     = "react-auth-user-pool"
}

variable "generate_client_secret" {
  description = "Whether to generate a client secret for the Cognito User Pool Client"
  type        = bool
  default     = false
}

variable "callback_urls" {
  description = "A list of allowed callback URLs for the Cognito User Pool Client"
  type        = list(string)
  default     = ["http://localhost:3000/"]
}

variable "logout_urls" {
  description = "A list of allowed logout URLs for the Cognito User Pool Client"
  type        = list(string)
  default     = ["http://localhost:3000/"]
}

variable "create_cognito_domain" {
  description = "Whether to create a Cognito domain"
  type        = bool
  default     = true
}

variable "cognito_domain_prefix" {
  description = "The prefix for the Cognito domain"
  type        = string
  default     = "react-auth-app"
}

# ---------------------------------------------------------------------------------------------------------------------
# SES Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "ses_from_email" {
  description = "The email address to use as the from address for SES"
  type        = string
}

variable "create_ses_domain" {
  description = "Whether to create a SES domain identity"
  type        = bool
  default     = false
}

variable "ses_domain" {
  description = "The domain to use for SES"
  type        = string
  default     = "example.com"
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
