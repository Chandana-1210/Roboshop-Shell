#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log" # /var/log/shell-script/16-logs.log
SCRIPT_DIR=$PWD
mkdir -p $LOGS_FOLDER
START_TIME=$(date +%s)
echo "Script started executed at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]; then
    echo "ERROR:: Please run this script with root privelege"
    exit 1 # failure is other than 0
fi

Validate(){ # functions receive inputs through args just like shell script args
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N" | tee -a $LOG_FILE
    fi
}

dnf module disable nginx -y &>>$LOG_FILE
dnf module enable nginx:1.24 -y &>>$LOG_FILE
dnf install nginx -y &>>$LOG_FILE
Validate $? "installing nginx"
rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
Validate $? "removing existing code"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOG_FILE
Validate $? "copy code to tempory folder"
cd /usr/share/nginx/html &>>$LOG_FILE
Validate $? "changing to nginx directory"
unzip /tmp/frontend.zip &>>$LOG_FILE
Validate $? "downlodaing frontend code"
rm -rf /etc/nginx/nginx.conf &>>$LOG_FILE
cp $SCRIPT_DIR/nginx.conf /ect/nginx/nginx.conf
Validate $? "copying nginx.conf"
systemctl start nginx
Validate $? "Starting nginx"
systemctl enable nginx
Validate $? "enabling nginx"