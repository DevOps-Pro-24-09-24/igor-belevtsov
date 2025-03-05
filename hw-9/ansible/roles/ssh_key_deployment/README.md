# SSH Key Setup Role

An Ansible role to deploy SSH public keys to remote hosts.

## Requirements

- Ansible 2.9 or higher
- Valid SSH public key on the Ansible control node

## Role Variables

Available variables are listed below, along with default values:

```yaml
# Path to your public SSH key file on the Ansible control node
ssh_key_file: "~/.ssh/id_rsa.pub"

# User to apply the SSH key to (default is root)
remote_user: "root"

# Target SSH directory
ssh_dir: "/root/.ssh"

# SSH authorized_keys file
authorized_keys_file: "{{ ssh_dir }}/authorized_keys"
```

## Example Playbook

```yaml
---
- name: Deploy SSH keys
  hosts: all
  roles:
    - ssh_key_setup
```

## License

MIT
