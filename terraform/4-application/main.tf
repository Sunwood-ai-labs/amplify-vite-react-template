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
# Data Sources for Remote State
# ---------------------------------------------------------------------------------------------------------------------
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.network_remote_state_bucket
    key    = var.network_remote_state_key
    region = var.aws_region
  }
}

data "terraform_remote_state" "services" {
  backend = "s3"
  config = {
    bucket = var.services_remote_state_bucket
    key    = var.services_remote_state_key
    region = var.aws_region
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Local Values
# ---------------------------------------------------------------------------------------------------------------------
locals {
  vpc_id             = data.terraform_remote_state.network.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids
  cognito_user_pool_id = data.terraform_remote_state.services.outputs.cognito_user_pool_id
  cognito_app_client_id = data.terraform_remote_state.services.outputs.cognito_app_client_id
}
