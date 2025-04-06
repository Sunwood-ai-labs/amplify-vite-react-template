# ---------------------------------------------------------------------------------------------------------------------
# Cognito User Pool
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_cognito_user_pool" "main" {
  name = var.user_pool_name

  username_configuration {
    case_sensitive = false
  }

  username_attributes = ["email"]

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "アカウント確認コード"
    email_message        = "あなたの確認コードは {####} です。"
  }

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 7
      max_length = 320
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "name"
    required                 = false

    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  # SESを使用してメール送信する場合の設定
  email_configuration {
    email_sending_account = "DEVELOPER"
    source_arn            = aws_ses_email_identity.from_email.arn
    from_email_address    = var.ses_from_email
  }

  tags = var.tags
}

# Cognito User Pool Client
resource "aws_cognito_user_pool_client" "client" {
  name                                 = "${var.user_pool_name}-client"
  user_pool_id                         = aws_cognito_user_pool.main.id
  generate_secret                      = var.generate_client_secret
  refresh_token_validity               = 30
  prevent_user_existence_errors        = "ENABLED"
  callback_urls                        = var.callback_urls
  logout_urls                          = var.logout_urls
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]
  supported_identity_providers         = ["COGNITO"]
}

# オプション: Cognitoドメイン設定
resource "aws_cognito_user_pool_domain" "main" {
  count        = var.create_cognito_domain ? 1 : 0
  domain       = var.cognito_domain_prefix
  user_pool_id = aws_cognito_user_pool.main.id
}

# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "cognito_user_pool_id" {
  description = "The ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.main.id
}

output "cognito_user_pool_arn" {
  description = "The ARN of the Cognito User Pool"
  value       = aws_cognito_user_pool.main.arn
}

output "cognito_app_client_id" {
  description = "The ID of the Cognito User Pool Client"
  value       = aws_cognito_user_pool_client.client.id
}

output "cognito_domain" {
  description = "The Cognito domain name"
  value       = var.create_cognito_domain ? aws_cognito_user_pool_domain.main[0].domain : null
}
