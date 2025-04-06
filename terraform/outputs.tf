# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "cognito_user_pool_id" {
  description = "The ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.main.id
}

output "cognito_client_id" {
  description = "The ID of the Cognito User Pool Client"
  value       = aws_cognito_user_pool_client.client.id
}

output "cognito_domain" {
  description = "The Cognito Domain"
  value       = var.create_cognito_domain ? "${var.cognito_domain_prefix}.auth.${var.aws_region}.amazoncognito.com" : null
}

output "ses_email_identity_arn" {
  description = "The ARN of the SES Email Identity"
  value       = aws_ses_email_identity.from_email.arn
}

output "vpc_endpoint_cognito_dns" {
  description = "The DNS entries for the Cognito VPC endpoint"
  value       = var.create_vpc_endpoints ? aws_vpc_endpoint.cognito_idp[0].dns_entry : null
}

output "vpc_endpoint_ses_dns" {
  description = "The DNS entries for the SES VPC endpoint"
  value       = var.create_vpc_endpoints ? aws_vpc_endpoint.ses[0].dns_entry : null
}
