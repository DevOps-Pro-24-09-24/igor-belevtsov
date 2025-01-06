#!/bin/bash
TASK_NAME="hw-7"
RDS_NAME=$(aws ssm get-parameter --name "/$TASK_NAME/db_name" --query Parameter.Value --output text)
RDS_ROOT_USER=$(aws ssm get-parameter --name "/$TASK_NAME/db_username" --query Parameter.Value --output text)
RDS_ROOT_USER_PASS=$(aws ssm get-parameter --name "/$TASK_NAME/db_password" --with-decryption --query Parameter.Value --output text)

# Install required packages and modules
apt update -y
apt install -y apache2 mariadb-server php php-mysqlnd
systemctl start apache2
systemctl enable apache2
a2enmod rewrite
a2enmod ssl

# Install WordPress
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/
chown -R apache:apache /var/www/html/
chmod -R 755 /var/www/html/

# Generate a self-signed SSL certificate
mkdir -p /etc/apache2/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /etc/apache2/ssl/wordpress.key \
-out /etc/apache2/ssl/wordpress.crt \
-subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=$(hostname)"
chown apache:apache /etc/apache2/ssl/wordpress.crt /etc/apache2/ssl/wordpress.key
chmod 600 /etc/apache2/ssl/wordpress.crt /etc/apache2/ssl/wordpress.key


# Configure Apache for SSL
cat > /etc/apache2/sites-available/wordpress-https.conf <<EOL
<VirtualHost *:443>
    ServerAdmin admin@example.com
    DocumentRoot "/var/www/html"
    ServerName $(hostname)

    SSLEngine on
    SSLCertificateFile /etc/apache2/ssl/wordpress.crt
    SSLCertificateKeyFile /etc/apache2/ssl/wordpress.key

    <Directory "/var/www/html">
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog /var/log/apache2/wordpress-error.log
    CustomLog /var/log/apache2/wordpress-access.log combined
</VirtualHost>
EOL

# Redirect HTTP traffic to HTTPS
cat > /etc/apache2/sites-available/wordpress-http.conf <<EOL
<VirtualHost *:80>
    ServerAdmin admin@example.com
    DocumentRoot "/var/www/html"
    ServerName $(hostname)

    Redirect "/" "https://$(hostname)/"
</VirtualHost>
EOL

# Enable newly created site configuration and disable default
a2ensite wordpress-http
a2ensite wordpress-https
a2dissite 000-default

# Restart Apache to apply changes
systemctl restart apache2

# Configure WordPress
cat > /var/www/html/wp-config.php <<EOL
<?php
define('DB_NAME', '${RDS_NAME}');
define('DB_USER', '${RDS_ROOT_USER}');
define('DB_PASSWORD', '${RDS_ROOT_USER_PASS}');
define('DB_HOST', '${var.rds_endpoint}');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
\$table_prefix = 'wp_';
define('WP_DEBUG', false);
if ( !defined('ABSPATH') ) {
define('ABSPATH', dirname(__FILE__) . '/');
}
require_once ABSPATH . 'wp-settings.php';
?>
EOL
