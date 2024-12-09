output "security_group_id" {
  value = aws_security_group.sg.id
}

output "rds_security_group_id" {
  value = aws_security_group.sg_rds.id
}
