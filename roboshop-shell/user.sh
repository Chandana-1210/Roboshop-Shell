#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log" # /var/log/shell-script/16-logs.log
SCRIPT_DIR=$pwd
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

id roboshop &>> $LOG_FILE
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
else
    echo -e "User already exists...$Y Skipping $N"
fi

mkdir -p /app
Validate $? "create app directory if not exists"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user-v3.zip &>>$LOG_FILE
Validate $? "copy code to tempory folder"
cd /app
Validate $? "changing the directory"
rm -rf /app/*
Validate $? "remove existing files in app directory"
unzip /tmp/user.zip &>> $LOG_FILE
Validate $? "unzip code"
dnf  module disable nodejs -y &>>$LOG_FILE
Validate $? "disabling nodejs"
dnf  module enable nodejs:20 -y &>>$LOG_FILE
Validate $? "enabling nodejs with version as 20"
dnf install nodejs -y &>>$LOG_FILE
Validate $? "installing nodejs"
npm install &>>$LOG_FILE
Validate $? "installing dependencies"
chown -R roboshop:roboshop /app &>>$LOG_FILE
Validate $? "changing ownership from root to roboshop"
cp $SCRIPT_DIR/user.service /etc/systemd/system/user.service &>>$LOG_FILE
Validate $? "Copying user services"
systemctl daemon-reload &>>$LOG_FILE
Validate $? "reloading background services"
systemctl enable user &>>$LOG_FILE
Validate $? "enabling user service"
systemctl start user &>>$LOG_FILE
Validate $? "Starting user service"
END_TIME=$(date +%s)
TOTAL_TIME=$(($END_TIME-$START_TIME))
echo -e "$G script execution completed in $TOTAL_TIME sec"