#!/bin/bash
user_id=$(id -u)

if [ $user_id -ne 0 ]; then 
    echo "Error: Please run the script with root priveleges"
fi

dnf install mysql-server -y

if [ $? -ne 0 ]; then 
    echo "Error: Installing MYSQL is failure"
else
    echo "Installing MYSQL is SUCCESS"
fi

