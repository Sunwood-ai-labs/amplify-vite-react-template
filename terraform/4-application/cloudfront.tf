# ---------------------------------------------------------------------------------------------------------------------
# CloudFront Distribution
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_cloudfront_origin_access_control" "app" {
  count                             = var.create_cloudfront && var.create_s3_bucket ? 1 : 0
  name                              = "${var.app_name}-oac"
  description                       = "Origin Access Control for ${var.app_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "app" {
  count = var.create_cloudfront ? 1 : 0

  enabled             = true
  is_ipv6_enabled    = true
  comment            = "${var.app_name} distribution"
  default_root_object = "index.html"
  price_class        = var.cloudfront_price_class

  # S3オリジンの設定
  origin {
    domain_name              = var.create_s3_bucket ? aws_s3_bucket.app[0].bucket_regional_domain_name : ""
    origin_access_control_id = var.create_s3_bucket ? aws_cloudfront_origin_access_control.app[0].id : null
    origin_id               = var.create_s3_bucket ? "S3-${aws_s3_bucket.app[0].id}" : "custom-origin"
  }

  # デフォルトのキャッシュ動作
  default_cache_behavior {
    allowed_methods  = var.cloudfront_allowed_methods
    cached_methods   = var.cloudfront_cached_methods
    target_origin_id = var.create_s3_bucket ? "S3-${aws_s3_bucket.app[0].id}" : "custom-origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # 地理的制限（必要に応じて設定）
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # SSL証明書の設定
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # SPAのためのエラーページ設定
  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  tags = var.tags
}

# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution"
  value       = var.create_cloudfront ? aws_cloudfront_distribution.app[0].id : null
}

output "cloudfront_distribution_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = var.create_cloudfront ? aws_cloudfront_distribution.app[0].domain_name : null
}
