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

# Database files to backup
DATABASES=(
  "production.sqlite3"
  "production_cache.sqlite3"
  "production_queue.sqlite3"
  "production_cable.sqlite3"
)

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "=== RNGesus Database Backup Started at $(date) ==="
echo "Backup directory: $BACKUP_DIR"
echo "Timestamp: $TIMESTAMP"
echo ""

# Create a subdirectory for this backup
BACKUP_SUBDIR="$BACKUP_DIR/backup_$TIMESTAMP"
mkdir -p "$BACKUP_SUBDIR"

# Backup each database using SQLite's .backup command
for db in "${DATABASES[@]}"; do
  echo "Backing up $db..."
  
  # Use SQLite's .backup command for safe, consistent backups
  docker exec "$CONTAINER_NAME" sqlite3 "/rails/storage/$db" ".backup '/tmp/$db'" 2>/dev/null || {
    echo "  Warning: Could not backup $db (file may not exist)"
    continue
  }
  
  # Copy the backup from container to host
  docker cp "$CONTAINER_NAME:/tmp/$db" "$BACKUP_SUBDIR/$db" 2>/dev/null || {
    echo "  Warning: Could not copy backup for $db"
    continue
  }
  
  # Clean up temporary backup file in container
  docker exec "$CONTAINER_NAME" rm -f "/tmp/$db" 2>/dev/null
  
  # Verify the backup file exists and has size > 0
  if [ -s "$BACKUP_SUBDIR/$db" ]; then
    SIZE=$(du -h "$BACKUP_SUBDIR/$db" | cut -f1)
    echo "  ✓ Backed up $db ($SIZE)"
  else
    echo "  ✗ Failed to backup $db"
    rm -f "$BACKUP_SUBDIR/$db"
  fi
done

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
