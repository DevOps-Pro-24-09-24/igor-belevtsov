variable "aws_region" {
  description = "The AWS region to deploy resources in"
  default     = "eu-north-1"
}

variable "task_name" {
  description = "Task name for resources tag"
  default     = "hw-7"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key pair name for EC2 instances"
  default     = "blackbird"
}
