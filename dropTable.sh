#!/bin/bash
echo 
echo -e "${Blue}Listing All Tables${Defualt}"
echo
ls ./databases/$dbname/$filename
echo
echo -e "${Blue}Please enter Table name to DROP: ${Defualt}"
read filename
if [ -f "./databases/$dbname/$filename" ]
then
	echo
 	echo -e "${Blue}Deleting Table.........${Defualt}"
	rm  ./databases/$dbname/$filename
	rm 	./databases/$dbname/.$filename.colmetadata
	echo
	echo -e "${Green}Table deleted succesfully${Defualt}"
	sleep 1 
	./mainmenu.sh
else
	echo -e "${Red}--> ERROR Enter Exsisted Table Name !!${Defualt}"
	./dropTable.sh
fi