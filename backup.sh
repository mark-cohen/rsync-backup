#!/bin/sh

### Backup script
### 3rd Stone Consulting
### Last modified July 2016

### Requires rsync 3: https://rsync.samba.org/

# set rsync location
RSYNC_BIN="/usr/local/bin/rsync"
# set log archives location 
LOG_DIR="/Library/Logs/backup-log-archive/"
# set name/format of time stamped log file 
LOGNAME=rsync-`date +%Y-%m-%d-%T`.log
# define source directory
SOURCE_DIR="/Volumes/Storage/"
# define backup destination 
BACKUP_DIR="/Volumes/Backup/"
# set exclude file location
EXCLUDE="/Library/Scripts/Backup/rsync_excludes.txt"
# set email notification address
EMAIL="admin@org.ca"

if [ ! -d "$LOG_DIR" ]; then
mkdir $LOG_DIR
fi

cp /Library/Logs/backup.log $LOG_DIR/$LOGNAME
rm -f /Library/Logs/backup.log  && touch /Library/Logs/backup.log

echo Backup started >> /Library/Logs/backup.log
date >> /Library/Logs/backup.log

cd $SOURCE_DIR

# begin backup
$RSYNC_BIN --dry-run -avNHXxh --fileflags --force-change --rsync-path="$RSYNC_BIN" \
--backup --backup-dir=../`date +%y:%m:%d` \
--delete-excluded --exclude-from=$EXCLUDE \
$SOURCE_DIR/ $BACKUP_DIR/ >> /Library/Logs/backup.log

#### Stamp the log and send the notification ####
echo Backup complete >> /Library/Logs/backup.log
date >> /Library/Logs/backup.log
# cat /Library/Logs/backup.log | mail -s "Client: Server - backup complete" $EMAIL

exit
