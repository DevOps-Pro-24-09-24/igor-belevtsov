resource "aws_instance" "frontend" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  key_name                    = var.key_name
  security_groups             = [aws_security_group.frontend.id]
  user_data                   =  file("aws-frontend-userdata.sh")

  tags = { Name = "HW6-Frontend" }
}

resource "aws_instance" "backend" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.private.id
  key_name        = var.key_name
  security_groups = [aws_security_group.backend.id]

  tags = { Name = "HW6-Backend" }
}
