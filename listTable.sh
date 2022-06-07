#!/bin/bash
echo
echo -e "${Blue}Listing all Tables: ${Defualt}"
echo
ls ./databases/$dbname/$filename
echo
echo -e "${Blue}Enter Table Name: ${Defualt}"
read tablename 
if [ -f "databases/$dbname/$tablename" ]; then
	    echo 
		echo -e "${Green}Connected to $tablename table${Defualt}";
		echo
		echo -e "${Blue}Table $tablename ${Defualt}"
        echo
		# Metadata
		awk -v var=$tablename 'BEGIN {FS=":"; print "\t\tTable Name: " var "\n"} {if(NR>1) printf     $1"<"$2">  \t\t"} END{printf "\n"}' "./databases/$dbname/.${tablename}.colmetadata"
		# Data
		awk 'BEGIN{FS=":";OFS="\t   \t\t";ORS="\n";}{  $1=$1; print substr($0, 1, length($0)-1) }' "./databases/$dbname/$tablename"
		echo
		sleep 1
        echo -e "${Blue}Press any key to go back to the Table menu${Defualt}"
		echo
		read key
		case $key in
	
			*)   
				./submenu.sh
				;;

		esac
	else 
		echo
		echo -e "${Red}Table is not exsits!!${Defualt}"	
		./listTable.sh
fi


