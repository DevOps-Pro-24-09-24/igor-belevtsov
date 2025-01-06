variable "instance_type" {
  description = "EC2 instance type"
  default     = {}
}

variable "key_name" {
  description = "Key pair name for EC2 instances"
  default     = {}
}

variable "public_subnet_id" {
  description = "VPC public subnet ID"
  default     = {}
}

variable "security_group_id" {
  description = "VPC security group ID"
  default     = {}
}

variable "task_name" {
  description = "Task name"
  default     = {}
}

variable "rds_endpoint" {
  description = "RDS endpoint connection url"
  default     = {}
}

variable "vpc_id" {
  default = {}
}

variable "rds_db_name" {
  default = {}
}

variable "rds_admin_username" {
  default = {}
}

variable "rds_admin_password_ssm" {
  default = {}
}

variable "ec2_instance_profile" {
  default = {}
}
