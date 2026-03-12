#!/bin/bash
user_id=$(id -u)

if [ $user_id -ne 0 ]; then 
    echo "Error: Please run the script with root priveleges"
fi


Validate(){
    if [ $1 -ne 0 ]; then 
        echo "Error: Installing $2 is failure"
    else
        echo "Installing $2 is SUCCESS"
    fi
}

# dnf install list available mysql
# if [ $? -ne 0 ]; then 
#     dnf install mysql-server -y
#     Validate $? "MYSQL"
# else
#     echo "MYSQL already present......skipping...."
# fi

dnf install mysql-server -y
Validate $? "MYSQL"
dnf install python3 -y
Validate $? "python"
dnf install redis -y
Validate $? "redis"
