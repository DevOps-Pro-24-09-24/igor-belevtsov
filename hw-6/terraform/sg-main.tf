resource "aws_security_group" "frontend" {
  vpc_id      = aws_vpc.main.id
  name        = "allow-ssh"
  description = "Allow SSH access to public subnet instances"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "sg-FRONT" }
}

resource "aws_security_group" "backend" {
  vpc_id      = aws_vpc.main.id
  name        = "allow-intranet"
  description = "Allow all traffic between internal VPC instances"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.frontend.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "sg-BACK" }
}
