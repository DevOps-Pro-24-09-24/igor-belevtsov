output "ami_id" {
  value = aws_instance.web.ami
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

output "private_ip" {
  value = aws_instance.web.private_ip
}
