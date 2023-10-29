#!/bin/bash

echo "--------------------------
User Name: CHO SEONGMIN
Student Number: 12191678
[ MENU ]
1. Get the data of the movie identified by a specific 'movie id' from 'u.item'
2. Get the data of action genre movies from 'u.item'
3. Get the average 'rating' of the movie identified specific 'movie id' from 'u.data'
4. Delete the 'IMDb URL' from 'u.item'
5. Get the data about users from 'u.user'
6. Modify the format of 'release date' in 'u.item'
7. Get the data of movies reated by a specific 'user id' from 'u.data'
8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'
9. Exit
--------------------------"
while :
do
	read -p "Enter your choice [ 1-9 ] " num
	case $num in
		1)
			echo " "
			read -p "Please enter 'movie id' (1~1682) : " mid
			echo " "
			cat u.item | awk -F\| -v id=$mid '$1==id {print }'
			echo " "
			;;
		2)
			echo " "
			read -p "Do you want to get the data of 'action' genre movies from 'u.item'? (y/n) : " reply
			case $reply in
				Y|y)
					echo " "
					cat u.item | awk -F\| '$7==1{print $1, $2}' | head -n 10
					echo " "
					;;
				N|n)
					echo " "
					echo "Okay"
					echo " "
					;;
			esac
			;;
		3)
			echo " "
			read -p "Please enter the 'movie id' (1~1682) : " mid
			echo " "
			cat u.data | awk -v id=$mid '$2==id {sum+=$3} $2==id {count++} END {printf("average rating of %d : %.5f \n", id, sum/count)}'
			echo " "
			;;
		4)
			echo " "
			read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n) : " reply
			echo " "
			case $reply in 
				Y|y)
					cat u.item | awk -F \| '{print}' | sed -E "s/http:\/\/.+\)//g" | head -n 10
					;;
				N|n)
					echo "Okay"
					;;
			esac
			echo " "
			;;
		5)
			echo " "
			read -p "Do you want to get the data about users from 'u.user'? (y/n) : " reply
			echo " "
			case $reply in
				Y|y)
					cat u.user | awk -F \| '{printf("user %d is %d years old %s %s\n",$1, $2, $3, $4)}' | sed -e "s/M/male/g" -e "s/F/female/g" | head -n 10
					;;
				N|n)
					echo "Okay"
					;;
			esac
			echo " "
			;;
		6)
			echo " "
			read -p "Do you want to Modify the format of 'release data' in 'u.item'? (y/n) : " reply
			echo " "
			case $reply in
				Y|y)
					cat u.item | awk -F \| '$1>1672 {print}'| sed -e "s/Jan/01/g" -e "s/Feb/02/g" -e "s/Mar/03/g" -e "s/Apr/04/g" -e "s/May/05/g" -e "s/Jun/06/g" -e "s/Jul/07/g" -e "s/Aug/08/g" -e "s/Sep/09/g" -e "s/Oct/10/g" -e "s/Nov/11/g" -e "s/Dec/12/g" | sed -E "s/([0-9]{2})-([0-9]{2})-([0-9]{4})/\3\2\1/g"
					;;
				N|n)
					echo "Okay"
					;;
			esac
			echo " "
			;;
		7)
			echo " "
			read -p "Please enter the 'user.id' (1~943) : " uid
			echo " "
			cat u.data | awk -v id=$uid '$1==id {print $2}' | sort -n | tr '\n' '|' | sed 's/.$//'
			ids=$(cat u.data | awk -v id=$uid '$1==id {print $2}' | sort -n | head -n 10)
			echo " "
			echo " "
			for id in $ids; do
				cat u.item | awk -F \| -v id=$id '$1==id {printf("%d|%s\n",$1, $2)}' | head -n 10
			done
			echo " "
			;;
		8)
			echo " "
			read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'? (y/n) : " reply
			echo " "
			case $reply in
				Y|y)
					uid=$(cat u.user | awk -F \| '{if ($2 >= 20 && $2 <= 29 && $4=="programmer") print $1}')
					mid_rate=""
					mid=""
					for id in $uid; do
						mid+=$(cat u.data | awk -v id=$id '$1==id {print $2}')" "
						
						mid_rate+=$(cat u.data | awk -v id=$id '$1==id {printf("%d\t%d\n", $2, $3)}')" "
					done
					
					sortmid=$(echo "${mid[@]}" | tr ' ' '\n' | sort -n -u)
					mid_rate_md=$(echo "${mid_rate[@]}" | tr ' ' '\n')
					if [ -e tmpmid ]; then
						rm -r tmpmid
					fi
					touch tmpmid
					echo "${mid_rate_md[@]}" > tmpmid
					for id in $sortmid; do
						cat tmpmid | awk -v tmp=$id '$1==tmp {sum+=$2} $1==tmp {cnt++} END {printf("%d|%g\n", tmp, sum/cnt)}'
					done
					;;
				N|n)
					echo "OKay"
					;;
			esac
			echo " "
			;;
		9)
			echo "Bye!"
			exit 0
			;;
		*)
			echo "Wrong Input"
			;;
	esac
done
