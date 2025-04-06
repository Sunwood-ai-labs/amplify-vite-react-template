# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoints for Private Subnet Access
# ---------------------------------------------------------------------------------------------------------------------
# このファイルは、プライベートサブネットからAWSサービスへの接続に必要なVPCエンドポイントを定義します
# VPCやサブネットIDなどは、既存のものを使用することを前提としています

# VPCエンドポイント用のセキュリティグループ
resource "aws_security_group" "vpc_endpoints" {
  count       = var.create_vpc_endpoints && var.vpc_id != "" ? 1 : 0
  name        = "${var.app_name}-vpc-endpoints-sg"
  description = "Allow HTTPS traffic for VPC endpoints"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.app_name}-vpc-endpoints-sg"
    }
  )
}

# Cognito IDPエンドポイント
resource "aws_vpc_endpoint" "cognito_idp" {
  count               = var.create_vpc_endpoints && var.vpc_id != "" && length(var.private_subnet_ids) > 0 ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.cognito-idp"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints[0].id]

  tags = merge(
    var.tags,
    {
      Name = "${var.app_name}-cognito-idp-endpoint"
    }
  )
}

# SESエンドポイント
resource "aws_vpc_endpoint" "ses" {
  count               = var.create_vpc_endpoints && var.vpc_id != "" && length(var.private_subnet_ids) > 0 ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.email-smtp"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints[0].id]

  tags = merge(
    var.tags,
    {
      Name = "${var.app_name}-ses-endpoint"
    }
  )
}

# S3エンドポイント (Gateway型)
resource "aws_vpc_endpoint" "s3" {
  count               = var.create_vpc_endpoints && var.vpc_id != "" ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type   = "Gateway"
  route_table_ids     = []  # 実際のルートテーブルIDを指定する必要があります

  tags = merge(
    var.tags,
    {
      Name = "${var.app_name}-s3-endpoint"
    }
  )
}

# DynamoDBエンドポイント (Gateway型)
resource "aws_vpc_endpoint" "dynamodb" {
  count               = var.create_vpc_endpoints && var.vpc_id != "" ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.dynamodb"
  vpc_endpoint_type   = "Gateway"
  route_table_ids     = []  # 実際のルートテーブルIDを指定する必要があります

  tags = merge(
    var.tags,
    {
      Name = "${var.app_name}-dynamodb-endpoint"
    }
  )
}
