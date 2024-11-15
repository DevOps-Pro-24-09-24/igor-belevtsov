variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key pair name for EC2 instances"
  default     = "blackbird"
}
