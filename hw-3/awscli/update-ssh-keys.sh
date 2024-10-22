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
