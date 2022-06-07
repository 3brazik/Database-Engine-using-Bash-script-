#!/bin/bash
export PS2="Create-DB >"
echo 
echo -e "${Green}------>  Create Database  <------${Defualt}"
echo
echo -e "${Blue}Please Enter Database Name: ${Defualt}"
echo
read dbname
while [[ true ]];do
	#----> checking if contain spaces 
	if [[ $dbname = *" "* ]];
		then
		echo
		echo -e "${Red}--> ERROR : Database name cannot Contain space.${Defualt}"
		echo
		./createDB.sh
	fi
	#Checking that  no special char in Database name 
    allchar=${dbname}
	if [[ $allchar =~ ["!"?$%@"^"+="&""#"":""("")""'""}"";""{""<",.">""/"] ]];then
		echo
		echo -e "${Red} --> ERROR : Database name cannot Start or Contain Special Char. ${Defualt}"
		echo
		./createDB.sh
	fi

	#Checking the first char is not a Number
	firstC=${dbname:0:1}
	if [[ $firstC =~ [0-9] ]]; then
		echo 
        echo -e "${Red}--> ERROR: Datebase name cannot start with number.${Defualt}" 
		echo
        ./createDB.sh
	fi

	#Checking For Empty String
	if [ "$dbname" = "" ];
		then
		echo 
		echo -e "${Red}--> ERROR: Database name can not be Empty !${Defualt}"
		./createDB.sh
	fi

	#Creating DB after checking for the name 
	if [ -d "./databases/$dbname" ]; then
		echo
		echo -e "${Red}--> Database Already Exsit!!${Defualt}" 
		echo
		./createDB.sh	
	fi

	if ! [ -d "./databases/$dbname" ];
	then
	 	mkdir ./databases/$dbname;
		echo
		echo -e "${Green}Database $dbname  is Created sucsessfully.${Defualt}"
		echo
		sleep 1
		echo -e "${Blue}Press any key to go back to the main menu${Defualt}"
		echo
		read key

		case $key in
	
			*)   
				./mainmenu.sh
				;;

		esac
	fi
break;
done








