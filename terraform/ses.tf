# ---------------------------------------------------------------------------------------------------------------------
# Amazon SES Configuration
# ---------------------------------------------------------------------------------------------------------------------
# SES Email Identity (送信元メールアドレスの検証)
resource "aws_ses_email_identity" "from_email" {
  email = var.ses_from_email
}

# SES Domain Identity (オプション - ドメイン全体の検証)
resource "aws_ses_domain_identity" "domain" {
  count  = var.create_ses_domain ? 1 : 0
  domain = var.ses_domain
}

# SES DKIM設定 (オプション)
resource "aws_ses_domain_dkim" "domain_dkim" {
  count  = var.create_ses_domain ? 1 : 0
  domain = aws_ses_domain_identity.domain[0].domain
}

# SES送信ポリシー
resource "aws_ses_identity_policy" "ses_policy" {
  identity = aws_ses_email_identity.from_email.arn
  name     = "ses-${var.app_name}-policy"
  policy   = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = "ses:SendEmail"
        Resource  = aws_ses_email_identity.from_email.arn
        Principal = {
          AWS = var.ec2_role_arn != "" ? var.ec2_role_arn : data.aws_caller_identity.current.arn
        }
      }
    ]
  })
}

# 現在のAWSアカウントIDを取得
data "aws_caller_identity" "current" {}
