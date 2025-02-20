#!/bin/bash

<<note
This script takes the backup of any destination path given in argument
./backup.sh /home/ubuntu/scripts
note

echo "This script takes the backup of any destination path given in argument ./backup.sh /home/ubuntu/scripts"

function show_date() {
        date '+%Y-%m-%d_%H-%M-%S'
}

function take_backup() {
timestamp=$(date '+%Y-%m-%d_%H-%M-%S')

backup_dir="/home/ubuntu/backups/${timestamp}_backup.zip"

zip -r $backup_dir $1

echo "Backup Complete"
}

show_date
take_backup $1
