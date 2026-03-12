#!/bin/bash
user_id=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $user_id -ne 0 ]; then 
    echo -e "$R Error: Please run the script with root priveleges $N"
    exit 1
fi


Validate(){
    if [ $1 -ne 0 ]; then 
        echo "$R Error: Installing $2 is failure $N"
        exit 1
    else
        echo -e "$G Installing $2 is SUCCESS $N"
    fi
}


dnf list installed mysql
if [ $? -ne 0 ]; then 
    dnf install mysql-server -y
    Validate $? "MYSQL"
else
    echo -e "$Y MYSQL already present......skipping....$N"
fi

dnf list installed nginx
if [ $? -ne 0 ]; then 
    dnf install nginx -y
    Validate $? "nginx"
else
    echo -e "$Y nginx already present......skipping....$N"
fi
