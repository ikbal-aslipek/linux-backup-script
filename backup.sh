#!/bin/bash
# backup.sh - archive a directory into a dated .tar.gz file

SOURCE="$HOME/backup-test"
DEST="$HOME/backups"
DATE=$(date +%Y-%m-%d_%H%M)
ARCHIVE="$DEST/backup-$DATE.tar.gz"

mkdir -p "$DEST"
tar -czf "$ARCHIVE" -C "$(dirname "$SOURCE")" "$(basename "$SOURCE")"
echo "Backup created: $ARCHIVE"
