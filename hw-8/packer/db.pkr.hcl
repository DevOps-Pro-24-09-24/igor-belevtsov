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
    Name = "hw-8-db"
    TaskName = "hw-8"
    Packer = "true"
  }
}

build {
  name = "hw-8-db"
  sources = [
    "source.amazon-ebs.db_source"
  ]

  provisioner "ansible" {
    playbook_file = "../ansible/db-install.yml"
    extra_arguments = [
      "--extra-vars",
      "mysql_root_password=root_password123 mysql_app_user=app_user mysql_app_user_password=app_user_password123 mysql_database=flask_db"
    ]
  }
}
