
# MySQL Backup to AWS S3 for DB AMI

This guide provides instructions to back up a MySQL database from the DB AMI instance to an AWS S3 bucket. The script runs nightly at 01:00 and retains only the last 7 backups. The S3 bucket name is retrieved from AWS Systems Manager (SSM) Parameter Store.

## Backup Script: `db_backup.sh`

Save the following script to the **DB AMI** instance and make it executable.

<details>

```bash
#!/bin/bash

# Configuration
DB_NAME="flask_db"
DB_USER="flask_user"
DB_PASSWORD="secure_password"  # Update with the actual password
SSM_PARAMETER_NAME="/app/s3-backup-bucket"  # Update with your SSM parameter name

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
mysqldump -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" | gzip > "$BACKUP_FILE"

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
```
</details>

### Set Up Cron Job to Run Daily at 01:00

1. Open the cron file for editing:

   ```bash
   crontab -e
   ```

2. Add the following line to schedule the script to run every day at 01:00:

   ```bash
   0 1 * * * /home/ubuntu/db_backup.sh >> /var/log/db_backup.log 2>&1
   ```

   Or replace `/home/ubuntu/db_backup.sh` with the actual path to the script.

3. Save and exit the crontab editor.

### Explanation of the Script

- **Database Backup**: Creates a compressed MySQL dump file.
- **S3 Upload**: Uploads the backup to the specified S3 bucket.
- **Old Backup Removal**: Retains only the last 7 backups, deleting older ones from S3.
- **Error Handling**: Exits and logs errors if backup or upload fails.

### Notes

- Ensure the DB instance has the appropriate AWS IAM role permissions for accessing SSM and S3, and that the AWS CLI is installed and configured.
