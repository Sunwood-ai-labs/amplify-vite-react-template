# ---------------------------------------------------------------------------------------------------------------------
# AWS Provider Configuration
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    # バックエンドの設定は terraform init 時に-backendフラグで渡すことをおすすめします
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.tags
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Remote State Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "compute_remote_state_bucket" {
  description = "The name of the S3 bucket containing the compute remote state"
  type        = string
}

variable "compute_remote_state_key" {
  description = "The key of the compute remote state in the S3 bucket"
  type        = string
  default     = "compute/terraform.tfstate"
}

# ---------------------------------------------------------------------------------------------------------------------
# Data Sources
# ---------------------------------------------------------------------------------------------------------------------
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.network_remote_state_bucket
    key    = var.network_remote_state_key
    region = var.aws_region
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Local Values
# ---------------------------------------------------------------------------------------------------------------------
locals {
  vpc_id             = data.terraform_remote_state.network.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids
}
