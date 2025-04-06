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
        Resource = aws_cognito_user_pool.main.arn
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
}

# EC2ロールにポリシーをアタッチ (既存のIAMロールがある場合)
resource "aws_iam_role_policy_attachment" "ec2_cognito_ses_attachment" {
  count      = var.ec2_role_name != "" ? 1 : 0
  role       = var.ec2_role_name
  policy_arn = aws_iam_policy.ec2_cognito_ses_policy.arn
}
