#!/bin/bash
# number=$1
# if [ $number -lt 10 ]; then
#     echo "given $number is less than 10"
# elif [ $number -eq 10 ]; then 
#     echo "given $number is equal to 10"
# else
#     echo "given $number is greater than 10"
# fi

# number=$1

# if [ $(($number%2)) -eq 0 ]; then 
#     echo "Given $number is even number"
# else
#     echo "Given $number is odd number"
# fi

# file_name=$1
# if [ -f $file_name ]; then 
#     echo "Given $file_name exists already"
# else
#     echo "Given $file_name does not exists"
# fi

# DIR_name=$1
# if [ -d $DIR_name ]; then 
#     echo "Given $DIR_name exists"
# else
#     echo "Given $DIR_name does not exists"
# fi

file_name=$1

if [ -f $file_name ] && [ -r $file_name ]; then 
    echo "file exists and readable"
fi