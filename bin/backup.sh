#!/bin/sh
# script for personal backups - pablo - 21 Mar 2008

[ $1 ] || {
    echo "usage: backup.sh <backup_label>"
    echo "backup_label examples: daily, monthly, manual"
    exit
}

type=$1
host=$(hostname -s)

if [ "$type" = "bluehost" ]; then
    h=pablohoffman.com:/home/pablohof
    sources="$h/public_html $h/twiki $h/noti $h/django_projects $h/planet"
    dest=/srv/storage1/backup/bluehost/manual
    logfile=/srv/storage1/backup/bluehost/manual.log
    remotesources=1
elif [ "$type" = "usb" ]; then
    bak="/srv/storage1/backup"
    usbdir="/mnt/usbprh-ext3/backup"
    sources="/home/prh/data /home/prh/Mail /var/mail/prh $bak/aleia $bak/bluehost"
    dest="$usbdir/manual"
    logfile=$usbdir/manual.log
elif [ "$host" = "gaia" ]; then
    sources="/home/prh/data /home/prh/Mail /var/mail/prh"
    dest=/srv/storage1/backup/gaia/$type
    logfile=/srv/storage1/backup/gaia/$type.log
elif [ "$host" = "aleia" ]; then
    sources="/Users/prh/Pictures"
    dest=gaial:/srv/storage1/backup/aleia/$type
    logfile=/srv/storage1/backup/aleia/$type.log
    logremote=1
fi

if [ "$remotesources" ]; then
    for s in $sources; do
        rsync -avR --delete-after --log-file=$logfile $s $dest
    done
elif [ "$logremote" ]; then
    rsync -avR --delete-after --rsync-path="rsync --log-file=$logfile" $sources $dest
else
    rsync -avR --delete-after --log-file=$logfile $sources $dest
fi
