#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]; then 
    echo -e "$R ERROR :: Please run the script with root priveleges $N"
    exit 1
fi

SOURCE_DIR="/home/ec2-user/app-logs"
if[ ! -d $SOURCE_DIR]; then 
    echo -e "$R $SOURCE_DIR does not exists $N"
    exit 1
fi

delete_old_logs = $(find $SOURCE_DIR -name "*.txt" -type f -mtime +14)
while IFS= read -r filepath 
    do
        echo -e "$Y deleting log files successfully $N"
        rm -rf $filepath
        echo -e "$G deleted log files successfully $N"
    done <<< $delete_old_logs

