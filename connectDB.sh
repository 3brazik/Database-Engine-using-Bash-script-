#!/bin/bash
echo
echo -e "${Blue}Listting All Databases${Defualt}"
ls ./databases
echo
echo -e "${Blue}Write Database name you want to Connect: ${Defualt}"
echo
read dbname	

if [ -d "./databases/$dbname" ]; then
	    echo
		echo -e "${Green}Connected to $dbname database successfully ${Defualt}";
		echo
		sleep 1
		export dbname
		./submenu.sh
		cd ./databases/$dbname;
	
	else 
	echo
	echo -e "${Red}Database is not exsits${Defualt}"	
	
	./connectDB.sh
fi
exec bash
