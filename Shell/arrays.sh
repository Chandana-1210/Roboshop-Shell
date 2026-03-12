# servers=("server1" "server2" "server3")
# for s in "${servers[@]}"
#     do 
#         echo  $s
#     done;

declare -A user
user[name]="Keerthi"
user[role]="devops"
echo ${user[name]}
echo ${user[role]}

#Use normal arrays when your data is ordered and numeric indexing works.

#Use associative arrays when your data has named keys and you want key → value mapping.
