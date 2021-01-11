#!/bin/bash

# Database credentials
user=""
password=""
db_name=""

# Other options
backup_path="/path/to/database/backups"
date=$(date +"%d-%b-%Y_%H%M")

# Set default file permissions
umask 177

# Dump database into SQL file
mysqldump --user=$user --password=$password $db_name | gzip > $backup_path/$db_name-$date.sql.gz

# Delete files older than 30 days
find $backup_path/* -mtime +15 -exec rm {} \;
