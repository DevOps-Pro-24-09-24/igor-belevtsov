module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.16"

  name = "${var.task_name}-vpc"
  cidr = "192.168.0.0/16"

  azs             = ["eu-north-1a", "eu-north-1b"]
  private_subnets = ["192.168.3.0/24", "192.168.4.0/24"]
  public_subnets  = ["192.168.1.0/24", "192.168.2.0/24"]

  enable_nat_gateway = false
  single_nat_gateway = true

  tags = {
    Terraform = "true"
    TaskName  = var.task_name
  }
}
