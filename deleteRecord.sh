#!/bin/bash
echo -e "${Blue}Listing all Tables: ${Defualt}"
ls ./databases/$dbname/$filename
echo
echo -e "${Blue}Enter table name to Select From : ${Defualt}"
read tablename 

if [ -f "./databases/$dbname/$tablename" ]; then
	    echo
		echo -e "${Green}-----> Connected to $tablename table .....${Defualt}";
		echo
		# Metadata
		awk -v var=$tablename 'BEGIN {FS=":"; print "\t\tTable Name: " var "\n"} {if(NR>1) printf     $1"<"$2">  \t\t"} END{printf "\n"}' "./databases/$dbname/.${tablename}.colmetadata"
		# Data
		awk 'BEGIN{FS=":";OFS="\t   \t\t";ORS="\n";}{  $1=$1; print substr($0, 1, length($0)-1) }' "./databases/$dbname/$tablename"
		echo
    else 
	echo
	echo -e "${Red}----> ERROR Table is not exsits${Defualt}"	
	echo
	./deleteRecord.sh
fi

function delete_record {
	foundflagg=1
	for field in $(cut -f1 -d: "./databases/$dbname/$tablename"); do

		if [[ $field = "$1" ]]; then
			foundflagg=0
			sed -i '/^'"$1"':.*$/d' "./databases/$dbname/$tablename"
			break
		fi
	done
	return $foundflagg
}

while [ true ]; do
	echo -e "${Blue}Please enter primary key: ${Defualt}"
	read PKey
	if delete_record "$PKey" ; then
		echo -e "${Green}Record Deleted${Defualt}"
		echo
		echo -e "${Blue}Table records after deletion:${Defualt}"
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
	fi
done




