variable "vpc_cidr" {
  description = "VPC CIDR IP address block"
  default     = "192.168.0.0/24"
}

variable "pub_subnet_cidr" {
  description = "Public subnet CIDR IP address block"
  default     = "192.168.0.0/25"
}

variable "pri_subnet_cidr" {
  description = "Private subnet CIDR IP address block"
  default     = "192.168.0.128/25"
}
