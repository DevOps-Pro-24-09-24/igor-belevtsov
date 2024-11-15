source "amazon-ebs" "db_source" {
  ami_name      = "DB_AMI_{{timestamp}}"
  instance_type = var.instance_type
  region        = var.aws_region
  subnet_id     = var.subnet_id
  vpc_id        = var.vpc_id
  ssh_username  = "ubuntu"
  ssh_interface        = "session_manager"
  communicator         = "ssh"
  iam_instance_profile = "EC2-SSM-Access-Role"  # This role was used in previous HW and already have configured SSM and S3 permission for instance
  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "ubuntu/images/hvm-ssd/ubuntu*22.04-amd64-server-*"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"]
    most_recent = true
  }

  tags = {
    Name = "DB"
  }
}

build {
  name = "APP"
  sources = [
    "source.amazon-ebs.db_source"
  ]

  provisioner "shell" {
    inline = [
      "sudo apt update",
      "sudo apt install -y mysql-server",
      # Configure MySQL to listen on all interfaces
      "sudo sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf",
      "sudo systemctl restart mysql",
      "sudo systemctl enable mysql"
    ]
  }
}
