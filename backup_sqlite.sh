#!/bin/bash

# --- CONFIG ---
DB_PATH="/path/to/mydb.sqlite"
BACKUP_DIR="/tmp/sqlite_backups"
S3_BUCKET="s3://my-sqlite-backups"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Timestamp for this backup
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/mydb_$TIMESTAMP.sqlite"

# --- SAFE SQLITE BACKUP ---
sqlite3 "$DB_PATH" ".backup '$BACKUP_FILE'"

if [ $? -ne 0 ]; then
    echo "SQLite backup failed!"
    exit 1
fi

echo "Backup successful: $BACKUP_FILE"

# --- UPLOAD TO S3 ---
aws s3 cp "$BACKUP_FILE" "$S3_BUCKET/"

if [ $? -ne 0 ]; then
    echo "Upload to S3 failed!"
    exit 1
fi

echo "Backup uploaded to $S3_BUCKET"

# --- OPTIONAL: Remove old local backups (keep last 7 days) ---
find "$BACKUP_DIR" -type f -mtime +7 -name "*.sqlite" -exec rm {} \;
