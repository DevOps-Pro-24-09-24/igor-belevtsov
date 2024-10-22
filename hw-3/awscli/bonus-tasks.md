# MariaDB installation on backend instance from VPC.md

## MariaDB installation process:
Create a script file 'install-mariadb.sh' to execute MariaDB installation with next content:

```
#!/bin/bash
sudo apt-get update
sudo apt-get install -y mysql-server

sudo sed -i "s/^bind-address\s*=.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

sudo systemctl restart mysql

sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY 'password';"
sudo mysql -uroot -ppassword -e "CREATE USER 'wordpressuser'@'192.168.0.71' IDENTIFIED BY 'wordpresspassword';"
sudo mysql -uroot -ppassword -e "CREATE DATABASE wordpress;"
sudo mysql -uroot -ppassword -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'192.168.0.71' WITH GRANT OPTION;"
sudo mysql -uroot -ppassword -e "FLUSH PRIVILEGES;"

sudo systemctl restart mysql
sudo systemctl enable mysql
```
Now you need to modify a run-instance command from VPC.md and add a --user-data section:

```
BACK_INSTANCE_ID=$(aws ec2 run-instances --image-id $UBNT_AMI_ID --count 1 --instance-type t3.micro --key-name blackbird --security-group-ids $BACK_SG_ID --subnet-id $PRI_SUBNET_ID --user-data 'file://install-mariadb.sh' --query 'Instances[0].InstanceId' --output text)
```

## New AMI creation process:
For creation a new AMI from this instance do next:

### (Optional) Stop the instance to ensure a clean state

```
aws ec2 stop-instances --instance-ids $BACK_INSTANCE_ID
aws ec2 wait instance-stopped --instance-ids $BACK_INSTANCE_ID
```

### Create the AMI from the instance

```
MARIADB_AMI_ID=$(aws ec2 create-image --instance-id $BACK_INSTANCE_ID --name "MariaDBAMI" --description "AMI with MariaDB installed" --no-reboot --query 'ImageId' --output text)
```

### Output the AMI ID

```
echo "AMI created with ID: $MARIADB_AMI_ID"
```

### (Optional) Start the instance again

```
aws ec2 start-instances --instance-ids $BACK_INSTANCE_ID
```

## Web application installation process:
Create a script file 'install-web-server.sh' to execute web server installation with next content:

```
#!/bin/bash
sudo apt-get update
sudo apt-get install -y apache2 php libapache2-mod-php php-mysql

sudo wget -c http://wordpress.org/latest.tar.gz
sudo tar -xzvf latest.tar.gz
sudo rsync -av wordpress/* /var/www/html/

sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

sudo a2enmod rewrite
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sudo sed -i "s/database_name_here/wordpress/g" /var/www/html/wp-config.php
sudo sed -i "s/username_here/wordpressuser/g" /var/www/html/wp-config.php
sudo sed -i "s/password_here/wordpresspassword/g" /var/www/html/wp-config.php
sudo sed -i "s/localhost/192.168.0.179/g" /var/www/html/wp-config.php

sudo systemctl restart apache2
```
Now you need to modify a run-instance command from VPC.md and add a --user-data section:

```
FRONT_INSTANCE_ID=$(aws ec2 run-instances --image-id $UBNT_AMI_ID --count 1 --instance-type t3.micro --key-name blackbird --security-group-ids $FRONT_SG_ID --subnet-id $PUB_SUBNET_ID --user-data 'file://install-web-server.sh' --query 'Instances[0].InstanceId' --output text)
```
Change a security group configuration for web app access:

```
FRONT_SG_ID=$(aws ec2 create-security-group --group-name allow-ssh-and-web --description "Security group that allows SSH and Web (80) connection to public subnet instances" --vpc-id $VPC_ID --query 'GroupId' --output text)
aws ec2 create-tags --resources $FRONT_SG_ID --tags Key=Name,Value=sg-FRONT
aws ec2 authorize-security-group-ingress --group-id $FRONT_SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $FRONT_SG_ID --protocol tcp --port 80 --cidr 0.0.0.0/0
```

## Checking web access from internet:

```
curl -I http://$FRONT_PUBLIC_IP:80
```
<details>

```
HTTP/1.1 200 OK
Date: Tue, 22 Oct 2024 22:09:56 GMT
Server: Apache/2.4.41 (Ubuntu)
Last-Modified: Tue, 22 Oct 2024 22:08:17 GMT
Content-Type: text/html; charset=UTF-8
Content-Length: 1234
Connection: keep-alive
```
</details>

## SSH keys update automatization:
Create a ssh script named 'update-ssh-keys.sh' with next content:

```
#!/bin/bash

# Path to the authorized_keys file for the user (default: ubuntu)
AUTHORIZED_KEYS_PATH="/home/ubuntu/.ssh/authorized_keys"

# New public key content (replace with your new public key)
NEW_PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEArZKQxxxxx... user@domain"

# Backup the existing authorized_keys file
cp $AUTHORIZED_KEYS_PATH ${AUTHORIZED_KEYS_PATH}.bak

# Replace the authorized_keys with the new public key
echo $NEW_PUBLIC_KEY > $AUTHORIZED_KEYS_PATH

# Ensure proper permissions for the authorized_keys file
chmod 600 $AUTHORIZED_KEYS_PATH
chown ubuntu:ubuntu $AUTHORIZED_KEYS_PATH
```

User-data usage:

```
FRONT_INSTANCE_ID=$(aws ec2 run-instances --image-id $UBNT_AMI_ID --count 1 --instance-type t3.micro --key-name blackbird --security-group-ids $FRONT_SG_ID --subnet-id $PUB_SUBNET_ID --associate-public-ip-address --user-data 'file://update-ssh-keys.sh' --query 'Instances[0].InstanceId' --output text)
FRONT_PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $FRONT_INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
```
Manual usage:

```
scp -i blackbird.pem update-ssh-keys.sh ubuntu@$FRONT_PUBLIC_IP:/home/ubuntu/
ssh -i blackbird.pem ubuntu@$FRONT_PUBLIC_IP 'bash ~/update-ssh-keys.sh'
```

Print all using key-pairs:

```
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId, KeyName]' --output text
```
