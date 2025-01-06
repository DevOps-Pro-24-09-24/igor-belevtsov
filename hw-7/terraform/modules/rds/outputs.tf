# Outputs for other modules
output "database_name" {
  value = aws_ssm_parameter.db_name.value
}

output "admin_username" {
  value = aws_ssm_parameter.db_username.value
}

output "admin_password_ssm" {
  value = aws_ssm_parameter.db_password.value
}

output "endpoint" {
  value = module.rds.db_instance_endpoint
}

output "db_name_ssm" {
  value = aws_ssm_parameter.db_name.name
}

output "db_username_ssm" {
  value = aws_ssm_parameter.db_username.name
}

output "db_password_ssm" {
  value = aws_ssm_parameter.db_password.name
}
