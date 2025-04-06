# ---------------------------------------------------------------------------------------------------------------------
# Data Sources for Remote State
# ---------------------------------------------------------------------------------------------------------------------
data "terraform_remote_state" "services" {
  backend = "s3"
  config = {
    bucket = var.services_remote_state_bucket
    key    = var.services_remote_state_key
    region = var.aws_region
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# IAM Policy for EC2 to use Cognito and SES
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_policy" "ec2_cognito_ses_policy" {
  name        = "${var.app_name}-cognito-ses-policy"
  description = "Allow EC2 to interact with Cognito and SES"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "cognito-idp:ListUsers",
          "cognito-idp:AdminCreateUser",
          "cognito-idp:AdminGetUser",
          "cognito-idp:AdminUpdateUserAttributes",
          "cognito-idp:AdminDeleteUser"
        ]
        Resource = data.terraform_remote_state.services.outputs.cognito_user_pool_arn
      },
      {
        Effect   = "Allow"
        Action   = [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

# EC2ロールにポリシーをアタッチ (既存のIAMロールがある場合)
resource "aws_iam_role_policy_attachment" "ec2_cognito_ses_attachment" {
  count      = var.ec2_role_name != "" ? 1 : 0
  role       = var.ec2_role_name
  policy_arn = aws_iam_policy.ec2_cognito_ses_policy.arn
}

# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "ec2_cognito_ses_policy_arn" {
  description = "The ARN of the EC2 Cognito SES policy"
  value       = aws_iam_policy.ec2_cognito_ses_policy.arn
}
