#!/bin/bash
user_id=$(id -u)

if [ $user_id -ne 0 ]; then 
    echo "Error: Please run the script with root priveleges"
    exit 1
fi


Validate(){
    if [ $1 -ne 0 ]; then 
        echo "Error: Installing $2 is failure"
        exit 1
    else
        echo "Installing $2 is SUCCESS"
    fi
}


dnf list installed mysql
if [ $? -ne 0 ]; then 
    dnf install mysql-server -y
    Validate $? "MYSQL"
else
    echo "MYSQL already present......skipping...."
fi

dnf list installed nginx
if [ $? -ne 0 ]; then 
    dnf install nginx -y
    Validate $? "nginx"
else
    echo "nginx already present......skipping...."
fi
