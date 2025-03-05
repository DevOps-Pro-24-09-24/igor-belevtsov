# Flask Application Role

An Ansible role to deploy a Flask application that connects to a MySQL/MariaDB database.

## Features

- Automatically detects OS type (Debian/Ubuntu or Fedora/RHEL)
- Installs required dependencies
- Sets up a Python virtual environment
- Deploys a simple Flask application with SQLAlchemy for database access
- Configures the application to connect to MySQL/MariaDB
- Sets up a systemd service
- Configures firewall and selinux for network access
- Optionally configures Nginx as a reverse proxy

## Requirements

- Ansible 2.9 or higher
- Target hosts must have Python 3 available
- MySQL/MariaDB database should already be configured (e.g., using the mariadb_setup role)

## Role Variables

Available variables are listed below, along with default values:

```yaml
# Application settings
app_name: "flask_example"
app_directory: "/opt/{{ app_name }}"
app_user: "flask"
app_group: "flask"
app_port: 5000
app_environment: "production"

# Python settings
python_version: "3"
virtual_env: "{{ app_directory }}/venv"
requirements_file: "{{ app_directory }}/requirements.txt"

# Database connection
db_name: "example_db"
db_user: "example_user"
db_password: "UserP@ssw0rd"  # Consider using ansible-vault for production
db_host: "{{ groups['db_servers'][0] }}"  # Using first database server by default
db_port: 3306

# Web server configuration
use_nginx: true
server_name: "{{ ansible_fqdn }}.elysium-space.com"
nginx_config_debian: "/etc/nginx/sites-available/{{ app_name }}.conf"
nginx_config_redhat: "/etc/nginx/conf.d/{{ app_name }}.conf"
nginx_enabled: "/etc/nginx/sites-enabled/{{ app_name }}"
nginx_server_config_redhat: "/etc/nginx/nginx.conf"

# SSL configuration
use_ssl: false
ssl_cert: "/etc/ssl/certs/{{ server_name }}.crt"
ssl_key: "/etc/ssl/private/{{ server_name }}.key"
```

## Example Playbook

```yaml
---
- name: Deploy Flask application
  hosts: web_servers
  roles:
    - flask_app
```

## Security Note

For production use, it's recommended to store passwords in ansible-vault rather than in plaintext.

## License

MIT
