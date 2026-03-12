# number=1
# while [ $number -le 5 ]
#     do
#         echo $number
#         ((number++))
#     done;

file_path=/home/ec2-user/file.txt
# while read line
#     do
#         echo $line
#     done < $file_path

while IFS= read -r line
    do
        echo $line
    done < $file_path