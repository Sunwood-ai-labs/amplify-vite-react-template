# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint Outputs
# ---------------------------------------------------------------------------------------------------------------------

output "vpc_endpoint_sg_id" {
  description = "The ID of the VPC endpoints security group"
  value       = try(aws_security_group.vpc_endpoints[0].id, "")
}

output "cognito_vpc_endpoint_id" {
  description = "The ID of the Cognito VPC endpoint"
  value       = try(aws_vpc_endpoint.cognito_idp[0].id, "")
}

output "ses_vpc_endpoint_id" {
  description = "The ID of the SES VPC endpoint"
  value       = try(aws_vpc_endpoint.ses[0].id, "")
}

output "s3_vpc_endpoint_id" {
  description = "The ID of the S3 VPC endpoint"
  value       = try(aws_vpc_endpoint.s3[0].id, "")
}

output "dynamodb_vpc_endpoint_id" {
  description = "The ID of the DynamoDB VPC endpoint"
  value       = try(aws_vpc_endpoint.dynamodb[0].id, "")
}

# ---------------------------------------------------------------------------------------------------------------------
# Network Information Outputs
# ---------------------------------------------------------------------------------------------------------------------

output "vpc_id" {
  description = "The ID of the VPC"
  value       = var.vpc_id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = var.private_subnet_ids
}
