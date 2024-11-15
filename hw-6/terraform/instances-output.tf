output "ubuntu_2204_ami_id" {
  value = data.aws_ami.ubuntu.id
}

output "frontend_instance_id" {
  value = aws_instance.frontend.id
}

output "frontend_public_ip" {
  value = aws_instance.frontend.public_ip
}

output "frontend_private_ip" {
  value = aws_instance.frontend.private_ip
}

output "backend_instance_id" {
  value = aws_instance.backend.id
}

output "backend_private_ip" {
  value = aws_instance.backend.private_ip
}
