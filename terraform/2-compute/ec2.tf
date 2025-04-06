# ---------------------------------------------------------------------------------------------------------------------
# EC2 Instance Security Group
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "ec2" {
  name        = "${var.app_name}-ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = local.vpc_id

  # HTTPSアクセス用（必要に応じて変更してください）
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPアクセス用（開発環境用、本番環境では適切に制限してください）
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSHアクセス用（本番環境では特定のIPのみに制限することを推奨）
  ingress {
    from_port   = 22
    to_port     = 22
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
      Name = "${var.app_name}-ec2-sg"
    }
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# EC2 Instance (必要に応じてカスタマイズしてください)
# ---------------------------------------------------------------------------------------------------------------------
# resource "aws_instance" "app" {
#   ami           = "ami-xxxxxxxxxxxxx"  # 適切なAMIを指定してください
#   instance_type = "t3.micro"
#   subnet_id     = local.private_subnet_ids[0]
# 
#   vpc_security_group_ids = [aws_security_group.ec2.id]
#   iam_instance_profile   = var.ec2_role_name != "" ? var.ec2_role_name : null
# 
#   root_block_device {
#     volume_size = 20
#     volume_type = "gp3"
#   }
# 
#   tags = merge(
#     var.tags,
#     {
#       Name = "${var.app_name}-instance"
#     }
#   )
# }

# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "ec2_security_group_id" {
  description = "The ID of the EC2 security group"
  value       = aws_security_group.ec2.id
}
