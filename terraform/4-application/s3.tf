# ---------------------------------------------------------------------------------------------------------------------
# S3 Bucket for Application Deployment
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "app" {
  count  = var.create_s3_bucket ? 1 : 0
  bucket = var.s3_bucket_name != "" ? var.s3_bucket_name : "${var.app_name}-${data.aws_caller_identity.current.account_id}"

  tags = var.tags
}

# バケットのパブリックアクセスをブロック
resource "aws_s3_bucket_public_access_block" "app" {
  count  = var.create_s3_bucket ? 1 : 0
  bucket = aws_s3_bucket.app[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# バケットの暗号化を有効化
resource "aws_s3_bucket_server_side_encryption_configuration" "app" {
  count  = var.create_s3_bucket ? 1 : 0
  bucket = aws_s3_bucket.app[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# バケットのバージョニングを有効化
resource "aws_s3_bucket_versioning" "app" {
  count  = var.create_s3_bucket ? 1 : 0
  bucket = aws_s3_bucket.app[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

# CloudFrontからのアクセスを許可するバケットポリシー
resource "aws_s3_bucket_policy" "app" {
  count  = var.create_s3_bucket && var.create_cloudfront ? 1 : 0
  bucket = aws_s3_bucket.app[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.app[0].arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.app[0].arn
          }
        }
      }
    ]
  })

  depends_on = [aws_cloudfront_distribution.app]
}

# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = var.create_s3_bucket ? aws_s3_bucket.app[0].id : null
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = var.create_s3_bucket ? aws_s3_bucket.app[0].arn : null
}

# ---------------------------------------------------------------------------------------------------------------------
# Data Sources
# ---------------------------------------------------------------------------------------------------------------------
data "aws_caller_identity" "current" {}
