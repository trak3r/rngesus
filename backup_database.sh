#!/bin/bash

# RNGesus Database Backup Script
# This script backs up all SQLite databases from the Docker volume

set -e  # Exit on error

# Configuration
BACKUP_DIR="/home/ubuntu/backups/rngesus"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
CONTAINER_NAME="rngesus-web-1"
VOLUME_NAME="rngesus_storage"
RETENTION_DAYS=30

# Database file to backup (only main production DB, not transient cache/queue/cable)
DB_FILE="production.sqlite3"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "=== RNGesus Database Backup Started at $(date) ==="
echo "Backup directory: $BACKUP_DIR"
echo "Timestamp: $TIMESTAMP"
echo ""

# Create a subdirectory for this backup
BACKUP_SUBDIR="$BACKUP_DIR/backup_$TIMESTAMP"
mkdir -p "$BACKUP_SUBDIR"

# Backup database using SQLite's .backup command
echo "Backing up $DB_FILE..."

# Use SQLite's .backup command for safe, consistent backups
docker exec "$CONTAINER_NAME" sqlite3 "/rails/storage/$DB_FILE" ".backup '/tmp/$DB_FILE'" || {
  echo "  ✗ Failed to create backup of $DB_FILE"
  exit 1
}

# Copy the backup from container to host
docker cp "$CONTAINER_NAME:/tmp/$DB_FILE" "$BACKUP_SUBDIR/$DB_FILE" || {
  echo "  ✗ Failed to copy backup from container"
  exit 1
}

# Clean up temporary backup file in container
docker exec "$CONTAINER_NAME" rm -f "/tmp/$DB_FILE"

# Verify the backup file exists and has size > 0
if [ -s "$BACKUP_SUBDIR/$DB_FILE" ]; then
  SIZE=$(du -h "$BACKUP_SUBDIR/$DB_FILE" | cut -f1)
  echo "  ✓ Backed up $DB_FILE ($SIZE)"
else
  echo "  ✗ Backup file is empty or missing"
  exit 1
fi

# Create a compressed archive of all databases
echo ""
echo "Creating compressed archive..."
cd "$BACKUP_DIR"
tar -czf "backup_$TIMESTAMP.tar.gz" "backup_$TIMESTAMP"

if [ -f "backup_$TIMESTAMP.tar.gz" ]; then
  ARCHIVE_SIZE=$(du -h "backup_$TIMESTAMP.tar.gz" | cut -f1)
  echo "  ✓ Created backup_$TIMESTAMP.tar.gz ($ARCHIVE_SIZE)"
  
  # Remove uncompressed backup directory
  rm -rf "$BACKUP_SUBDIR"
else
  echo "  ✗ Failed to create compressed archive"
  exit 1
fi

# Clean up old backups (older than RETENTION_DAYS)
echo ""
echo "Cleaning up backups older than $RETENTION_DAYS days..."
find "$BACKUP_DIR" -name "backup_*.tar.gz" -type f -mtime +$RETENTION_DAYS -delete
REMAINING=$(find "$BACKUP_DIR" -name "backup_*.tar.gz" -type f | wc -l)
echo "  ✓ Cleanup complete. $REMAINING backup(s) remaining."

echo ""
echo "=== Backup Completed Successfully at $(date) ==="
echo "Backup location: $BACKUP_DIR/backup_$TIMESTAMP.tar.gz"
