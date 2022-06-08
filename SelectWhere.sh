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
		echo -e "${Green}-----> Connected to $tablename table .....${Defualt}";
		echo	
		# Metadata
		awk -v var=$tablename 'BEGIN {FS=":"; print "\t\tTable Name: " var "\n"} {if(NR>1) printf     $1"<"$2">  \t\t"} END{printf "\n"}' "./databases/$dbname/.${tablename}.colmetadata"
		# Data
		awk 'BEGIN{FS=":";OFS="\t   \t\t";ORS="\n";}{  $1=$1; print substr($0, 1, length($0)-1) }' "./databases/$dbname/$tablename"
		echo
	else 
	echo
	echo -e "${Red}Table is not exsits${Defualt}"	
	echo
	./SelectWhere.sh
fi

function getTableMetadata {
	tblname=$2
	#array of columns names
	colNames=()
	#array of columns datatype
	colTypes=()

	field1=($(cut -d: -f1 ./databases/$dbname/.${tablename}.colmetadata))
	field2=($(cut -d: -f2 ./databases/$dbname/.${tablename}.colmetadata))

	#name of the primary key column
	pkName=${field2[0]}

	#filling column names in array
	for i in "${field1[@]:1}"; do
		colNames+=("$i")
	done

	#filling column types in array
	for j in "${field2[@]:1}"; do
		colTypes+=("$j")
	done

	#getting number of columns in table
	numColumns=$(wc -l "./databases/$dbname/.${tablename}.colmetadata" | cut -f1 -d" ")
}

#Getting arrays from the table meta data file of selected table
getTableMetadata $dbname $tablename


#array of records
record=($old_record) 

#length of the array
length="${#record[@]}"

getTableMetadata $dbname $tablename 

#Getting colnums 
function getColumn {
    declare -a array=("${!1}")
    #value
	v=$2
    CHECK=1
    index=0
    for element in "${array[@]}"; do
        if [[ $element == $v ]]; then
            CHECK=0
            break
        fi
        let index=$index+1
    done
    return $CHECK
}

while [[ true ]]; do
	echo
	echo -e "${Blue}Enter Column Name To select The Record: ${Defualt}"
	echo
	if ! read colName; then
		return
	fi
	#check for empty string
	if [ "$colName" = "" ];then
	echo 
	echo -e "${Red}--> ERROR: colnum name can not be Empty !${Defualt}"
	continue
	fi
	#rejecting colons in column name
	if [[ "$colName" = *:* ]]; then
		echo 
		echo -e "${Red}--> ERROR: colon is Not Allowed, Please Refer To The Schema Above!${Defualt}"
		continue
	fi
	#check existence of colName
	if ! getColumn colNames[@] "$colName" ; then
		echo 
		echo -e "${Red}--> ERROR Column Not Found, Please Refer To The Table Schema Above !${Defualt}"
		continue
	fi
	break
done


while [[ true ]]; do
	echo
	echo -e "${Blue}Enter Column Value To Select The Record: ${Defualt}"
	echo
	if ! read colData; then
		return
	fi

	#check for empty string
	if [ "$colData" = "" ];then
	echo 
	echo -e "${Red}--> ERROR: colnum Value cannot be Empty !${Defualt}"
	continue
	fi

	#rejecting colons in column name
	if [[ "$colData" = *:* ]]; then
		echo 
		echo -e "${Red}--> ERROR: colon is Not Allowed, Please Refer To The Schema Above!${Defualt}"
		continue
	fi

	break
done

	echo
	grep -w $colData "./databases/$dbname/${tablename}" 
	echo
	echo -e "${Blue}If You Want To Select Another Record ENTER 'y' or 'Y' to UPDATE or PRESS Any Key To Go To Previous Menu: ${Defualt}" 
	read 
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		./SelectWhere.sh
	else
		
		./submenu.sh
	fi
	 	