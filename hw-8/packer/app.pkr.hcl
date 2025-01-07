source "amazon-ebs" "app_source" {
  ami_name             = "APP_AMI_{{timestamp}}"
  instance_type        = var.instance_type
  region               = var.aws_region
  subnet_id            = var.subnet_id
  vpc_id               = var.vpc_id
  ssh_username         = "ubuntu"
  ssh_interface        = "session_manager"
  communicator         = "ssh"
  iam_instance_profile = "EC2-SSM-Access-Role" # This role was used in previous HW and already have configured SSM and S3 permission for instance
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
    Name = "hw-8-app"
    TaskName = "hw-8"
    Packer = "true"
  }
}

build {
  name = "hw-8-app"
  sources = [
    "source.amazon-ebs.app_source"
  ]

  provisioner "ansible" {
    playbook_file = "../ansible/app-install.yml"
    extra_arguments = [
      "--extra-vars",
      "python_version=3.10 flask_app_dir=/opt/flask_app repo_url=https://github.com/DevOps-Pro-24-09-24/examples.git repo_branch=main app_subdir=flask-alb-app flask_service_name=flask_app"
    ]
  }
}
