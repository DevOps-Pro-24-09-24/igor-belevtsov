# Retrieve the parameter from Parameter Store
DB_ROOT_USER=$(aws ssm get-parameter --name "/app/DB_ROOT_USER" --with-decryption --query "Parameter.Value" --output text)
DB_ROOT_USER_PASS=$(aws ssm get-parameter --name "/app/DB_ROOT_USER_PASS" --with-decryption --query "Parameter.Value" --output text)
DB_USER=$(aws ssm get-parameter --name "/app/DB_USER" --with-decryption --query "Parameter.Value" --output text)
DB_USER_PASS=$(aws ssm get-parameter --name "/app/DB_USER_PASS" --with-decryption --query "Parameter.Value" --output text)
DB_NAME=$(aws ssm get-parameter --name "/app/DB_NAME" --with-decryption --query "Parameter.Value" --output text)

# Secure MySQL installation (you may want to script the commands if doing non-interactively)
sudo mysql -e "ALTER USER '$DB_ROOT_USER'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY '$DB_ROOT_USER_PASS';"
sudo mysql --user="$DB_ROOT_USER" --password="$DB_ROOT_USER_PASS" -e "CREATE DATABASE $DB_NAME;"
sudo mysql --user="$DB_ROOT_USER" --password="$DB_ROOT_USER_PASS" -e "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_USER_PASS';"
sudo mysql --user="$DB_ROOT_USER" --password="$DB_ROOT_USER_PASS" -e "GRANT ALL ON $DB_NAME.* TO '$DB_USER'@'%';"
sudo mysql --user="$DB_ROOT_USER" --password="$DB_ROOT_USER_PASS" -e "FLUSH PRIVILEGES;"
sudo systemctl restart mysql
