#!/bin/bash
echo -e "${Blue}Listing all Tables: ${Defualt}"
ls ./databases/$dbname/$filename
echo
echo -e "${Blue}Enter Table Name to Select From: ${Defualt}"
read tablename 

if [ -f "./databases/$dbname/$tablename" ]; then
	    echo
		echo -e "${Green}-----> Connected to $tablename table .....${Defualt}";
		echo
		echo -e "${Blue}Table $tablename Schema: ${Defualt}"
		cat ./databases/$dbname/.$tablename.colmetadata;
        echo
        echo -e "${Blue}Table $tablename Data: ${Defualt}"
        cat ./databases/$dbname/$tablename ;
		echo
	else 
	echo
	echo -e "${Red}Table is not exsits${Defualt}"	
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
	echo -e "${Blue}Enter Primary key of the Table to Select record: ${Defualt}"
	read primaryKey
	
		# check existence of record
	if ! get_record $primaryKey ; then
		echo 
		echo -e "${Red}---> ERROR > Wrong input, Primary key Not Found in the table! Please enter the correct value  p${Defualt}"
		continue
	fi
	break
break 
done
#array of records
record=($old_record) 

#length of the array
length="${#record[@]}"


echo 
echo -e "${Green}Here Is The Record Found.${Defualt}"


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

for (( i = 1; i <= $numColumns-2; i++ )); do
	echo 
	while [[ true ]]; do
		echo -e "${Blue}Enter Column Name To select The Record: ${Defualt}"
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

	#converting array to string
	newRecord=$( IFS=$':'; echo "${record[*]}" )
	awk -v var=$tablename 'BEGIN {FS=":"; print "\t\t\tTable Name: " var "\n"} {if(NR>1) printf " "$1"<"$2">\t\t"} END{printf "\n"}' "./databases/$dbname/.${tablename}.colmetadata"
	awk -v var=$lineNumber 'BEGIN{FS=":";OFS="    \t\t\t";ORS="\n";}{  if(NR==var){ $1=$1; print " "substr($0, 1, length($0)-2)}}' "./databases/$dbname/$tablename"
	# check if user want to update again in the record
	echo
	echo -e "${Blue}If You Want To UPDATE another value ENTER 'y' or 'Y' to UPDATE or PRESS any key to go to previous Main Menu: ${Defualt}" 
	read 
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		continue
	else
		
		./mainmenu.sh
	fi
	 	

done	