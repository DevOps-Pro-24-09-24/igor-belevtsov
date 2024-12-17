#!/bin/sh
# Build AMI's using Packer:
# APP
packer build -var-file=variables.pkr.hcl app.pkr.hcl | sudo tee app_ami_output.txt
$APP_AMI_ID=$(tail -2 app_ami_output.txt | head -2 | awk 'match($0, /ami-.*/) { print substr($0, RSTART, RLENGTH) }')
# DB
packer build -var-file=variables.pkr.hcl db.pkr.hcl | sudo tee db_ami_output.txt
$DB_AMI_ID=$(tail -2 db_ami_output.txt | head -2 | awk 'match($0, /ami-.*/) { print substr($0, RSTART, RLENGTH) }')

# Launch EC2 instances using AMI's from previous step:
# APP
$APP_INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $APP_AMI_ID \
    --count 1 \
    --instance-type t3.micro \
    --key-name blackbird \
    --iam-instance-profile Name=EC2-SSM-Access-Role \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=ec2-app}]' \
    --associate-public-ip-address \
    --query 'Instances[0].InstanceId' \
    --output text)
aws ec2 create-tags --resources $APP_INSTANCE_ID --tags Key=Name,Value=HW-8-APP
aws ec2 wait instance-running --instance-ids $APP_INSTANCE_ID
# DB
$DB_INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $DB_AMI_ID \
    --count 1 \
    --instance-type t3.micro \
    --key-name blackbird \
    --iam-instance-profile Name=EC2-SSM-Access-Role \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=ec2-db}]' \
    --associate-public-ip-address \
    --query 'Instances[0].InstanceId' \
    --output text)
aws ec2 create-tags --resources $DB_INSTANCE_ID --tags Key=Name,Value=HW-8-DB
aws ec2 wait instance-running --instance-ids $DB_INSTANCE_ID
