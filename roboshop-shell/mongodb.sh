#!/bin/bash
user_id=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
log_folder=/var/log/shell-script
script_name=$( echo $0 | cut -d "." -f1 )
log="$log_folder/$script_name.log" #/var/log/shell-script/app-logs.log

mkdir -p $log_folder
echo "script execution started at : $(date)" | tee -a $log
if [ $user_id -ne 0 ]; then 
    echo -e "$R Error: Please run the script with root priveleges $N" | tee -a $log
    exit 1
fi


Validate(){
    if [ $1 -ne 0 ]; then 
        echo "$R Error: $2 is failure $N" | tee -a $log
        exit 1
    else
        echo -e "$G  $2 is SUCCESS $N" | tee -a $log
    fi
}

cp mongodb.repo /etc/yum.repos.d/mongo.repo
Validate $? "Coping Mongodb.repo"
dnf install mongodb-org -y &>> $log
Validate $? "Installing Mongodb"
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongo.conf
Validate $? "allowing remote connections to mongodb"
systemctl restart Mongod
Validate $? "restart Mongodb"
systemctl enable Mongod
Validate $? "enable Mongodb"