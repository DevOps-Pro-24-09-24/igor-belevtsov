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
