# MySQL Setup Role

An Ansible role to install and configure MySQL database server on various Linux distributions.

## Features

- Automatically detects OS type (Debian/Ubuntu or Fedora/RHEL)
- Installs appropriate MySQL packages
- Configures MySQL with secure defaults
- Creates databases and users
- Sets up performance tuning parameters

## Requirements

- Ansible 2.9 or higher
- Root access to target hosts

## Role Variables

Available variables are listed below, along with default values:

```yaml
# MySQL configuration
mysql_root_password: "StrongP@ssw0rd"  # Consider using ansible-vault for production
mysql_bind_address: "0.0.0.0"
mysql_port: 3306

# Database settings
mysql_databases:
  - name: example_db
    encoding: utf8
    collation: utf8_general_ci

# Database users
mysql_users:
  - name: example_user
    password: "UserP@ssw0rd"  # Consider using ansible-vault for production
    host: "%"
    priv: "example_db.*:ALL"

# Performance tuning
mysql_max_connections: 151
mysql_innodb_buffer_pool_size: "256M"
```

## Example Playbook

```yaml
---
- name: Deploy MySQL
  hosts: db_servers
  roles:
    - mysql_setup
```

## Security Note

For production use, it's recommended to store passwords in ansible-vault rather than in plaintext.

## License

MIT
