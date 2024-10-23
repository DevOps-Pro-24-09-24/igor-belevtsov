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
