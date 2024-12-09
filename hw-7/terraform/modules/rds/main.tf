locals {
  tags = {
    TaskName = var.task_name
    Terraform = "true"
  }
}

# Generate a random password for the RDS admin user
resource "random_password" "rds_password" {
  length  = 16
  special = true
}

# Create an RDS Subnet Group using private subnets
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.task_name}-db-subnet-group"
  subnet_ids = var.private_subnets
  tags = local.tags
}

# Store database name in SSM Parameter Store
resource "aws_ssm_parameter" "db_name" {
  name  = "/${var.task_name}/db_name"
  type  = "String"
  value = "wordpress_db"
  tags = local.tags
}

# Store database username in SSM Parameter Store
resource "aws_ssm_parameter" "db_username" {
  name  = "/${var.task_name}/db_username"
  type  = "String"
  value = "admin"
  tags = local.tags
}

# Store database password in SSM Parameter Store
resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.task_name}/db_password"
  type  = "SecureString"
  value = random_password.rds_password.result
  tags = local.tags
}

# Fetch database name from SSM Parameter Store
data "aws_ssm_parameter" "db_name" {
  name = aws_ssm_parameter.db_name.name
}

# Fetch database username from SSM Parameter Store
data "aws_ssm_parameter" "db_username" {
  name = aws_ssm_parameter.db_username.name
}

# Fetch database password from SSM Parameter Store
data "aws_ssm_parameter" "db_password" {
  name            = aws_ssm_parameter.db_password.name
  with_decryption = true
}

# Provision an RDS instance
module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.10"

  identifier                = "${var.task_name}-rds"
  create_db_option_group    = false
  create_db_parameter_group = false
  engine                    = "mysql"
  engine_version            = "8.0"
  family                    = "mysql8.0"
  major_engine_version      = "8.0"
  instance_class            = "db.t3.micro"
  allocated_storage         = 10
  db_name                   = data.aws_ssm_parameter.db_name.value
  username                  = data.aws_ssm_parameter.db_username.value
  password                  = data.aws_ssm_parameter.db_password.value
  port                      = 3306
  skip_final_snapshot       = true
  multi_az                  = false
  publicly_accessible       = false
  deletion_protection       = false
  vpc_security_group_ids    = [var.security_group_id]
  db_subnet_group_name      = aws_db_subnet_group.rds_subnet_group.name

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  tags = local.tags
}
