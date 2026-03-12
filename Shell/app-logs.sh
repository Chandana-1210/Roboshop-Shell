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
        echo "$R Error: Installing $2 is failure $N" | tee -a $log
        exit 1
    else
        echo -e "$G Installing $2 is SUCCESS $N" | tee -a $log
    fi
}


dnf list installed mysql &>> $log
if [ $? -ne 0 ]; then 
    dnf install mysql-server -y &>> $log
    Validate $? "MYSQL"
else
    echo -e "$Y MYSQL already present......skipping....$N" | tee -a $log
fi

dnf list installed nginx &>> $log
if [ $? -ne 0 ]; then 
    dnf install nginx -y
    Validate $? "nginx" &>> $log
else
    echo -e "$Y nginx already present......skipping....$N" | tee -a $log
fi
