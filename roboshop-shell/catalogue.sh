#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log" # /var/log/shell-script/16-logs.log
MONGODB_HOST="mongodb.daws-86.shop"

mkdir -p $LOGS_FOLDER
echo "Script started executed at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]; then
    echo "ERROR:: Please run this script with root privelege"
    exit 1 # failure is other than 0
fi

VALIDATE(){ # functions receive inputs through args just like shell script args
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
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip $LOG_FILE
Validate $? "copy code to tempory folder"
cd /app
Validate $? "changing the directory"
rm -rf /app/*
Validate $? "remove existing files in app directory"
unzip /tmp/catalogue.zip &>> $LOG_FILE
Validate $? "unzip code"
dnf disable module nodejs -y &>>$LOG_FILE
Validate $? "disabling nodejs"
dnf enable module nodejs:20 -y &>>$LOG_FILE
Validate $? "enabling nodejs with version as 20"
dnf install nodejs -y &>>$LOG_FILE
Validate $? "installing nodejs"
npm install &>>$LOG_FILE
Validate $? "installing dependencies"
chown -R roboshop:roboshop app/
Validate $? "changing ownership from root to roboshop"
dnf install mongodb-mongosh -y &>>$LOG_FILE
Validate $? "installing mongodb client"
cp catalogue.service /etc/systemd/system/catalogue.service
Validate $? "Copying catalogue services"
INDEX=$(mongosh mongodb.daws86s.fun --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "Load catalogue products"
else
    echo -e "Catalogue products already loaded ... $Y SKIPPING $N"
fi

systemctl daemon-reload
Validate $? "reloading background services"
systemctl enable catalogue
Validate $? "enabling catlogue service"
systemctl start catalogue
Validate $? "Starting catlogue service"