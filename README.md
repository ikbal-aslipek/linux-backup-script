# linux-backup-script

A Bash script that backs up a directory into a dated, compressed archive, keeps only the newest backups, logs every run, and runs automatically every day with cron.

## Features

- Creates timestamped `.tar.gz` archives (e.g. `backup-2026-10-16_020000.tar.gz`)
- Rotation: keeps the newest 7 backups by default and deletes older ones
- Logs every run with timestamp, result and archive size
- Checks that the source directory exists and returns a non-zero exit code on failure
- Scheduled daily via cron

## Requirements

- Linux with Bash (tested on Fedora 44)
- `tar`, `gzip`, `cron` (cronie)

## Usage

```bash
git clone https://github.com/ikbal-aslipek/linux-backup-script.git
cd linux-backup-script
chmod +x backup.sh
./backup.sh
```

## Configuration

Edit the variables at the top of `backup.sh`:

| Variable | Default | Description |
|----------|---------|-------------|
| `SOURCE` | `$HOME/backup-test` | Directory to back up |
| `DEST`   | `$HOME/backups` | Where archives and the log are stored |
| `KEEP`   | `7` | Number of backups to keep |

`KEEP` can also be overridden at runtime:

```bash
KEEP=3 ./backup.sh
```

## Scheduling with cron

Run the backup every day at 02:00:

```bash
crontab -e
```

```
0 2 * * * /home/<user>/linux-backup-script/backup.sh
```

## Example log

```
2026-10-16 02:59:07 OK: /home/erklik/backups/backup-2026-10-16_025907.tar.gz (4.0K)
2026-10-16 02:59:25 ERROR: source /home/erklik/backup-test does not exist
```

## Restoring a backup

List the contents of an archive:

```bash
tar -tzf ~/backups/backup-2026-10-16_020000.tar.gz
```

Extract it to a separate folder:

```bash
mkdir -p /tmp/restore
tar -xzf ~/backups/backup-2026-10-16_020000.tar.gz -C /tmp/restore
```

## Testing

- Ran the script 5 times with `KEEP=3` and confirmed only the 3 newest archives remained
- Removed the source directory and confirmed the script logged an error and exited with code 1
- Scheduled it every minute in cron to confirm unattended runs, then switched to daily

## Possible improvements

- Back up multiple directories
- Copy backups to a remote server with `rsync` over SSH
- Verify archive integrity after creation
