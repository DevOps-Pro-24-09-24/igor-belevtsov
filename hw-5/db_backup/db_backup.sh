#!/bin/bash

# Configuration
DB_USER=$(aws ssm get-parameter --name "/app/DB_USER" --with-decryption --query "Parameter.Value" --output text)
DB_USER_PASS=$(aws ssm get-parameter --name "/app/DB_USER_PASS" --with-decryption --query "Parameter.Value" --output text)
DB_NAME=$(aws ssm get-parameter --name "/app/DB_NAME" --with-decryption --query "Parameter.Value" --output text)
SSM_PARAMETER_NAME=$(aws ssm get-parameter --name "/app/DB_BACKUP_BUCKET_NAME" --with-decryption --query "Parameter.Value" --output text)

# AWS CLI configurations
REGION="eu-north-1"  # Update to your AWS region

# Get the S3 bucket name from SSM Parameter Store
S3_BUCKET=$(aws ssm get-parameter --name "$SSM_PARAMETER_NAME" --query "Parameter.Value" --output text --region "$REGION")

if [[ -z "$S3_BUCKET" ]]; then
    echo "Error: S3 bucket name could not be retrieved from SSM Parameter Store."
    exit 1
fi

# Directories and filenames
BACKUP_DIR="/tmp/mysql_backups"
DATE=$(date +'%Y-%m-%d')
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${DATE}.sql.gz"

# Create backup directory if not exists
mkdir -p "$BACKUP_DIR"

# Dump the database and compress the output
mysqldump -u"$DB_USER" -p"$DB_USER_PASS" "$DB_NAME" | gzip > "$BACKUP_FILE"

if [[ $? -ne 0 ]]; then
    echo "Error: Database backup failed."
    exit 1
fi

# Upload the backup file to S3
aws s3 cp "$BACKUP_FILE" "s3://${S3_BUCKET}/backups/${DB_NAME}_${DATE}.sql.gz" --region "$REGION"

if [[ $? -ne 0 ]]; then
    echo "Error: Upload to S3 failed."
    exit 1
fi

echo "Backup uploaded to S3: ${S3_BUCKET}/backups/${DB_NAME}_${DATE}.sql.gz"

# Remove local backup file
rm -f "$BACKUP_FILE"

# Clean up old backups (retain the last 7 backups)
BACKUPS_TO_DELETE=$(aws s3 ls "s3://${S3_BUCKET}/backups/" --region "$REGION" | sort | head -n -7 | awk '{print $4}')

for backup in $BACKUPS_TO_DELETE; do
    aws s3 rm "s3://${S3_BUCKET}/backups/$backup" --region "$REGION"
    echo "Deleted old backup: $backup"
done
