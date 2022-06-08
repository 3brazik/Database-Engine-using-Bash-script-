#!/bin/bash

echo
echo -e "${Blue}Listing all Tables: ${Defualt}"
echo
ls ./databases/$dbname/$filename
echo

echo -e "${Blue}Enter table name to UPDATE: ${Defualt}"
echo

read tablename 
if [ -f "./databases/$dbname/$tablename" ]; then
	    echo
		echo -e "${Green}${bold}--> Connected to $tablename Table ${Defualt}";
		echo
		# Metadata
		awk -v var=$tablename 'BEGIN {FS=":"; print "\t\tTable Name: " var "\n"} {if(NR>1) printf     $1"<"$2">  \t\t"} END{printf "\n"}' "./databases/$dbname/.${tablename}.colmetadata"
		# Data
		awk 'BEGIN{FS=":";OFS="\t   \t\t";ORS="\n";}{  $1=$1; print substr($0, 1, length($0)-1) }' "./databases/$dbname/$tablename"
		echo
	else 
	echo
	echo -e "${Red}Table is not exsits !!${Defualt}"	
	echo
	./updateTable.sh
fi

function getRecord {
	foundCheck=1
	recLineNumber=1
	for field in $(cut -f1 -d: "./databases/$dbname/$tablename"); do

		if [[ $field = "$3" ]]; then
			foundCheck=0
			rec=($(cut -d: -f1- "./databases/$dbname/$tablename"))
			let indx=$recLineNumber-1
			old_record="${rec[$indx]}"
			break
		fi
		let recLineNumber=$recLineNumber+1
	done

	return $foundCheck
}

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

while [[ true ]]; do
	echo
	echo -e "${Blue}Enter The Primary Key of Record You Want To UPDATE: ${Defualt}" 
	if ! read pkeyValue; then
		return
	fi

	# check existence of record
	if ! getRecord $dbname $tablename $pkeyValue ; then
		echo 
		echo -e "${Red}---> ERROR > Wrong input, Primary key Not Found in the table! Please enter the correct value  p${Defualt}"
		continue
	fi
	break
done


#internal field separator for each field using ":"
OIFS=$IFS
IFS=":"
#record as string converted to array
record=($old_record) 
IFS=$OIFS
#length of the array
length="${#record[@]}"

#show the data record to the user 
echo 
echo -e "${Green}Here Is The Record Found.${Defualt}"
# Metadata
awk -v var=$tablename 'BEGIN {FS=":"; print "\t\tTable Name: " var "\n"} {if(NR>1) printf     $1"<"$2">  \t\t"} END{printf "\n"}' "./databases/$dbname/.${tablename}.colmetadata"
# Data
awk 'BEGIN{FS=":";OFS="\t   \t\t";ORS="\n";}{  $1=$1; print substr($0, 1, length($0)-1) }' "./databases/$dbname/$tablename"
echo
echo  -e "${Yellow}Please refere to the table schema ABOVE before UPDATING, considering each column DATATYPE !${Defualt}"
#Getting Table Metadata for the table 
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
#Check the data type of the new value 
function check_type {
	case "$1" in
		int )
			if [[ "$2" =~ ^[0-9]+$ ]]; then
				return 0
			else return 1
			fi
			;;
		str )
			if [[ "$2" =~ ^[A-Za-z" "]+$ ]]; then
				return 0
			else return 1
			fi
			;;
		* )
			return 1
			;;
	esac
}

for (( i = 1; i <= $numColumns-2; i++ )); do
	echo 
	while [[ true ]]; do
		echo -e "${Blue}Enter Column Name To Update The Record: ${Defualt}"
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
		echo -e "${Blue}Enter New value Of ${colNames[$index]} : ${Defualt}"
		if ! read newValue; then
			return
		fi
		#check for empty string
			if [ "$newValue" = "" ];then
		echo 
		echo -e "${Red}---> ERROR: colnum name can not be Empty !${Defualt}"
		continue
		fi
		#rejecting colons in column name
		if [[ "$newValue" = *:* ]]; then
			echo 
			echo  -e "${Red}--> ERROR: Colons Are Not Allowed!${Defualt}"
			continue
		fi
		#validate the datatype
		if ! check_type "${colTypes[$index]}" "$newValue"; then
			echo 
			echo  -e "${Red}---> ERROR: Datatype Mismatch, Please Follow The Above Schema Datatype !${Defualt}"
			continue
		fi
		break
	done
 
	#updating the old record
	record[$index]="$newValue"

	#converting array to string
	newRecord=$( IFS=$':'; echo "${record[*]}" )

	#saving new record to the Table
	sed -i 's/^'"$pkeyValue"':.*$/'"$newRecord":'/' "./databases/$dbname/$tablename"
	echo 
	echo -e "${Green}${bold}Record Updated Successfully${Defualt}"
	echo
	echo -e "${Blue}Table $tablename Values After UPDATE ${Defualt}"
	echo

	# Metadata
	awk -v var=$tablename 'BEGIN {FS=":"; print "\t\tTable Name: " var "\n"} {if(NR>1) printf     $1"<"$2">  \t\t"} END{printf "\n"}' "./databases/$dbname/.${tablename}.colmetadata"
	
	# Data
	awk 'BEGIN{FS=":";OFS="\t   \t\t";ORS="\n";}{  $1=$1; print substr($0, 1, length($0)-1) }' "./databases/$dbname/$tablename"
	echo
	
	# check if user want to update again in the record
	echo
	echo -e "${Blue}If You Want To UPDATE Another Value ENTER 'y' or 'Y' to UPDATE or PRESS Any Key to Go to Previous  Menu: ${Defualt}" 
	read 
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		continue
	else
		
		./submenu.sh
	fi
done	
