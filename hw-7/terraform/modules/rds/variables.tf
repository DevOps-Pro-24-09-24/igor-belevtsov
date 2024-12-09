variable "private_subnets" {
  description = "VPC private subnets ID"
  default     = {}
}

variable "task_name" {
  description = "Task name"
  default     = {}
}

variable "security_group_id" {
  description = "VPC security group ID"
  default     = {}
}

variable "vpc_id" {
  default = {}
}
