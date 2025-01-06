provider "aws" {
  region = var.aws_region
}

locals {
  tags = {
    TaskName = var.task_name
    Terraform = "true"
  }
}

# Create AWS IAM Role
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = local.tags
}

# Create AWS IAM Role policy
resource "aws_iam_role_policy" "ec2_policy" {
  name   = "ec2_policy"
  role   = aws_iam_role.ec2_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath",
          "ssm:StartSession",
          "ssm:DescribeSessions",
          "ssm:ResumeSession",
          "ssm:TerminateSession",
          "ssm:GetConnectionStatus",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ],
        Resource = "*"
      }
    ]
  })
}

# Create AWS IAM Instance profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
  tags = local.tags
}

# Get your current public IP address
data "http" "myip" {
  url = "https://checkip.amazonaws.com/"
}

# IP error handling
resource "null_resource" "wait_for_ip" {
  provisioner "local-exec" {
    command = "sleep 5"
  }

  depends_on = [data.http.myip]
}

module "vpc" {
  source    = "./modules/vpc"
  task_name = var.task_name
}

module "security_group" {
  source          = "./modules/security_group"
  task_name       = var.task_name
  current_ip_cidr = "${chomp(data.http.myip.response_body)}/32"
  vpc_id          = module.vpc.vpc_id
}

module "rds" {
  source            = "./modules/rds"
  task_name         = var.task_name
  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  security_group_id = module.security_group.security_group_id
}

module "ec2" {
  source                 = "./modules/ec2"
  task_name              = var.task_name
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_id                 = module.vpc.vpc_id
  public_subnet_id       = module.vpc.public_subnets
  security_group_id      = module.security_group.rds_security_group_id
  ec2_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  rds_endpoint           = module.rds.endpoint
  rds_db_name            = module.rds.database_name
  rds_admin_username     = module.rds.admin_username
  rds_admin_password_ssm = module.rds.admin_password_ssm
}
