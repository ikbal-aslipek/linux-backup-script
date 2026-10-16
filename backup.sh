#!/bin/bash
# backup.sh - archive a directory into a dated .tar.gz file,
# keep only the newest backups and log every run.

SOURCE="$HOME/backup-test"
DEST="$HOME/backups"
KEEP=${KEEP:-7}
LOG="$DEST/backup.log"
DATE=$(date +%Y-%m-%d_%H%M%S)
ARCHIVE="$DEST/backup-$DATE.tar.gz"

log() {
    echo "$(date '+%F %T') $1" >> "$LOG"
}

mkdir -p "$DEST"

if [ ! -d "$SOURCE" ]; then
    log "ERROR: source $SOURCE does not exist"
    exit 1
fi

if tar -czf "$ARCHIVE" -C "$(dirname "$SOURCE")" "$(basename "$SOURCE")"; then
    log "OK: $ARCHIVE ($(du -h "$ARCHIVE" | cut -f1))"
else
    log "ERROR: backup of $SOURCE failed"
    exit 1
fi

# Delete everything except the newest $KEEP archives
ls -1t "$DEST"/backup-*.tar.gz | tail -n +$((KEEP + 1)) | xargs -r rm --
