#!/bin/bash
echo
echo -e "${Blue}------> Choose database to delete from the following list <------${Defualt}"
echo
 ls ./databases
echo
echo -e "${Blue}Please Enter Database Name to DROP: ${Defualt}"
echo
read dbname
if [ -d "./databases/$dbname" ]
	then
		echo
		echo -e "${Blue}Deleting Database $dbname ....${Defualt}"
		sleep 1
		echo
		rm -rf ./databases/$dbname
		echo -e "${Green}Database $dbname Deleted Succesfully${Defualt}"
		sleep 1
		echo
		echo -e "${Blue}Press any key to go back to the main menu${Defualt}"
		echo
		read key
		case $key in
	
			*)   
				./mainmenu.sh
				;;

		esac				
	else
	
		echo -e "${Red}Enter Exsited Database Name${Defualt}"
		echo
		./dropDB.sh
fi
