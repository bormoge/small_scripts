#!/bin/bash

BACKUP_TYPE_FLAG=${1}
BACKUP_PATH=${2}
CUSTOM_BACKUP_PATH=${3}

## This specific rsync command was taken and modified from the Arch Linux wiki (https://wiki.archlinux.org/title/Rsync).

if [ -n "$BACKUP_TYPE_FLAG" ] && [ "$BACKUP_TYPE_FLAG" == "-home" ]
then
    printf " $BACKUP_TYPE_FLAG flag was used. Proceeding with home backup.\n"
    printf " BACKUP PATH: $BACKUP_PATH\n"

    ## Keep in mind this copies the directory along with its contents; to copy only the contents you'll need to use /home/
    rsync -aAXHvt /home $BACKUP_PATH

elif [ -n "$BACKUP_TYPE_FLAG" ] && [ "$BACKUP_TYPE_FLAG" == "-full" ]
then
    printf " $BACKUP_TYPE_FLAG flag was used. Proceeding with full system backup.\n"
    printf " BACKUP PATH: $BACKUP_PATH\n"

    ## Copies the contents of the root directory
    rsync -aAXHvt --exclude='/dev/*' --exclude='/proc/*' --exclude='/sys/*' --exclude='/tmp/*' --exclude='/run/*' --exclude='/mnt/*' --exclude='/media/*' --exclude='/lost+found/' / $BACKUP_PATH

elif [ -n "$BACKUP_TYPE_FLAG" ] && [ "$BACKUP_TYPE_FLAG" == "-custom" ]
then
    printf " $BACKUP_TYPE_FLAG flag was used. Proceeding with custom path backup.\n"
    printf " DATA PATH: $BACKUP_PATH\n"
    printf " BACKUP PATH: $CUSTOM_BACKUP_PATH\n"

    rsync -aAXHvt $BACKUP_PATH $CUSTOM_BACKUP_PATH

else
    printf "\nTry one of this flags: -home, -full, -custom\n"
fi
