#!/bin/bash

echo
echo -e "${Blue}Listing all Tables: ${Defualt}"
echo
ls ./databases/$dbname/$filename
echo
echo -e "${Blue}Enter Table Name to Select From: ${Defualt}"
echo

read tablename 

if [ -f "./databases/$dbname/$tablename" ]; then
	    echo
		echo -e "${Green}${bold}-----> Connected to $tablename table .....${Defualt}";
		echo
		#metaData
		awk -v var=$tablename 'BEGIN {FS=":"; print "\t\tTable Name: " var "\n"} {if(NR>1) printf     $1"<"$2">  \t\t"} END{printf "\n"}' "./databases/$dbname/.${tablename}.colmetadata"
		# Data
		awk 'BEGIN{FS=":";OFS="\t   \t\t";ORS="\n";}{  $1=$1; print substr($0, 1, length($0)-1) }' "./databases/$dbname/$tablename"
		echo
	else 
	echo
	echo -e "${Red}${bold}Table is not exsits${Defualt}"	
	echo
	./selectTable.sh
fi

function get_record {
	Rec_Check=1
	lineNumber=1
	for field in $(cut -f1 -d: "./databases/$dbname/$tablename"); do

		if [[ $field = "$primaryKey" ]]; then
			Rec_Check=0
			rec=($(cut -d: -f1- "./databases/$dbname/$tablename"))
			let indx=$lineNumber-1
			old_record="${rec[$indx]}"
			break
		fi
		let lineNumber=$lineNumber+1
	done
	return $Rec_Check
}

while [[ true ]]; do
	echo -e "${Blue}Enter Primary key of the Table to Select record: ${Defualt}"
	echo
	read primaryKey
	
		if ! get_record $primaryKey ; then
		echo 
		echo -e "${Red}Record Not Found!${Defualt}"
		continue
		fi
break 
done
#array of records
record=($old_record) 

#length of the array
length="${#record[@]}"


echo 
echo -e "${Green}${bold}Here Is The Record Found.${Defualt}"
echo
awk -v var=$tablename 'BEGIN {FS=":"; print "\t\t\tTable Name: " var "\n"} {if(NR>1) printf     $1"<"$2">  \t\t"} END{printf "\n"}' "./databases/$dbname/.${tablename}.colmetadata"
awk -v var=$lineNumber 'BEGIN{FS=":";OFS="\t   \t\t";ORS="\n";}{  if(NR==var){ $1=$1; print " "substr($0, 1, length($0)-2)}}' "./databases/$dbname/$tablename"
echo
echo
echo -e "${Blue}Press any key to go back to the Table menu${Defualt}"
echo
read key

	case $key in
	
	*)   
		./submenu.sh
		;;

esac
